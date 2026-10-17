
-- Add a column, show old rows have NULL, show it's queryable.
-- Iceberg adds the column to metadata only — no file rewrite.

-- 1. Before: current schema of dim_part
DESCRIBE silver.q16.dim_part;

-- 2. Add a new column
ALTER TABLE silver.q16.dim_part ADD COLUMN part_name varchar;

-- 3. After: new column present
DESCRIBE silver.q16.dim_part;

-- 4. Old rows: part_name is NULL (no rewrite happened)
SELECT partkey, brand, type, size, part_name
FROM silver.q16.dim_part
LIMIT 5;

-- 5. New writes can fill the column (optional demo)
-- UPDATE is not supported on Iceberg in Trino by default;
-- simulate via INSERT ... SELECT with the new column, or
-- just show that the column exists and is nullable.

-- 6. Confirm the schema change is recorded in snapshots
SELECT committed_at, snapshot_id, operation
FROM silver.q16."dim_part$snapshots"
ORDER BY committed_at;