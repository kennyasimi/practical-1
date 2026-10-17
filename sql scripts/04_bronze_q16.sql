-- 04_bronze_q16.sql
-- Bronze layer for TPC-H Q16 (variant 4), scale factor sf1
-- Raw tables, only the columns Q16 needs.
-- Format: PARQUET, codec: ZSTD 

CREATE SCHEMA IF NOT EXISTS bronze.q16;

-- ZSTD 
SET SESSION bronze.compression_codec = 'ZSTD';

-- part: keep partkey, brand, type, size 
DROP TABLE IF EXISTS bronze.q16.raw_part;
CREATE TABLE bronze.q16.raw_part AS
SELECT partkey, brand, type, size
FROM tpch.sf1.part;

-- partsupp: keep partkey, suppkey (2 of 5 columns)
DROP TABLE IF EXISTS bronze.q16.raw_partsupp;
CREATE TABLE bronze.q16.raw_partsupp AS
SELECT partkey, suppkey
FROM tpch.sf1.partsupp;

-- supplier: keep suppkey, comment (2 of 7 columns)
DROP TABLE IF EXISTS bronze.q16.raw_supplier;
CREATE TABLE bronze.q16.raw_supplier AS
SELECT suppkey, comment
FROM tpch.sf1.supplier;

-- check
SELECT 'raw_part'      AS tbl, count(*) FROM bronze.q16.raw_part
UNION ALL SELECT 'raw_partsupp',  count(*) FROM bronze.q16.raw_partsupp
UNION ALL SELECT 'raw_supplier',  count(*) FROM bronze.q16.raw_supplier;
