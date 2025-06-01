INSERT INTO dbo.customers (customer_id, became_member_on, gender, age, income)
SELECT
    customer_id,
    TRY_CAST(became_member_on AS DATE),
    LEFT(gender, 1), -- Truncate gender to CHAR(1)
    TRY_CAST(age AS INT),
    TRY_CAST(income AS INT)
FROM raw.customers;

INSERT INTO dbo.channels (channel_name)
SELECT DISTINCT TRIM(REPLACE(REPLACE(REPLACE(REPLACE(value, '"', ''), CHAR(10), ''), CHAR(13), ''), ']', ''))
FROM raw.offers
CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(channels, '[', ''), ']', ''), '''', ''), ',')
WHERE value IS NOT NULL AND TRIM(REPLACE(REPLACE(REPLACE(REPLACE(value, '"', ''), CHAR(10), ''), CHAR(13), ''), ']', '')) <> '';

INSERT INTO dbo.offer_channels (offer_id, channel_name)
SELECT
    offer_id,
    TRIM(REPLACE(REPLACE(REPLACE(REPLACE(value, '"', ''), CHAR(10), ''), CHAR(13), ''), ']', ''))
FROM raw.offers
CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(channels, '[', ''), ']', ''), '''', ''), ',')
WHERE value IS NOT NULL AND TRIM(REPLACE(REPLACE(REPLACE(REPLACE(value, '"', ''), CHAR(10), ''), CHAR(13), ''), ']', '')) <> '';

INSERT INTO dbo.customer_events (customer_id, event_type, event_time, amount, offer_id, reward)
SELECT
    customer_id,
    event_type,
    event_time,
    amount,
    offer_id,
    reward
FROM dbo.customer_events_staging
WHERE customer_id IN (SELECT customer_id FROM dbo.customers)
  AND (offer_id IS NULL OR offer_id IN (SELECT offer_id FROM dbo.offers));
