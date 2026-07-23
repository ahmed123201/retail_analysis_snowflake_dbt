with customer_metrics as (
    select
        customer_id,
        region,
        count(distinct sale_id)                                   as order_count,
        sum(total_amount)                                         as lifetime_value,
        max(sale_date)                                            as last_purchase_date,
        datediff('day', max(sale_date), current_date())           as days_since_last_purchase
    from {{ ref('int_sales_joined') }}
    group by customer_id, region
)

select
    customer_id,
    region,
    order_count,
    lifetime_value,
    last_purchase_date,
    days_since_last_purchase,
    case
        when lifetime_value >= 1000 and days_since_last_purchase <= 90 then 'High-value loyal'
        when lifetime_value >= 1000 and days_since_last_purchase > 90 then 'High-value at-risk'
        when lifetime_value < 1000 and days_since_last_purchase <= 90 then 'Low-value active'
        else 'Lapsed'
    end as customer_segment
from customer_metrics