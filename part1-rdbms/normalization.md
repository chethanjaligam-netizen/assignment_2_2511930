## Normalization Justification 
## Anomaly Analysis

1. **INSERT ANOMALY**
An Insert Anomaly occurs when we cannot add information about one entity without having information about another unrelated entity.

Example: In this table, we cannot add a new Sales Representative (e.g., SR04, Vikram Singh) to our system until they have processed at least one order. This is because every row requires an order_id and customer_id. Similarly, a new Product cannot be registered in the system without an associated order row.

Cited Columns: sales_rep_id, sales_rep_name, product_id, order_id.

2. **UPDATE ANOMALY**
An Update Anomaly occurs when data is redundant, and changing it in one place but not others leads to inconsistent records.

Example: Customer Priya Sharma (C002) appears in multiple rows, such as Row 0 (ORD1027) and Row 3 (ORD1002). If Priya Sharma changes her email address, the system must update the customer_email column in every single row associated with C002. If the update is performed on Row 0 but missed on Row 3, the database will contain two different email addresses for the same customer, causing data inconsistency.

Cited Rows/Columns: Row 0 and Row 3; customer_id, customer_email.

3. **DELETE ANOMALY**
A Delete Anomaly occurs when deleting a record results in the unintentional loss of data about a different entity that is not stored elsewhere.

Example: Product P008 (Webcam) appears in exactly one record in the dataset: Row 11 (ORD1185). If the customer Amit Verma cancels order ORD1185 and we delete that row, we lose all record of the existence of Product P008, including its product_name (Webcam), category (Electronics), and unit_price (2100). The product information is "wiped" from the database because it wasn't stored in a separate Products table.

Cited Rows/Columns: Row 11; order_id, product_id, product_name.

## NORMALIZATION JUSTIFICATION

## Normalization Justification

While keeping data in a single table may appear "simpler" for basic reporting, the `orders_flat.csv` dataset provides clear evidence that this approach is **not over-engineering**, but a necessary step to ensure data integrity. In its flat state, the table suffers from critical flaws that would lead to business errors and data loss.

The most compelling argument for normalization is the prevention of **Update Anomalies**. In the current file, sales representative **Deepak Joshi** (`SR01`) is associated with over 80 rows. If his office moves from "Nariman Point" to "Nariman Pt" (as seen in the slight inconsistency between row 1 and row 37), a simple update becomes a liability. In a flat structure, an update must be performed across every single row; if one row is missed, the database provides two different "truths" for the same employee. Normalizing this into a `SalesReps` table ensures that an office change is a single-row update, guaranteeing consistency.

Furthermore, the flat structure creates a **Delete Anomaly** that risks losing valuable product information. Product **P008 (Webcam)** currently exists in only one record (Row 11). If that specific order is canceled and deleted, the company loses all record of the webcam’s existence, including its pricing and category. By normalizing this into a `Products` table, the product data remains safely stored even if no active orders exist.

Finally, the flat table prevents the business from recording new entities, such as a newly hired sales rep or a product that hasn't sold yet, without creating "dummy" order data (**Insert Anomaly**). Normalizing to **3NF** isn't over-engineering; it is the fundamental process of ensuring that the database accurately reflects the business's logic without redundancy or the risk of accidental data corruption.