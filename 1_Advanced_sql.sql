SELECT * FROM super_store_sales LIMIT 10;
/*
Window functions: RANK, DENSE_RANK, ROW_NUMBER and why they differ on ties
PARTITION BY resetting rankings per group (city, department, category)
CTEs building a temp result, then filtering/querying it in a second step
Subqueries filtering using a calculated value (Nth Highest Salary)
Joins — connecting two related tables via a shared ID
Applied all of it on a real Superstore dataset top customers, top sub-categories per category, and now month-over-month trends*/

#sales
WITH monthly_sales AS (
    SELECT 
        `Customer Name`,
        sum(sales) as total_sales,
        Dense_rank() over (order by sum(Sales) DESC) AS total_spent
    FROM super_store_sales
    GROUP BY `Customer Name`
)
select 
`customer name`,
`total_sales`,
`total_spent`
From monthly_sales;

#partition
WITH category_sales AS(
select 
category,
`sub-category`,
sum(sales) as category_based_sales,
Dense_rank() over (partition by category order by sum(Sales) DESC) as category_based_rank
from super_store_sales
group by `category`,`sub-category`
)
select category,
`sub-category`,
category_based_sales,
category_based_rank
from category_sales
where category_based_rank<=3;

#LAG
with monthly_sales AS(
select 
date_format(STR_to_Date(`Order Date`,'%d/%m/%y'), '%Y-%m') as month_order,
sum(sales) as total_Sales
from super_store_Sales
group by month_order
)
select 
  month_order,
    total_sales,
    LAG(total_sales, 1) OVER (ORDER BY month_order) AS previous_month_sales,
    total_sales - LAG(total_sales, 1) OVER (ORDER BY month_order) AS change_from_previous_month
FROM monthly_sales
ORDER BY month_order;



