-- SQL Retail Sales Analysis -P1
use sql_project_p1;

alter table retail_sales
rename column quantiy to quantity;
-- Creating a table
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	 sale_date DATE,	
	 sale_time TIME,	
	 customer_id	INT,
	 gender	VARCHAR(15),
	 age	INT,
	 category VARCHAR(15),	
	 quantity	INT,
	 price_per_unit	FLOAT,
	cogs FLOAT,	
	total_sale FLOAT
);

-- Check the Structure of the Data
SELECT * FROM retail_sales
LIMIT 10;

-- Data Cleaning
-- Checking for null values

SELECT * FROM retail_sales 
where 
	transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
-- Delete the null values
DELETE FROM retail_sales
where
	transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
-- Data Exploration

-- Basic Exploration

-- 1. How many sales we have
SELECT COUNT(*) AS sales_count FROM retail_sales;

-- 2. How many unique cutomers we have
SELECT COUNT(DISTINCT customer_id) AS total_customer_count FROM retail_sales; 

-- 3. How many categories we have
SELECT DISTINCT(category) as total_category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'; 

-- Q.2 Write a SQL query to retrive all transactions where the category is 'Clothing'
-- and the quantity sold is more than 4 month of Nov-22
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
AND Year(sale_date) = 2022 
AND MONTH(sale_date) = 11
AND quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales for each category

SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*)
 FROM retail_sales
 GROUP BY category;
 
 -- Q.3 Write a SQL query to find the average age of the customers who purchased items from the 'Beauty' category
 
 SELECT 
 ROUND(AVG(age),2)  as Average_age
 FROM retail_sales
 WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transaction where the total_sale is greater than 1000.

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender 
-- in each category

SELECT 
	category,
	gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale For each month. Find out best selling month in each year
SELECT *
FROM (
    SELECT 
        YEAR(sale_date)  AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale)) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers in total sales

SELECT 
customer_id,
SUM(total_sale) as TOTAL_SALES
FROM retail_sales
GROUP BY customer_id
ORDER BY TOTAL_SALES DESC
LIMIT 5; 

-- Q.9 Write a SQL query to find the number of unique customers who purchased from the each category

SELECT 
	category,
	COUNT(DISTINCT(customer_id)) AS UNIQUE_CUSTOMERS
from retail_sales
GROUP BY category;

-- Q.1 Write an SQL to create a shift and number of orders in each Shift (Morning <= 12, Afternoon  between 12 and 17 and Night >17)
WITH hourly_sale
AS(
SELECT *,
CASE 
	WHEN HOUR(sale_time) <= 12 THEN "Morning"
    WHEN HOUR(sale_time) BETWEEN 12 and 17 THEN "Afternoon"
    WHEN HOUR(sale_time) >17 THEN "Night"
    END as shifts
    from retail_sales
)
SELECT 
shifts,
COUNT(*) as total_order
from hourly_sale
GROUP BY shifts 
ORDER BY total_order DESC;




