CREATE TABLE bank_customers (
    ID INT PRIMARY KEY,
    age INT,
    job VARCHAR(50),
    marital VARCHAR(20),
    education VARCHAR(30),
    `default` VARCHAR(10),
    balance INT,
    housing VARCHAR(10),
    loan VARCHAR(10),
    contact VARCHAR(20),
    day INT,
    month VARCHAR(10),
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(20),
    y VARCHAR(10)
);

#Total Customers

SELECT COUNT(*) AS total_customers
FROM bank_customers;

#Subscription Rate

SELECT
    y,
    COUNT(*) AS customers,
    ROUND(COUNT(*)*100.0/
          (SELECT COUNT(*) FROM bank_customers),2) AS percentage
FROM bank_customers
GROUP BY y;

#Average Balance by Job

SELECT
    job,
    ROUND(AVG(balance),2) AS avg_balance
FROM bank_customers
GROUP BY job
ORDER BY avg_balance DESC;

#Top 10 Customers by Balance

SELECT
    ID,
    age,
    job,
    balance
FROM bank_customers
ORDER BY balance DESC
LIMIT 10;

#Subscription by Marital Status

SELECT
    marital,
    y,
    COUNT(*) AS customers
FROM bank_customers
GROUP BY marital,y
ORDER BY marital;

#Subscription by Education

SELECT
    education,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS subscribed
FROM bank_customers
GROUP BY education;

#Loan Impact on Subscription

SELECT
    loan,
    COUNT(*) AS customers,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS subscribed
FROM bank_customers
GROUP BY loan;

#Housing Loan Impact

SELECT
    housing,
    COUNT(*) AS customers,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS subscribed
FROM bank_customers
GROUP BY housing;

#Best Performing Contact Type

SELECT
    contact,
    COUNT(*) AS total,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS success
FROM bank_customers
GROUP BY contact
ORDER BY success DESC;

#Campaign Performance

SELECT
    campaign,
    COUNT(*) AS customers,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS subscribed
FROM bank_customers
GROUP BY campaign
ORDER BY campaign;

#Intermediate SQL Tools#
#GROUP BY

SELECT job,COUNT(*) AS total_customers
FROM bank_customers
GROUP BY job;

#HAVING
#Jobs having more than 500 customers:

SELECT
    job,
    COUNT(*) AS total
FROM bank_customers
GROUP BY job
HAVING COUNT(*) > 500;

#CASE WHEN

SELECT
    ID,
    balance,
    CASE
        WHEN balance > 10000 THEN 'High'
        WHEN balance BETWEEN 5000 AND 10000 THEN 'Medium'
        ELSE 'Low'
    END AS balance_category
FROM bank_customers;

#Window Functions
#RANK()
#Top balances by rank

SELECT
    ID,
    job,
    balance,
    RANK() OVER(ORDER BY balance DESC) AS balance_rank
FROM bank_customers;

#ROW_NUMBER()

SELECT
    ID,
    job,
    balance,
    ROW_NUMBER() OVER(ORDER BY balance DESC) AS row_num
FROM bank_customers;

#CTE

WITH avg_bal AS (
    SELECT AVG(balance) AS avg_balance
    FROM bank_customers
)
SELECT *
FROM bank_customers
WHERE balance >
(
    SELECT avg_balance
    FROM avg_bal
);

#view

CREATE VIEW subscription_summary AS
SELECT
    job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS subscribed
FROM bank_customers
GROUP BY job;

#use
SELECT * FROM subscription_summary;

#Stored Procedure

DELIMITER //

CREATE PROCEDURE GetJobDetails(IN job_name VARCHAR(50))
BEGIN
    SELECT *
    FROM bank_customers
    WHERE job = job_name;
END //

DELIMITER ;

#run
CALL GetJobDetails('management');

#Advanced Questions
#Which Job Has Highest Subscription Rate?

SELECT
    job,
    ROUND(
      SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)
      *100.0/COUNT(*),2
    ) AS success_rate
FROM bank_customers
GROUP BY job
ORDER BY success_rate DESC;

#Best Month for Marketing Campaign

SELECT
    month,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS subscriptions
FROM bank_customers
GROUP BY month
ORDER BY subscriptions DESC;

#Top 5 Jobs by Average Balance

SELECT
    job,
    ROUND(AVG(balance),2) AS avg_balance
FROM bank_customers
GROUP BY job
ORDER BY avg_balance DESC
LIMIT 5;

#Customer Segmentation

SELECT
    CASE
        WHEN age < 30 THEN 'Young'
        WHEN age BETWEEN 30 AND 50 THEN 'Middle Age'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS customers
FROM bank_customers
GROUP BY age_group;
