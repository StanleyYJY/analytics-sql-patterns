-- Q: Monthly revenue, orders, active customers and average order value, with month-over-month change.
-- Pattern: aggregate in a CTE, then LAG() for the previous month.
with m as (
    select date_trunc('month', order_date) as month, sum(revenue) as revenue,
           count(*) as orders, count(distinct customer_id) as customers
    from orders group by 1
)
select strftime(month, '%Y-%m') as month, round(revenue) as revenue, orders, customers,
       round(revenue / orders, 1) as aov,
       round(100.0 * (revenue / lag(revenue) over (order by month) - 1), 1) as revenue_mom_pct
from m order by month;
