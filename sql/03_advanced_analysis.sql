-- Step 1: Year-over-year growth
with yearly as (
SELECT order_year , sum(sales) as total_sales
FROM orders_clean
GROUP by order_year
)
SELECT order_year ,
round( 100.0 * (total_sales - lag(total_sales) over(ORDER by order_year)) / lag(total_sales) over(ORDER by order_year) ,2) as growth_pct
FROM yearly
GROUP by order_year
order by growth_pct DESC;

-- Step 2: Rank sub-categories by profit
WITH ranked_profit as (
SELECT "Sub-Category" ,
sum(Profit) as total_profit ,
rank() over(ORDER by sum(profit) DESC) as rank
FROM superstore
GROUP by "Sub-Category"
)
SELECT "Sub-Category" , rank , total_profit
FROM ranked_profit
GROUP by "Sub-Category"
ORDER by rank;

-- Step 3: Top product in each category
WITH product_sales AS (
    SELECT
        "Category",
        "Product Name",
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY "Category", "Product Name"
),

ranked_products AS (
    SELECT
        "Category",
        "Product Name",
        total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY "Category"
            ORDER BY total_sales DESC
        ) AS rn
    FROM product_sales
)

SELECT
    "Category",
    "Product Name",
    total_sales
FROM ranked_products
WHERE rn = 1
ORDER BY total_sales DESC;

-- Step 4: Running total of sales by month
WITH monthly_sales as (
SELECT order_year , order_month , sum(sales) as total_sales
FROM orders_clean
GROUP by order_year , order_month
) , running_total as (
SELECT order_year , order_month , total_sales ,
ROUND(SUM(total_sales) OVER (ORDER BY order_year, order_month), 2) AS running_total
FROM monthly_sales
)
SELECT * FROM running_total;

-- Step 5:  Top 5 products by profit
SELECT "Product Name",
       ROUND(SUM(Profit), 2) AS total_profits
FROM superstore
GROUP BY "Product Name"
ORDER BY total_profits DESC;

-- Step 6: Business insights

-- Q1: Which year had the strongest growth, and did growth slow in 2017?
-- A1: 2016 had the strongest growth at about 29.47%, after a small decline of about
-- 2.83% in 2015. Growth slowed in 2017 to about 20.36%, but sales still reached their
-- highest level at about 733,215.

-- Q2: Which 3 sub-categories earn the least profit, and which category do they belong to?
-- A2: Tables (about -17,725), Bookcases (about -3,473) and Supplies (about -1,189) are the
-- least profitable, and all three lose money. Tables and Bookcases belong to Furniture,
-- which explains its low 2.49% margin, while Supplies belongs to Office Supplies.

-- Q3: Which product leads each category, and is any of them also a profit leader?
-- A3: The sales leaders are the Canon imageCLASS 2200 Advanced Copier in Technology
-- (about 61,600), a Fellowes binding machine in Office Supplies (about 27,453) and a HON
-- chair in Furniture (about 21,871). The Canon copier is also the top product by profit
-- at about 25,200. The Fellowes machine earns about 7753.04 in profit.

-- Q4: What does the running total show about how the business grew over time?
-- A4: The running total reached about 484,248 by the end of 2014, about 954,780 by the end
-- of 2015, about 1,563,986 by the end of 2016 and 2,297,201 by the end of 2017. It climbs
-- faster each year after 2015, and the biggest jumps come in November and December, which
-- confirms that sales are concentrated at the end of each year.





















