-- Find average age and income by gender
SELECT gender, 
	AVG(age) AS avg_age,
	AVG(income) AS avg_income
FROM dbo.customers
GROUP BY gender;

-- find the total number of customer in the age ranges
SELECT 
  CASE 
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
	WHEN age BETWEEN 65 AND 74 THEN '65-74'
	WHEN age BETWEEN 75 AND 84 THEN '75-84'
    WHEN age >= 85 THEN '85+'
    ELSE 'Unknown'
  END AS age_group,
  COUNT(*) AS [count]
FROM dbo.customers
GROUP BY 
  CASE 
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
	WHEN age BETWEEN 65 AND 74 THEN '65-74'
	WHEN age BETWEEN 75 AND 84 THEN '75-84'
    WHEN age >= 85 THEN '85+'
    ELSE 'Unknown'
  END
ORDER BY age_group;

--A query to show the count of each offer_type in the customer_events table
SELECT o.offer_id, o.offer_type, COUNT(*) AS view_count
FROM dbo.offers AS o
INNER JOIN dbo.customer_events ce
    ON o.offer_id = ce.offer_id
WHERE event_type = 'offer viewed'
GROUP BY o.offer_id, o.offer_type;

--find average age of membership acount
SELECT 
  AVG(DATEDIFF(YEAR, became_member_on, GETDATE())) AS age
FROM dbo.customers;

--a query to show completion percentage of different offer_types
SELECT 
    o.offer_id,
    o.offer_type,
    COUNT(CASE WHEN ce.event_type = 'offer viewed' THEN 1 END) AS viewed_count,
    COUNT(CASE WHEN ce.event_type = 'offer completed' THEN 1 END) AS completed_count,
    CASE 
        WHEN COUNT(CASE WHEN ce.event_type = 'offer viewed' THEN 1 END) = 0 THEN 0
        ELSE 
            CAST(COUNT(CASE WHEN ce.event_type = 'offer completed' THEN 1 END) AS FLOAT) /
            COUNT(CASE WHEN ce.event_type = 'offer viewed' THEN 1 END) * 100
    END AS completion_rate_percentage
FROM dbo.offers o
LEFT JOIN dbo.customer_events ce
    ON o.offer_id = ce.offer_id
GROUP BY o.offer_id, o.offer_type;


--This shows which customers have more completions than views
SELECT 
    customer_id,
    offer_id,
    COUNT(CASE WHEN event_type = 'offer viewed' THEN 1 END) AS views,
    COUNT(CASE WHEN event_type = 'offer completed' THEN 1 END) AS completions
FROM dbo.customer_events
GROUP BY customer_id, offer_id
HAVING COUNT(CASE WHEN event_type = 'offer completed' THEN 1 END) >
       COUNT(CASE WHEN event_type = 'offer viewed' THEN 1 END);

--This tells you how many customers received an informational offer and then made a transaction afterwards, which suggests potential influence.
SELECT COUNT(DISTINCT ce1.customer_id) AS informational_offers_with_transaction
FROM dbo.customer_events AS ce1
JOIN dbo.offers o ON ce1.offer_id = o.offer_id
JOIN dbo.customer_events AS ce2
    ON ce1.customer_id = ce2.customer_id
    AND ce2.event_type = 'transaction'
    AND ce2.event_time >= ce1.event_time
WHERE ce1.event_type = 'offer received'
  AND o.offer_type = 'informational';

--shows complted order by age group and gender and income
SELECT 
    c.gender,
    CASE
        WHEN c.age < 18 THEN 'Under 18'
        WHEN c.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN c.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN c.age BETWEEN 55 AND 64 THEN '55-64'
        WHEN c.age BETWEEN 65 AND 74 THEN '65-74'
        WHEN c.age BETWEEN 75 AND 84 THEN '75-84'
        ELSE '85+'
    END AS age_group,
    CASE
        WHEN c.income < 30000 THEN 'Under 30k'
        WHEN c.income BETWEEN 30000 AND 49999 THEN '30k-49k'
        WHEN c.income BETWEEN 50000 AND 69999 THEN '50k-69k'
        WHEN c.income BETWEEN 70000 AND 99999 THEN '70k-99k'
        ELSE '100k+'
    END AS income_bracket,
    COUNT(*) AS completed_offers
FROM dbo.customer_events ce
JOIN dbo.customers c ON ce.customer_id = c.customer_id
WHERE ce.event_type = 'offer completed'
GROUP BY 
    c.gender,
    CASE
        WHEN c.age < 18 THEN 'Under 18'
        WHEN c.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN c.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN c.age BETWEEN 55 AND 64 THEN '55-64'
        WHEN c.age BETWEEN 65 AND 74 THEN '65-74'
        WHEN c.age BETWEEN 75 AND 84 THEN '75-84'
        ELSE '85+'
    END,
    CASE
        WHEN c.income < 30000 THEN 'Under 30k'
        WHEN c.income BETWEEN 30000 AND 49999 THEN '30k-49k'
        WHEN c.income BETWEEN 50000 AND 69999 THEN '50k-69k'
        WHEN c.income BETWEEN 70000 AND 99999 THEN '70k-99k'
        ELSE '100k+'
    END
ORDER BY income_bracket, age_group, c.gender;

--Query to find avg time of completion for completed offers
SELECT o.offer_id, o.offer_type, AVG(ce.event_time) as avg_time, SUM(ce.reward) AS total_reward
FROM dbo.offers AS o
INNER JOIN dbo.customer_events ce
    ON o.offer_id = ce.offer_id
WHERE event_type = 'offer completed'
GROUP BY o.offer_id, o.offer_type;

-- QUery to find average time to complete an offer and the total completed offers based on the age demographics and the offer type
SELECT 
    CASE
        WHEN c.age < 18 THEN 'Under 18'
        WHEN c.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN c.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN c.age BETWEEN 55 AND 64 THEN '55-64'
        WHEN c.age BETWEEN 65 AND 74 THEN '65-74'
        WHEN c.age BETWEEN 75 AND 84 THEN '75-84'
        ELSE '85+'
    END AS age_group,
	o.offer_type,
    AVG(ce.event_time) AS avg_completion_time,
    COUNT(*) AS completions,
    SUM(ce.reward) AS total_reward
FROM dbo.customer_events ce
JOIN dbo.customers AS c ON ce.customer_id = c.customer_id
JOIN dbo.offers AS o ON ce.offer_id = o.offer_id
WHERE ce.event_type = 'offer completed'
GROUP BY 
    CASE
        WHEN c.age < 18 THEN 'Under 18'
        WHEN c.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN c.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN c.age BETWEEN 55 AND 64 THEN '55-64'
        WHEN c.age BETWEEN 65 AND 74 THEN '65-74'
        WHEN c.age BETWEEN 75 AND 84 THEN '75-84'
        ELSE '85+'
    END, o.offer_type
ORDER BY age_group, o.offer_type;

--query to find which mediums of reaching people had the most completions
SELECT 
    ch.channel_name,
    COUNT(*) AS completions
FROM dbo.customer_events AS ce
JOIN dbo.offer_channels AS ch ON ce.offer_id = ch.offer_id
WHERE ce.event_type = 'offer completed'
GROUP BY ch.channel_name
ORDER BY completions DESC;
