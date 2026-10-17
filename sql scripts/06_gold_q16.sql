
-- Gold layer for TPC-H Q16; scale factor sf1
-- Final business aggregate: parts by brand/type/size + supplier count.
-- Format: PARQUET, codec: ZSTD.

CREATE SCHEMA IF NOT EXISTS gold.q16;

SET SESSION gold.compression_codec = 'ZSTD';

DROP TABLE IF EXISTS gold.q16.parts_by_brand_type_size;
CREATE TABLE gold.q16.parts_by_brand_type_size AS
SELECT
  p.brand,
  p.type,
  p.size,
  count(DISTINCT f.suppkey) AS supplier_cnt
FROM silver.q16.dim_part AS p
JOIN silver.q16.fact_partsupp AS f
  ON p.partkey = f.partkey
GROUP BY p.brand, p.type, p.size;

-- Preview
SELECT brand, type, size, supplier_cnt
FROM gold.q16.parts_by_brand_type_size
ORDER BY supplier_cnt DESC, brand, type, size
LIMIT 20;