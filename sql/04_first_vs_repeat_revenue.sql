-- Q: Each month, how much revenue comes from customers' first orders versus repeat orders?
-- Pattern: rank each customer's orders by date, label rank 1 as first, aggregate conditionally.
with ranked as (
    select *, row_number() over (partition by customer_id order by order_date, invoice) as n
    from orders
)
select strftime(date_trunc('month', order_date), '%Y-%m') as month,
       round(sum(revenue) filter (where n = 1))  as first_order_revenue,
       round(sum(revenue) filter (where n > 1))  as repeat_revenue,
       round(100.0 * sum(revenue) filter (where n > 1) / sum(revenue), 1) as repeat_share_pct
from ranked group by 1 order by 1;
