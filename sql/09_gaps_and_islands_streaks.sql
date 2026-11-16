-- Q: Which customers have the longest run of consecutive months with at least one order?
-- Pattern: gaps and islands. month_index minus ROW_NUMBER() is constant within a streak.
with months as (
    select distinct customer_id,
           year(order_date) * 12 + month(order_date) as month_index
    from orders
), islands as (
    select customer_id, month_index,
           month_index - row_number() over (partition by customer_id order by month_index) as grp
    from months
)
select customer_id, count(*) as streak_months,
       min(month_index) as start_idx, max(month_index) as end_idx
from islands group by customer_id, grp
order by streak_months desc, customer_id limit 10;
