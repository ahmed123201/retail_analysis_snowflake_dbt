select
    category,
    region,
    count(distinct sale_id)   as total_orders,
    sum(quantity_sold)        as total_units_sold,
    sum(total_amount)         as total_revenue,
    avg(total_amount)         as avg_order_value
from {{ ref('int_sales_joined') }}
group by category, region
order by total_revenue desc