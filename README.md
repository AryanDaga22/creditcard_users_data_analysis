# creditcard_users_data_analysis

The SQL script performs data cleaning and multiple analytical tasks on banking data, specifically focusing on customer transactions, repayments, and profits. 

**Data Cleaning**:
- **Sanity Checks**: Initial queries inspect the data in `credit_banking2`, `spend2`, and `repayment2`.
- **Calculate and Update Average Age**: The average age of customers above 18 is computed and stored. Ages below 18 and `NULL` values are updated to this average.
- **Rename Columns**: Columns in `spend2` and `credit_banking2` are renamed for consistency and to fix typos.

**Analytical Tasks**:
1. **Monthly Spend for Each Customer**: Aggregates customer spending by month.
2. **Monthly Repayment for Each Customer**: Aggregates customer repayments by month.
3. **Top 10 Customers with Highest Repayments**: Identifies the top 10 customers with the highest repayments.
4. **Segment Spending Analysis**: Calculates total spending per segment.
5. **Age Group Spending Analysis**: Calculates total spending for each customer and associates it with their age.
6. **Most Profitable Segment**: Determines net profit for each segment by subtracting total spending from total repayments.
7. **Category Spending Analysis**: Identifies spending types where customers spend the most.
8. **Imposing Interest Rate on Due Amounts**: Calculates due amounts after imposing a 2.9% interest on customers with outstanding balances.
9. **Monthly Profit for the Bank**: Calculates monthly spending and repayment totals, then derives monthly profit by subtracting spending from repayments.

Each step involves data manipulation using SQL functions and joins to provide insights into customer behavior and bank profitability.
