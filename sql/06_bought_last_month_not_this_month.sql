-- Q: Which customers bought in October 2011 but not in November 2011, ranked by October spend?
-- Pattern: anti-join with NOT EXISTS.
select o.customer_id, round(sum(o.revenue)) as oct_revenue, count(*) as oct_orders
from orders o
where o.order_date >= date '2011-10-01' and o.order_date < date '2011-11-01'
  and not exists (
      select 1 from orders n
      where n.customer_id = o.customer_id
        and n.order_date >= date '2011-11-01' and n.order_date < date '2011-12-01')
group by 1 order by oct_revenue desc limit 10;
