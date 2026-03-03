{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with orders as (

    select * 
    from {{ ref('stg_tpch_orders') }}

),

orders_with_sk as (

    select
        o.order_id,
        d.customer_sk,
        o.order_date,
        o.order_status,
        o.total_price
    from orders o
    left join {{ ref('dim_customers') }} d
        on o.customer_id = d.customer_id

)

select *
from orders_with_sk

{% if is_incremental() %}

where order_date > (
    select max(order_date) from {{ this }}
)

{% endif %}