select t.year,
    t.month,
    sum(total_amount)
from {{ ref('stg_retail__fact_sales') }} as fs
join {{ ref('stg_retail__dim_stores')}} as st
    on fs.store_id = st.store_id
join {{ ref('stg_retail__dim_time')}} as t
    on fs.sale_date = t.date_id

group by t.year, t.month
order by 1,2
