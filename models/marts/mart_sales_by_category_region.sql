select
    p.category,
    c.region,
    sum(fs.total_amount)
from {{ ref('stg_retail__fact_sales') }} as fs
join {{ ref('stg_retail__dim_products') }} as p
    on fs.product_id = p.product_id
join {{ ref('stg_retail__dim_customers')}} as c
    on fs.customer_id = c.customer_id
group by p.category, c.region
order by 3

