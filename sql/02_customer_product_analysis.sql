-- Step 1: Number of customers
SELECT count(distinct "Customer ID") as customers
FROM superstore;

-- Step 2: Top 10 customers by sales
SELECT "Customer Name" ,
round(sum(Sales),2) as total_sales ,
round(sum(Profit),2) as total_profits
FROM superstore
GROUP by "Customer Name"
ORDER by total_sales DESC
limit 10;

-- Step 3: Top 10 customers by profit
SELECT "Customer Name" ,
round(sum(Sales),2) as total_sales ,
round(sum(Profit),2) as total_profits
FROM superstore
GROUP by "Customer Name"
ORDER by total_profits DESC
limit 10;

-- Step 4: Sales and profit by Segment
SELECT Segment ,
round(sum(Sales),2) as total_sales ,
round(sum(Profit),2) as total_profits ,
round(100.0 * SUM(Profit) / SUM(Sales) ,2) as margin
FROM superstore
GROUP by Segment
ORDER by margin DESC;

-- Step 5: Top 10 products by sales	
SELECT "Product Name" ,
round(sum(Sales),2) as total_sales 
FROM superstore
GROUP by "Product Name"
ORDER by total_sales DESC
limit 10;

-- Step 6: Sales and profit by Sub-Category
SELECT "Sub-Category" ,
round(sum(Sales),2) as total_sales ,
round(sum(Profit),2) as total_profits
FROM superstore
GROUP by "Sub-Category"
ORDER by total_profits;

-- Step 7: Top 10 loss making products	
SELECT "Product Name" ,
round(sum(Profit),2) as total_profits
FROM superstore
GROUP by "Product Name"
ORDER by total_profits
limit 10;

-- Step 8: Share of total sales from the top 10 customers
SELECT ROUND(SUM(cust_sales), 2) AS top10_sales,
       ROUND(SUM(cust_sales) * 100.0 / (SELECT SUM(Sales) FROM superstore), 2) AS pct_of_total
FROM (
    SELECT SUM(Sales) AS cust_sales
    FROM superstore
    GROUP BY "Customer ID"
    ORDER BY cust_sales DESC
    LIMIT 10
);


-- Step 9: Business insights

-- Q1: How much of the total sales do the top 10 customers account for?
-- A1: The top 10 customers generate about 153,800 in sales, only about 6.7% of the
-- total 2,297,201. Sales are spread across 793 customers, so the business does not
-- depend on a few large accounts.

-- Q2: Which segment brings the most sales?
-- A2: Consumer brings the most sales at about 1,161,401 (about 50.6% of the total),
-- followed by Corporate (about 706,146) and Home Office (about 429,653). Home Office
-- is the smallest segment but has the best margin at about 14.03%, compared with
-- 11.55% for Consumer.

-- Q3: Which sub-category loses money, and why is that a problem for Furniture's margin?
-- A3: Tables lose about 17,725 in profit despite about 206,966 in sales, and Bookcases
-- also lose about 3,473. Both belong to Furniture, so they pull its profit down to
-- 18,451 (a 2.49% margin). Without the Tables loss, Furniture's profit would be roughly
-- double.

-- Q4: What does the loss-making products list suggest the company should review?
-- A4: The worst products lose heavily, for example a Cubify 3D printer at about -8,880
-- and a Lexmark printer at about -4,590. The company should review the pricing and
-- discounts on these products, since heavy discounting is a likely cause, and decide
-- whether to reprice or drop them.
