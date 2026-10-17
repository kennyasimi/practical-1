-- §5: sizes (MB) and codec confirmation for the 4 Bronze copies.
-- Fills the "Размер Bronze, МБ" column of the §5 table.

-- Sizes in MB
SELECT 'NONE'   AS codec, round(sum(file_size_in_bytes)/1024.0/1024.0, 2) AS mb FROM bronze.q16."raw_partsupp_none$files"
UNION ALL
SELECT 'SNAPPY', round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM bronze.q16."raw_partsupp_snappy$files"
UNION ALL
SELECT 'GZIP',   round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM bronze.q16."raw_partsupp_gzip$files"
UNION ALL
SELECT 'ZSTD',   round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM bronze.q16."raw_partsupp_zstd$files";

-- Codec confirmation (write.parquet.compression-codec)
SELECT 'NONE'   AS codec, value FROM bronze.q16."raw_partsupp_none$properties"
WHERE key = 'write.parquet.compression-codec'
UNION ALL
SELECT 'SNAPPY', value FROM bronze.q16."raw_partsupp_snappy$properties"
WHERE key = 'write.parquet.compression-codec'
UNION ALL
SELECT 'GZIP',   value FROM bronze.q16."raw_partsupp_gzip$properties"
WHERE key = 'write.parquet.compression-codec'
UNION ALL
SELECT 'ZSTD',   value FROM bronze.q16."raw_partsupp_zstd$properties"
WHERE key = 'write.parquet.compression-codec';

-- File counts 
SELECT 'NONE'   AS codec, count(*) AS files FROM bronze.q16."raw_partsupp_none$files"
UNION ALL
SELECT 'SNAPPY', count(*) FROM bronze.q16."raw_partsupp_snappy$files"
UNION ALL
SELECT 'GZIP',   count(*) FROM bronze.q16."raw_partsupp_gzip$files"
UNION ALL
SELECT 'ZSTD',   count(*) FROM bronze.q16."raw_partsupp_zstd$files";