# 12_pareto_customer_concentration

**Question.** What share of revenue comes from the top 1%, 10% and 20% of customers?

```sql
-- Q: What share of revenue comes from the top 1%, 10% and 20% of customers?
-- Pattern: rank customers by spend, cumulative sum over the ranking, read off at cut points.
with c as (select customer_id, sum(revenue) as rev from orders group by 1),
ranked as (
    select rev, row_number() over (order by rev desc) as rk, count(*) over () as n,
           sum(rev) over (order by rev desc rows unbounded preceding) / sum(rev) over () as cum_share
    from c
)
select cut, round(100.0 * max(cum_share) filter (where rk <= cut_frac * n), 1) as revenue_share_pct
from ranked, (values ('top 1%', 0.01), ('top 10%', 0.10), ('top 20%', 0.20), ('top 50%', 0.50)) v(cut, cut_frac)
group by cut, cut_frac order by cut_frac;
```

**Result** (4 rows shown, 79 ms):

| cut     |   revenue_share_pct |
|:--------|--------------------:|
| top 1%  |                31.9 |
| top 10% |                63.9 |
| top 20% |                77.2 |
| top 50% |                93.5 |
