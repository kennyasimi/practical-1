-- 05_silver_q16.sql
-- Silver layer for TPC-H Q16; scale factor sf1
-- Cleaned / filtered / joined data.
-- Format: PARQUET, codec: ZSTD.

CREATE SCHEMA IF NOT EXISTS silver.q16;

SET SESSION silver.compression_codec = 'ZSTD';

-- dim_part: parts that pass Q16's brand/type/size filters
DROP TABLE IF EXISTS silver.q16.dim_part;
CREATE TABLE silver.q16.dim_part AS
SELECT partkey, brand, type, size
FROM bronze.q16.raw_part
WHERE brand <> 'Brand#45'
  AND type NOT LIKE 'MEDIUM POLISHED%'
  AND size IN (49, 14, 23, 45, 19, 3, 36, 9);

-- dim_supplier: "good" suppliers (no Customer Complaints)

DROP TABLE IF EXISTS silver.q16.dim_supplier;
CREATE TABLE silver.q16.dim_supplier AS
SELECT suppkey
FROM bronze.q16.raw_supplier
WHERE comment NOT LIKE '%Customer%Complaints%';

-- fact_partsupp: partsupp rows, restricted to good suppliers
DROP TABLE IF EXISTS silver.q16.fact_partsupp;
CREATE TABLE silver.q16.fact_partsupp AS
SELECT ps.partkey, ps.suppkey
FROM bronze.q16.raw_partsupp AS ps
JOIN silver.q16.dim_supplier AS s
  ON ps.suppkey = s.suppkey;

-- Sanity check
SELECT 'dim_part'      AS tbl, count(*) FROM silver.q16.dim_part
UNION ALL SELECT 'dim_supplier',  count(*) FROM silver.q16.dim_supplier
UNION ALL SELECT 'fact_partsupp', count(*) FROM silver.q16.fact_partsupp;