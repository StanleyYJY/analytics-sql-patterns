# 06_bought_last_month_not_this_month

**Question.** Which customers bought in October 2011 but not in November 2011, ranked by October spend?

```sql
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
```

**Result** (10 rows shown, 85 ms):

|   customer_id |   oct_revenue |   oct_orders |
|--------------:|--------------:|-------------:|
|         12678 |         8,513 |            2 |
|         17509 |         6,084 |            8 |
|         12536 |         4,280 |            1 |
|         12454 |         3,528 |            1 |
|         12359 |         2,814 |            1 |
|         13422 |         2,626 |            1 |
|         12939 |         2,546 |            2 |
|         17396 |         2,529 |            2 |
|         16652 |         2,248 |            2 |
|         15874 |         2,198 |            1 |
