select
    p_partkey     as product_id,
    p_name        as product_name,
    p_mfgr        as manufacturer,
    p_brand       as brand,
    p_type        as product_type,
    p_size        as size,
    p_container   as container,
    p_retailprice as retail_price,
    p_comment     as comments
from {{ source('tpch', 'PART') }}