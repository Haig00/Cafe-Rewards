# Cafe-Rewards
Customer Behavior and Offer Analysis
This project analyzes customer interactions with various promotional offers using SQL Server and visualizes insights using Power BI. It focuses on event tracking such as offer viewing, completion, and transactions, and includes demographic breakdowns.

📊 Power BI Dashboard
A Power BI report accompanies this project, showcasing key metrics:

Offer completion rates by type

Customer demographics (age, income)

Channel effectiveness

Transaction attribution

Time to completion analysis

🗃️ Data Structure
Primary Tables:

customers: Demographics including age, gender, income

offers: Offer metadata (type, duration, reward)

customer_events: Tracks customer interactions (viewed, completed, transactions)

offer_channels: Maps offers to delivery channels (email, mobile, etc.)

Staging Tables: Used for bulk import and transformation before populating primary tables.

🧹 Data Cleaning
Handled malformed JSON in amount column

Normalized embedded JSON to structured columns (offer_id, reward, etc.)

Filtered unrealistic age values (e.g., age = 118)

Converted null or empty cells appropriately

📥 Loading and Transformation
Data imported using BULK INSERT and staging tables

Transformed and inserted into relational schema with proper constraints

🔍 Key Analyses
Offer completion by age and income brackets

Completion rates by offer type and channel

Event counts and anomalies (e.g., completions > views)

Transaction attribution to offers
