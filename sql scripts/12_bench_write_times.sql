-- 12_bench_write_times.sql


SELECT query_id,
       date_diff('millisecond', started, "end") AS exec_ms,
       substr(query, 1, 100) AS q,
       created
FROM system.runtime.queries
WHERE query LIKE 'CREATE TABLE bronze.q16.raw_partsupp_%'
  AND query NOT LIKE '%runtime.queries%'
ORDER BY created DESC
LIMIT 10;