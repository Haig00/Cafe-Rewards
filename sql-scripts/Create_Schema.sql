CREATE SCHEMA raw;
GO


DROP TABLE IF EXISTS raw.offers;
DROP TABLE IF EXISTS raw.customers;
DROP TABLE IF EXISTS raw.customer_events;

GO

CREATE TABLE raw.customers (
    customer_id VARCHAR(100),
    became_member_on VARCHAR(50),
    gender VARCHAR(10),
    age VARCHAR(10),
    income VARCHAR(20)
);

CREATE TABLE raw.offers (
    offer_id VARCHAR(100),
    offer_type VARCHAR(50),
    difficulty VARCHAR(50),
    reward VARCHAR(50),
    duration VARCHAR(50),
    channels NVARCHAR(MAX)
);

CREATE TABLE raw.customer_events (
    customer_id VARCHAR(100),
    event_type VARCHAR(50),
    amount VARCHAR(50),
    event_time VARCHAR(50), 
    offer_id varchar(100)
    reward INT
    
);

GO
DROP TABLE IF EXISTS dbo.offer_channels;
DROP TABLE IF EXISTS dbo.channels;
DROP TABLE IF EXISTS dbo.customer_events;
DROP TABLE IF EXISTS dbo.offers;
DROP TABLE IF EXISTS dbo.customers;
DROP TABLE IF EXISTS dbo.customer_events_staging;
GO

CREATE TABLE dbo.customers (
    customer_id VARCHAR(50) NOT NULL PRIMARY KEY,
    became_member_on DATE NOT NULL,
    gender CHAR(1),
    age INT,
    income INT
);

CREATE TABLE dbo.offers (
    offer_id VARCHAR(50) NOT NULL PRIMARY KEY,
    offer_type VARCHAR(20) NOT NULL,
    difficulty DECIMAL(10,2) NOT NULL,
    reward DECIMAL(10,2) NOT NULL,
    duration INT
);

CREATE TABLE dbo.customer_events_staging (
    customer_id VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,  
    event_time INT NOT NULL,          
    amount DECIMAL(10,2) NULL,
    offer_id VARCHAR(50) NULL,
    reward DECIMAL(10,2) NULL
);

CREATE TABLE dbo.customer_events (
    event_id INT IDENTITY NOT NULL PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_time INT NOT NULL,
    amount DECIMAL(10,2) NULL,
    offer_id VARCHAR(50) NULL,
    reward DECIMAL(10,2) NULL,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (offer_id) REFERENCES offers(offer_id)
)
WITH (DATA_COMPRESSION = PAGE);

CREATE TABLE dbo.channels (
    channel_name VARCHAR(50) NOT NULL PRIMARY KEY 
);

CREATE TABLE dbo.offer_channels (
    offer_id VARCHAR(50) NOT NULL,
    channel_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (offer_id) REFERENCES offers(offer_id),
    FOREIGN KEY (channel_name) REFERENCES channels(channel_name),
    PRIMARY KEY (offer_id, channel_name)
);
