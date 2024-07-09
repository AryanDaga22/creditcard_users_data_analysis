-- tasks

-- task 1 (monthly spend of each customer)
SELECT customer,month_only, sum(Amount) as monthly_spending
From (SELECT customer, date_format(Month,'%Y-%m') AS month_only, Amount, spending_type
		FROM spend2
		ORDER BY  customer) AS table1
group by customer,month_only
order by customer
;  

-- task 2 (monthly repayment of each customer)
SELECT *
FROM repayment2;

SELECT costomer, month_only, sum(Amount) as monthly_repayment
From (SELECT costomer, date_format(Month,'%Y-%m') AS month_only, Amount
		FROM repayment2
		ORDER BY  costomer) AS table2
group by costomer,month_only
order by costomer
;

-- task 3 ( 10 customers with highest repaymenet )
SELECT costomer, month_only, sum(Amount) as monthly_repayment
From (SELECT costomer, date_format(Month,'%Y-%m') AS month_only, Amount
		FROM repayment2
		ORDER BY  costomer) AS table2
group by costomer,month_only
order by monthly_repayment DESC LIMIT 10
;

-- task 4 ( people is which segment are spending more money )

SELECT  segment, SUM(Amount) AS total_spending
FROM  credit_banking2, spend2
group by segment
Order by total_spending DESC
;

-- task 5 ( which age group is spending more money )

SELECT  customer , sum(Amount) AS total_spending
FROM credit_banking2, spend2 
GROUP BY customer
ORDER BY total_spending DESC
;

SELECT customer , total_spending , Age
FROM (SELECT *
		FROM (SELECT  customer , sum(Amount) AS total_spending
				FROM credit_banking2, spend2 
				GROUP BY customer
				ORDER BY total_spending DESC
			) AS table3
		LEFT JOIN credit_banking2 AS cb
			ON table3.Customer = cb.Costomer
	  ) AS table4
;

-- task 6 ( Which is the most profitable segment )

-- total spending by each segment
SELECT  segment, SUM(Amount) AS total_spending
FROM  credit_banking2, spend2
group by segment
Order by total_spending DESC
;

-- total repayment by each segment
	SELECT  segment, SUM(Amount) AS total_repayment
	FROM  credit_banking2, repayment2
	group by segment
	Order by total_repayment DESC
;

SELECT r.segment, r.total_repayment - coalesce(s.total_spending, 0) AS net_profit
FROM (	SELECT  segment, SUM(Amount) AS total_repayment
		FROM  credit_banking2, repayment2
		group by segment
		Order by total_repayment DESC
		) AS r
CROSS JOIN (SELECT  segment, SUM(Amount) AS total_spending
			FROM  credit_banking2, spend2
			group by segment
			Order by total_spending DESC
			) AS s
		ON r.segment = s.segment
    ;
    
-- task 7 ( In which category the customers are spending more money )

SELECT spending_type, sum(Amount) AS total_spending
FROM spend2
GROUP BY spending_type
ORDER BY total_spending DESC
;

-- task 8 ( Impose an interest rate of 2.9% for each customer for any due amount )

-- total spending by each customer
SELECT customer, SUM(Amount) AS total_spending
FROM spend2
GROUP BY customer;
-- total repayment by each customer
SELECT costomer, SUM(Amount) AS total_repayment
FROM repayment2
GROUP BY costomer;

-- customers who have due amount
SELECT s.customer, s.total_spending - coalesce(r.total_repayment, 0) AS due_amount
FROM (SELECT customer, SUM(Amount) AS total_spending
		FROM spend2
		GROUP BY customer
		) AS s
CROSS JOIN (SELECT costomer, SUM(Amount) AS total_repayment
				FROM repayment2
				GROUP BY costomer 
				) AS r
		ON r.costomer = s.customer
HAVING due_amount > 0
    ;
-- final due amount after 2.9%interest
SELECT * ,
CASE 
	WHEN due_amount > 0 THEN due_amount*1.029 
END AS dueAmount_WithInterest
FROM (SELECT s.customer, s.total_spending - coalesce(r.total_repayment, 0) AS due_amount
		FROM (SELECT customer, SUM(Amount) AS total_spending
				FROM spend2
				GROUP BY customer
				) AS s
		CROSS JOIN (SELECT costomer, SUM(Amount) AS total_repayment
				FROM repayment2
				GROUP BY costomer 
				) AS r
			ON r.costomer = s.customer
	HAVING due_amount > 0
    ) AS table5
    ;
    
-- task 9 ( Monthly profit for the bank )

-- overall spending by customers month wise
SELECT month_only, SUM(Amount) AS monthly_spending
From (SELECT customer, date_format(Month,'%Y-%m') AS month_only, Amount, spending_type
		FROM spend2
		ORDER BY  customer) AS table1
GROUP BY month_only ;

-- overall repayment by customers month wise
SELECT month_only, SUM(Amount) AS monthly_repayment
From (SELECT costomer, date_format(Month,'%Y-%m') AS month_only, Amount
		FROM repayment2
		ORDER BY  costomer) AS table1
GROUP BY month_only ;

-- month wise profit of bank 
SELECT r.month_only, r.monthly_repayment, s.monthly_spending,(r.monthly_repayment - s. s.monthly_spending) AS monthly_profit
FROM (SELECT month_only, SUM(Amount) AS monthly_repayment
		From (SELECT costomer, date_format(Month,'%Y-%m') AS month_only, Amount
				FROM repayment2
				ORDER BY  costomer
			) AS table1
		GROUP BY month_only
        ) AS r
CROSS JOIN ( SELECT month_only, SUM(Amount) AS monthly_spending
				From (SELECT customer, date_format(Month,'%Y-%m') AS month_only, Amount, spending_type
						FROM spend2
						ORDER BY  customer
					) AS table1
			GROUP BY month_only
            ) AS s
	ON  s.month_only = r.month_only
    ;