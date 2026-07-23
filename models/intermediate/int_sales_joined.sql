select
    fs.sale_id,
    fs.customer_id,
    fs.product_id,
    fs.store_id,
    fs.sale_date,
    fs.quantity_sold,
    fs.total_amount,
    p.product_name,
    p.category,
    p.price,
    c.region,
    c.signup_date
from {{ ref('stg_retail__fact_sales') }} as fs
join {{ ref('stg_retail__dim_products') }} as p
    on fs.product_id = p.product_id
join {{ ref('stg_retail__dim_customers') }} as c
    on fs.customer_id = c.customer_id