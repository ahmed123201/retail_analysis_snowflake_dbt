select
    date_trunc('month', sale_date) as sale_month,
    count(distinct sale_id)        as total_orders,
    sum(quantity_sold)             as total_units_sold,
    sum(total_amount)              as total_revenue
from {{ ref('int_sales_joined') }}
group by date_trunc('month', sale_date)
order by sale_month