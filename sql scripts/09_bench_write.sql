

-- §5: create 4 Bronze copies of partsupp, one per codec.
-- Format: PARQUET. Codec set per session before each CTAS.
-- Source: tpch.sf1.partsupp (sf1, 800000 rows).

CREATE SCHEMA IF NOT EXISTS bronze.q16;

-- NONE -------------------------------------------------------
SET SESSION bronze.compression_codec = 'NONE';
DROP TABLE IF EXISTS bronze.q16.raw_partsupp_none;
CREATE TABLE bronze.q16.raw_partsupp_none AS
SELECT partkey, suppkey FROM tpch.sf1.partsupp;

-- SNAPPY -----------------------------------------------------
SET SESSION bronze.compression_codec = 'SNAPPY';
DROP TABLE IF EXISTS bronze.q16.raw_partsupp_snappy;
CREATE TABLE bronze.q16.raw_partsupp_snappy AS
SELECT partkey, suppkey FROM tpch.sf1.partsupp;

-- GZIP -------------------------------------------------------
SET SESSION bronze.compression_codec = 'GZIP';
DROP TABLE IF EXISTS bronze.q16.raw_partsupp_gzip;
CREATE TABLE bronze.q16.raw_partsupp_gzip AS
SELECT partkey, suppkey FROM tpch.sf1.partsupp;

-- ZSTD -------------------------------------------------------
SET SESSION bronze.compression_codec = 'ZSTD';
DROP TABLE IF EXISTS bronze.q16.raw_partsupp_zstd;
CREATE TABLE bronze.q16.raw_partsupp_zstd AS
SELECT partkey, suppkey FROM tpch.sf1.partsupp;