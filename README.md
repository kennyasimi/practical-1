# Практическая работа №1 — Развертывание локального Lakehouse, ELT-преобразование и бенчмарк форматов/сжатия

**Сделан:** Кен Ньясими

**Вариант:** 4 — Q16 «Parts/Supplier Relationship»

**Масштаб:** sf1

Oтчёт с обоснованиями и результатами — в [`отчет.md`](отчет.md).

## Стек

MinIO (S3) → Lakekeeper (Iceberg REST Catalog, метаданные в PostgreSQL) → Trino (SQL-движок) + Spark (второй движок для чтения Bronze). Всё в Docker Desktop на Windows.
