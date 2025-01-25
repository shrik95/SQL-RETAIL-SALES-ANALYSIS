-- SQL RETAIL SALES ANALYSIS - P1
CREATE DATABASE 
IF NOT EXISTS sql_project_p1;

-- create TABLE
DROP TABLE 
IF EXISTS retail_sales;

CREATE TABLE retail_salesretail_sales
			(
            transactions_id	INT PRIMARY KEY,
            sale_date DATE,
            sale_time TIME,
            customer_id	INT,
            gender VARCHAR(20),
            age	INT,
            category VARCHAR(20),
            quantity INT,
            price_per_unit	FLOAT,
            cogs FLOAT,
            total_sale FLOAT
            );
 
-- DATA CLEANING

SELECT * 
FROM retail_sales;

SELECT * 
FROM retail_sales
WHERE sale_date IS NULL
	OR category IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
	OR total_sale IS NULL;
    
DELETE FROM retail_sales
WHERE sale_date IS NULL
	OR category IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
	OR total_sale IS NULL;

-- DATA EXPLORATION

-- TOTAL SALES
SELECT COUNT(*) 
FROM retail_sales;

-- TOTAL NUMBER OF CUSTOMERS
SELECT COUNT(customer_id) 
FROM retail_sales ;

SELECT COUNT(DISTINCT customer_id) 
FROM retail_sales ;

-- TOTAL CATEGORY
SELECT DISTINCT category FROM retail_sales ;

-- BUSINESS KEY PROBLEMS AND ANSWERS
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

SELECT * 
FROM retail_sales
WHERE quantity >= 4 
	AND category ='CLOTHING'
	AND year(SALE_DATE) = 2022
    AND month(SALE_DATE) = 11	
GROUP BY 1;

-- 3. Write a SQL query to calculate the total sales (total_sale) and orders for each category.

SELECT 
	category AS CATEGORY, 
    SUM(total_sale) AS TOTAL_SALES,
    COUNT(*) AS ORDER_COUNT
FROM retail_sales
GROUP BY 1;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:

SELECT 
ROUND(AVG(age),2) AS AVERAGE_AGE
FROM retail_sales
WHERE category = 'beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

SELECT *  
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:

SELECT 
	category,
	gender, 
	COUNT(transactions_id) AS COUNT_T
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
SELECT 
YEAR_S, 
MONTH_S,
TOTAL_SALE
		FROM (
				SELECT 
					YEAR(SALE_DATE) YEAR_S, 
					MONTH(SALE_DATE) MONTH_S, 
					ROUND(AVG(total_sale),2) TOTAL_SALE,
					RANK() OVER(PARTITION BY YEAR(SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) AS RANKS
				FROM retail_sales
				GROUP BY YEAR(SALE_DATE), (MONTH(SALE_DATE))
				ORDER BY 1, 3 DESC) T1 
WHERE RANKS = 1
;

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT customer_id ,
	SUM(total_sale) TOTAL_SALE
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

SELECT category,
	COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category;

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

WITH HOURLY_CTE AS
( 
SELECT *,
	CASE
		WHEN HOUR(SALE_TIME) < 12 THEN 'MORNING'
		WHEN HOUR(SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END AS SHIFT
FROM retail_sales
)
SELECT 
	SHIFT, 
    COUNT(*) AS ORDERS    
FROM HOURLY_CTE
GROUP BY SHIFT;

-- End of this Mini Project