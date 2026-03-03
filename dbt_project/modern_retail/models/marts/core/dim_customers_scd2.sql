select
    customer_id,
    customer_name,
    nation_id,
    account_balance,
    market_segment,
    dbt_valid_from,
    dbt_valid_to,
    dbt_scd_id
from {{ ref('customer_snapshot') }}