select
    {{ generate_surrogate_key(['product_id']) }} as product_sk,
    product_id,
    product_name,
    manufacturer,
    brand,
    product_type,
    size,
    container,
    retail_price
from {{ ref('stg_tpch_parts') }}