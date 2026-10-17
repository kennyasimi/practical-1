-- 08_sizes_q16.sql
-- Row counts and on-disk sizes (MB) for every medallion table.


-- Row counts
SELECT 'bronze.raw_part'      AS tbl, count(*) FROM bronze.q16.raw_part
UNION ALL SELECT 'bronze.raw_partsupp',  count(*) FROM bronze.q16.raw_partsupp
UNION ALL SELECT 'bronze.raw_supplier',  count(*) FROM bronze.q16.raw_supplier
UNION ALL SELECT 'silver.dim_part',      count(*) FROM silver.q16.dim_part
UNION ALL SELECT 'silver.dim_supplier',  count(*) FROM silver.q16.dim_supplier
UNION ALL SELECT 'silver.fact_partsupp', count(*) FROM silver.q16.fact_partsupp
UNION ALL SELECT 'gold.parts_by_brand_type_size', count(*) FROM gold.q16.parts_by_brand_type_size;

-- Sizes in MB ($files)
SELECT 'bronze.raw_part'      AS tbl, round(sum(file_size_in_bytes)/1024.0/1024.0, 2) AS mb FROM bronze.q16."raw_part$files"
UNION ALL SELECT 'bronze.raw_partsupp',  round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM bronze.q16."raw_partsupp$files"
UNION ALL SELECT 'bronze.raw_supplier',  round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM bronze.q16."raw_supplier$files"
UNION ALL SELECT 'silver.dim_part',      round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM silver.q16."dim_part$files"
UNION ALL SELECT 'silver.dim_supplier',  round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM silver.q16."dim_supplier$files"
UNION ALL SELECT 'silver.fact_partsupp', round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM silver.q16."fact_partsupp$files"
UNION ALL SELECT 'gold.parts_by_brand_type_size', round(sum(file_size_in_bytes)/1024.0/1024.0, 2) FROM gold.q16."parts_by_brand_type_size$files";

-- Codec actually written ($properties)
SELECT 'bronze.raw_part' AS tbl, key, value
FROM bronze.q16."raw_part$properties"
WHERE key LIKE 'write.%.compression-codec' OR key = 'write.format.default'
UNION ALL
SELECT 'bronze.raw_partsupp', key, value
FROM bronze.q16."raw_partsupp$properties"
WHERE key LIKE 'write.%.compression-codec' OR key = 'write.format.default'
UNION ALL
SELECT 'bronze.raw_supplier', key, value
FROM bronze.q16."raw_supplier$properties"
WHERE key LIKE 'write.%.compression-codec' OR key = 'write.format.default';