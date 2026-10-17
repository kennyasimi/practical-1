# Практическая работа №1 — Развертывание локального Lakehouse, ELT-преобразование и бенчмарк форматов/сжатия

**Сделан:** Кен Ньясими

**Вариант:** 4 — Q16 «Parts/Supplier Relationship»

**Масштаб:** sf1

Oтчёт с обоснованиями и результатами — в [`отчет.md`](отчет.md).

## Стек

MinIO (S3) → Lakekeeper (Iceberg REST Catalog, метаданные в PostgreSQL) → Trino (SQL-движок) + Spark (второй движок для чтения Bronze). Всё в Docker Desktop на Windows.

## Методология

1. **Пайплайн медальона:** скрипты `04_bronze_q16.sql` → `05_silver_q16.sql` → `06_gold_q16.sql` выполняются в Trino. Корректность Gold проверена `07_validate_gold_q16.sql`: FULL OUTER JOIN Gold с эталонным Q16 на `tpch.sf1` — 0 расхождений по `supplier_cnt` (183 группы brand×type×size).
2. **Размер:** сумма `file_size_in_bytes` из системной таблицы Iceberg `"<таблица>$files"`; кодек подтверждён через `$properties` (`write.parquet.compression-codec` / `write.orc.compression-codec`).
3. **Время записи:** 8 CTAS `bench.lakehouse.lineitem_{parquet,orc}_{none,snappy,gzip,zstd}` из `tpch.sf1.lineitem`; время взято из `system.runtime.queries` (`date_diff('millisecond', started, "end")`) по запросам `CREATE TABLE` (`23_bench_write_times.sql`).
4. **Время запроса:** Q1-агрегация (`GROUP BY returnflag, linestatus`) на каждой таблице — 1 холодный + 2 тёплых прогона. Перед холодным прогоном каждого кодека Trino и MinIO перезапускаются (`docker restart trino lakehouse-minio`) для сброса кэша метаданных и page cache ОС. Время — `exec_ms` из `system.runtime.queries` (`22_bench_timing.sql`), не wall-clock клиента.
5. **Валидация:** каждый прогон проверен на одинаковый результат — 4 строки Q1 (4 комбинации returnflag×linestatus) на всех 8 таблицах, что подтверждает корректность кодеков.
6. **Ограничение памяти:** Trino запущен с `JAVA_TOOL_OPTIONS=-Xmx2G`, Spark — `local[*]` с дефолтной памятью образа `apache/spark:3.5.3`. Оба укладываются в машину с 8 ГБ RAM.
7. **Сырые результаты:** `results/bench_sizeq16.csv`, `results/bench_writetime.csv`, `results/bench_q16.csv` — генерируются `run_benchmark.ps1`.
