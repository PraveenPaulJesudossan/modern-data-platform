{% snapshot customer_snapshot %}

{{
    config(
      target_schema='DBT_SCHEMA',
      unique_key='customer_id',
      strategy='check',
      check_cols=['customer_name','market_segment','account_balance']
    )
}}

select *
from {{ ref('stg_tpch_customers') }}

{% endsnapshot %}