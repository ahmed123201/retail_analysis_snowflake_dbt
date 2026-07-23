with sales_by_product_store as (
    select
        product_id,
        store_id,
        sum(quantity_sold) as total_quantity_sold
    from {{ ref('stg_retail__fact_sales') }}
    group by product_id, store_id
),

inventory_by_product_store as (
    select
        product_id,
        store_id,
        avg(stock_level) as avg_stock_level
    from {{ ref('stg_retail__fact_inventory') }}
    group by product_id, store_id
)

select
    coalesce(s.product_id, i.product_id)   as product_id,
    coalesce(s.store_id, i.store_id)       as store_id,
    p.product_name,
    p.category,
    st.store_name,
    coalesce(s.total_quantity_sold, 0)     as total_quantity_sold,
    coalesce(i.avg_stock_level, 0)         as avg_stock_level,
    round(
        coalesce(i.avg_stock_level, 0) / nullif(coalesce(s.total_quantity_sold, 0), 0),
        2
    ) as stock_to_sales_ratio,
    case
        when s.total_quantity_sold is null or s.total_quantity_sold = 0
            then 'No sales — possible dead stock'
        when i.avg_stock_level is null or i.avg_stock_level = 0
            then 'No stock — stockout risk'
        when (i.avg_stock_level / s.total_quantity_sold) > 3
            then 'Overstocked'
        when (i.avg_stock_level / s.total_quantity_sold) < 0.5
            then 'Stockout risk'
        else 'Healthy'
    end as inventory_status

from sales_by_product_store as s
full outer join inventory_by_product_store as i
    on s.product_id = i.product_id
    and s.store_id = i.store_id
left join {{ ref('stg_retail__dim_products') }} as p
    on coalesce(s.product_id, i.product_id) = p.product_id
left join {{ ref('stg_retail__dim_stores') }} as st
    on coalesce(s.store_id, i.store_id) = st.store_id
