# 09_gaps_and_islands_streaks

**Question.** Which customers have the longest run of consecutive months with at least one order?

```sql
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
```

**Result** (10 rows shown, 80 ms):

|   customer_id |   streak_months |   start_idx |   end_idx |
|--------------:|----------------:|------------:|----------:|
|         12682 |              25 |      24,120 |    24,144 |
|         12748 |              25 |      24,120 |    24,144 |
|         13078 |              25 |      24,120 |    24,144 |
|         13089 |              25 |      24,120 |    24,144 |
|         13199 |              25 |      24,120 |    24,144 |
|         13408 |              25 |      24,120 |    24,144 |
|         13468 |              25 |      24,120 |    24,144 |
|         13694 |              25 |      24,120 |    24,144 |
|         13798 |              25 |      24,120 |    24,144 |
|         14527 |              25 |      24,120 |    24,144 |
