with sales_by_store as (
    select
        store_id,
        count(distinct sale_id)  as total_orders,
        sum(total_amount)        as total_revenue
    from {{ ref('int_sales_joined') }}
    group by store_id
),

employee_counts as (
    select
        store_id,
        count(distinct employee_id) as employee_count
    from {{ ref('stg_retail__dim_employees') }}
    group by store_id
)

select
    s.store_id,
    st.store_name,
    st.location,
    s.total_orders,
    s.total_revenue,
    e.employee_count,
    round(s.total_revenue / nullif(e.employee_count, 0), 2) as revenue_per_employee
from sales_by_store as s
join {{ ref('stg_retail__dim_stores') }} as st
    on s.store_id = st.store_id
left join employee_counts as e
    on s.store_id = e.store_id
order by revenue_per_employee desc