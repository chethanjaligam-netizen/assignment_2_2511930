## ETL DECISIONS

### Decision 1 — Date Standardization
Problem: The date column in the raw CSV contained highly inconsistent formats, including DD/MM/YYYY, DD-MM-YYYY, and YYYY-MM-DD. This inconsistency prevents a relational database from recognizing the values as valid dates, making it impossible to perform time-series analysis or chronological sorting.

Resolution: I implemented a multi-pass parsing logic that detected the format of each string and converted it into a standard ISO YYYY-MM-DD format. Additionally, I transformed these into a numeric date_key (e.g., 20230829) to serve as a high-performance primary key for the dim_date table, ensuring consistent joins with the fact table.

### Decision 2 — Categorical Unification
Problem: The category field suffered from inconsistent casing and pluralization, with entries like electronics, Electronics, Grocery, and Groceries. In a business intelligence report, these would be treated as four distinct categories, which would fragment sales totals and provide an inaccurate view of inventory performance.

Resolution: During the ETL process, I applied a "Clean and Map" transformation. I forced all text to a standardized title case and mapped singular terms to their plural counterparts (e.g., mapping both Grocery and Groceries to the single label Groceries). This ensures that all relevant transactions are correctly aggregated under a single dimension member.

### Decision 3 — Missing Geographic Metadata Recovery
Problem: The store_city column contained several NULL values. In a data warehouse, missing dimension attributes lead to "orphan" records or "Unknown" groupings in geographic reports, which reduces the value of the dashboard for regional managers.

Resolution: I observed that while store_city was occasionally missing, store_name was always present. I performed a self-lookup on the dataset to create a master mapping of store names to cities (e.g., identifying that "Chennai Anna" always corresponds to "Chennai"). I then used this map to backfill the NULL values in the store_city column before loading the data into dim_store, ensuring 100% data density for geographic reporting.