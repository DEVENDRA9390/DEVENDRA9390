# remove duplicates

select distinct * from `list of orders`;
select distinct * from `order details`;
select distinct * from `sales target`;

# using group by and order by

select `category`,sum(target) as `total target` from `sales target`
group by `Category`
order by `total target` desc;

# joins and group by and order by

select `s`.`CustomerName`,sum(`o`.amount) as `total amount` from `list of orders` s
join `order details` o on `s`.`Order id`=`o`.`Order ID`
group by `s`.`CustomerName`
order by `total amount` desc;

#left join

SELECT
    lo.CustomerName,
    SUM(od.Amount) AS total_sales
FROM `list of orders` lo
LEFT JOIN `order details` od
    ON lo.`Order ID` = od.`Order ID`
GROUP BY lo.CustomerName
ORDER BY total_sales DESC;

#having

SELECT
    Category,
    SUM(Amount) AS total_sales
FROM `order details`
GROUP BY Category
HAVING SUM(Amount) > 10000
ORDER BY total_sales DESC;

#filtering and sorting amount above 500 in `order details` table

select * from `order details` 
where amount > 500
order by `Amount` desc;

#seeing sum of amount and high to low

select `order id`,sum(amount) as `total amount`,
       case
           when sum(amount) > 1000 then 'high'
           when sum(amount) > 500 then 'medium'
           else 'low'
       end as `amount level`
from `order details`
group by `order id`
order by `total amount` desc ;

# using count,avg,min,max

SELECT
    Category,
    COUNT(*) AS total_orders,
    AVG(Amount) AS avg_amount,
    MIN(Amount) AS min_amount,
    MAX(Amount) AS max_amount
FROM `order details`
GROUP BY Category
ORDER BY avg_amount DESC;

#windows function-rank()

SELECT
    CustomerName,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS customer_rank
FROM
(
    SELECT
        lo.CustomerName,
        SUM(od.Amount) AS total_sales
    FROM `list of orders` lo
    JOIN `order details` od
        ON lo.`Order ID` = od.`Order ID`
    GROUP BY lo.CustomerName
) t;

#windows function-ROW_NUMBER()

SELECT
    CustomerName,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS row_num
FROM
(
    SELECT
        lo.CustomerName,
        SUM(od.Amount) AS total_sales
    FROM `list of orders` lo
    JOIN `order details` od
        ON lo.`Order ID` = od.`Order ID`
    GROUP BY lo.CustomerName
) t;

#view

CREATE VIEW customer_sales AS
SELECT
    lo.CustomerName,
    SUM(od.Amount) AS total_sales
FROM `list of orders` lo
JOIN `order details` od
    ON lo.`Order ID` = od.`Order ID`
GROUP BY lo.CustomerName;

#us this

SELECT *
FROM customer_sales
ORDER BY total_sales DESC;

#CTE (Common Table Expression)

WITH customer_sales AS
(
    SELECT
        lo.CustomerName,
        SUM(od.Amount) AS total_sales
    FROM `list of orders` lo
    JOIN `order details` od
        ON lo.`Order ID` = od.`Order ID`
    GROUP BY lo.CustomerName
)
SELECT *
FROM customer_sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
);

#Top 10 customers

SELECT
    lo.CustomerName,
    SUM(od.Amount) AS total_sales
FROM `list of orders` lo
JOIN `order details` od
    ON lo.`Order ID` = od.`Order ID`
GROUP BY lo.CustomerName
ORDER BY total_sales DESC
LIMIT 10;

#Most profitable category

SELECT
    Category,
    SUM(Profit) AS total_profit
FROM `order details`
GROUP BY Category
ORDER BY total_profit DESC;

#State-wise profit

SELECT
    lo.State,
    SUM(od.Profit) AS total_profit
FROM `list of orders` lo
JOIN `order details` od
    ON lo.`Order ID` = od.`Order ID`
GROUP BY lo.State
ORDER BY total_profit DESC;

#High-value orders

SELECT
    `Order ID`,
    SUM(Amount) AS total_amount
FROM `order details`
GROUP BY `Order ID`
HAVING SUM(Amount) > 1000
ORDER BY total_amount DESC;