-- Step 0: Create a helper view with year and month
DROP VIEW IF EXISTS orders_clean;
CREATE VIEW orders_clean AS
SELECT *,
       CAST(substr("Order Date", length("Order Date") - 3, 4) AS INTEGER) AS order_year,
       CAST(substr("Order Date", 1, instr("Order Date", '/') - 1) AS INTEGER) AS order_month
FROM superstore;

-- Step 1: Sales and profit by year
SELECT order_year ,
 round(sum(Sales),2) as total_sales ,
 round(sum(Profit),2) as total_profits ,
 count(distinct "Order ID") as total_orders
FROM orders_clean
GROUP by order_year
ORDER by total_sales DESC;

-- Step 2: Sales by month (across all years)
SELECT order_month ,
 round(sum(Sales),2) as total_sales
FROM orders_clean
GROUP by order_month
ORDER by total_sales DESC;

-- Step 3: Sales and profit margin by category
SELECT Category ,
 round(sum(Sales),2) as total_sales ,
 round(sum(Profit),2) as total_profits ,
round( 100.0 * sum(Profit) / sum(Sales) , 2) as profit_margin_pct
FROM superstore
GROUP by Category
ORDER by profit_margin_pct DESC;

-- Step 4: Sales and profit by region
SELECT Region ,
 round(sum(Sales),2) as total_sales ,
 round(sum(Profit),2) as total_profits ,
round(sum(profit) * 100.0 / sum(sales) , 2) as margin_pct
FROM superstore
GROUP by Region
ORDER by margin_pct DESC;

-- Step 5: Average discount by category
SELECT Category ,
 count("Order ID") as order_lines ,
 round(avg(discount),2) as avg_discount
FROM superstore
GROUP by Category
ORDER by avg_discount DESC;

-- Step 6: Average order value by year
SELECT order_year ,
 round(sum(sales) / count(distinct "Order ID") , 2) as avg_order_value
FROM orders_clean
GROUP by order_year;

-- Step 7: Sales growth from 2014 to 2017
SELECT ROUND(
         (SUM(CASE WHEN order_year = 2017 THEN Sales END)
        - SUM(CASE WHEN order_year = 2014 THEN Sales END)) * 100.0
        / SUM(CASE WHEN order_year = 2014 THEN Sales END), 2) AS growth_pct
FROM orders_clean;

-- Step 8: Business insights

-- Q1: Which year had the highest sales, and how much did sales grow from 2014 to 2017?
-- A1: 2017 had the highest sales at about 733,215. Sales grew by about 51.41%
-- from 484,247 in 2014, with a small dip in 2015 (470,532) before growing each year after that.

-- Q2: Which months are the strongest?
-- A2: November (about 352,461) and December (about 325,294) are the strongest months,
-- followed by September (about 307,650). February is the weakest at about 59,751,
-- so sales are clearly concentrated in the last quarter of the year.

-- Q3: Which category has the weakest profit margin, and what might explain it?
-- A3: Furniture has a margin of only 2.49% despite 741,999 in sales, compared with
-- 17.40% for Technology and 17.04% for Office Supplies. Furniture also has the highest
-- average discount (about 0.17), which likely cuts into its profit.

-- Q4: Which region has the weakest profit margin?
-- A4: Central has the weakest margin at 7.92% on 501,239 in sales, while West is the
-- strongest at 14.94%. Central's margin is about half of West's.