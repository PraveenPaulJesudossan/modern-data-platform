{{ config(
    materialized='incremental',
    unique_key=['order_id','line_number']
) }}

with revenue as (

    select *
    from {{ ref('int_order_items') }}

),

revenue_with_sk as (

    select
        r.order_id,
        dc.customer_sk,
        dp.product_sk,
        r.supplier_id,
        r.line_number,
        r.order_date,
        r.quantity,
        r.net_revenue
    from revenue r
    left join {{ ref('dim_customers') }} dc
        on r.customer_id = dc.customer_id
    left join {{ ref('dim_products') }} dp
        on r.product_id = dp.product_id

)

select *
from revenue_with_sk

{% if is_incremental() %}

where order_date > (
    select max(order_date) from {{ this }}
)

{% endif %}