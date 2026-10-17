-- 07_validate_gold_q16.sql
-- Validate that the Gold table matches the raw Q16 query
-- on tpch.sf1 row-for-row.


-- Full outer join diff: 0 rows = success
WITH gold_res AS (
  SELECT brand, type, size, supplier_cnt
  FROM gold.q16.parts_by_brand_type_size
),
raw_res AS (
  SELECT
    p.brand,
    p.type,
    p.size,
    count(DISTINCT ps.suppkey) AS supplier_cnt
  FROM tpch.sf1.partsupp AS ps
  JOIN tpch.sf1.part AS p ON p.partkey = ps.partkey
  WHERE p.brand <> 'Brand#45'
    AND p.type NOT LIKE 'MEDIUM POLISHED%'
    AND p.size IN (49, 14, 23, 45, 19, 3, 36, 9)
    AND ps.suppkey NOT IN (
      SELECT suppkey FROM tpch.sf1.supplier
      WHERE comment LIKE '%Customer%Complaints%'
    )
  GROUP BY p.brand, p.type, p.size
)
SELECT *
FROM gold_res
FULL OUTER JOIN raw_res USING (brand, type, size)
WHERE gold_res.supplier_cnt IS DISTINCT FROM raw_res.supplier_cnt;
-- Expected: 0 rows