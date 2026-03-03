with orders as (

    select * from {{ ref('stg_tpch_orders') }}

),

lineitems as (

    select * from {{ ref('stg_tpch_lineitems') }}

)

select
    l.order_id,
    o.customer_id,
    l.product_id,
    l.supplier_id,
    l.line_number,
    o.order_date,

    l.quantity,
    l.extended_price,
    l.discount,

    -- Revenue calculation
    l.extended_price * (1 - l.discount) as net_revenue

from lineitems l
join orders o
    on l.order_id = o.order_id