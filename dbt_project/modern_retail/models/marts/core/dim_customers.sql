select
    {{ generate_surrogate_key(['customer_id']) }} as customer_sk,
    customer_id,
    customer_name,
    nation_id,
    account_balance,
    market_segment
from {{ ref('stg_tpch_customers') }}