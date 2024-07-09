-- sanity checks ( data cleaning )
SELECT *
FROM credit_banking2
;

SELECT *
FROM spend2
;

SELECT *
FROM repayment2
;

SELECT avg(age)
FROM credit_banking
WHERE age >= 18
;
-- average age is 49.292430769230755

-- Step 1: Calculate the average age
SET @average_age = (SELECT AVG(age) FROM credit_banking2 WHERE age >= 18);

-- Step 2: Update the age of customers younger than 18
UPDATE credit_banking2
SET age = @average_age
WHERE age < 18;

UPDATE credit_banking2
SET age = 49.2924
WHERE age IS NULL;

ALTER TABLE spend2
RENAME COLUMN Costomer TO customer;

ALTER TABLE spend2
RENAME COLUMN Type TO spending_type;

ALTER TABLE credit_banking2
RENAME COLUMN Customer TO Costomer;


WITH monthwise_transaction AS -- CTE defined
	(SELECT customer, date_format(Month,'%Y-%m') AS month_only, Amount, spending_type
	FROM spend2
	ORDER BY  customer)-- table to calculate transactions on monthly basis
    
SELECT customer,month_only, sum(Amount) as monthly_spending
From monthwise_transaction
group by customer,month_only
order by customer
;

-- customers who exceeds their credit limti
WITH monthwise_transaction AS -- CTE defined
(SELECT customer ,month_only, sum(Amount) as monthly_spending
				From (SELECT customer , date_format(Month,'%Y-%m') AS month_only, Amount, spending_type
						FROM spend2
						ORDER BY  Customer) AS table1 
				group by customer,month_only
				order by customer
				) -- table to calculate transactions on monthly basis for each customer
SELECT cb.costomer, cb.Limit, mt.monthly_spending
FROM credit_banking2 AS cb
CROSS JOIN monthwise_transaction AS mt
	ON mt.customer = cb.costomer
Having mt.monthly_spending > cb.Limit
;
-- data cleaning ends







