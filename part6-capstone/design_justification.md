## Storage Systems
To meet the hospital’s four distinct goals, I have implemented a Polyglot Persistence strategy within a Data Lakehouse framework:

Goal 1 (Readmission Risk): I chose Delta Tables (stored in the Silver Layer of the Lakehouse). Predictive modeling requires high-quality, cleaned historical data. Delta tables provide the necessary versioning (Time Travel) and ACID transactions to ensure the AI models are trained on consistent snapshots of patient history.

Goal 2 (Plain English Queries): I selected a Vector Database (e.g., Pinecone or Milvus). Traditional relational databases cannot perform "semantic" searches. By converting doctor notes and cardiac history into high-dimensional embeddings, the vector DB allows the system to understand that "heart attack" and "myocardial infarction" refer to the same clinical event.

Goal 3 (Management Reports): I chose Star Schema tables in the Gold Layer. For metrics like bed occupancy and costs, performance is key. Aggregating data into a dimensional model allows BI tools to execute complex analytical queries across departments without scanning raw logs.

Goal 4 (Real-time Vitals): I implemented Apache Kafka paired with NoSQL (e.g., MongoDB or Cassandra). ICU vitals generate thousands of data points per second. A NoSQL store handles the high-velocity "writes" required for real-time monitoring, which would otherwise overwhelm a traditional relational database.

## OLTP vs OLAP Boundary
In this design, the boundary is defined by the Medallion Architecture.

The OLTP (Online Transactional Processing) system ends at the Source Systems and the Bronze Layer. The hospital’s primary EHR database handles the day-to-day "point" transactions (admitting a patient, updating a vitals sign). These are optimized for fast row-level inserts and updates.

The OLAP (Online Analytical Processing) system begins at the Silver Layer. Once data is extracted from the EHR and streamed from ICU devices into the Lakehouse, it is transformed from a normalized transactional format into a denormalized, query-optimized format. This is where the focus shifts from "recording a single event" to "analyzing patterns across thousands of events" for AI predictions and management reporting.

## Trade-offs
A significant trade-off in this design is Consistency vs. Latency regarding the ICU vitals. By using a Lakehouse approach for real-time data, there is a slight "processing lag" between the moment a vital is recorded and when it appears in the analytical Silver layer for AI risk scoring.

Mitigation: I mitigate this by implementing a Lambda Architecture pattern. While the long-term trend analysis happens in the Lakehouse, I utilize a "Speed Layer" (via Kafka Streams) that feeds raw vitals directly to a real-time alerting service. This ensures that while the "Deep AI" takes a few minutes to update a risk score, "Immediate Alerts" for critical heart rate drops happen in sub-second timeframes.