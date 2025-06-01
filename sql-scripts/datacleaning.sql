DELETE FROM dbo.customer_events_staging
WHERE customer_id NOT IN (SELECT customer_id FROM dbo.customers);

-- THe people who dont have any information are defaulted as 118 years old
BEGIN TRANSACTION;


SELECT customer_id
INTO #CustomersToDelete
FROM dbo.customers
WHERE age > 110;


DELETE ce
FROM dbo.customer_events AS ce
JOIN #CustomersToDelete AS ctd ON ce.customer_id = ctd.customer_id;


DELETE c
FROM dbo.customers AS c
JOIN #CustomersToDelete AS ctd ON c.customer_id = ctd.customer_id;

DROP TABLE #CustomersToDelete;

COMMIT TRANSACTION;
