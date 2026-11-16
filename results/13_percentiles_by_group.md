# 13_percentiles_by_group

**Question.** Median and 90th percentile order value by country (countries with 200+ orders).

```sql
-- Q: Median and 90th percentile order value by country (countries with 200+ orders).
-- Pattern: quantile_cont() as an ordered-set aggregate.
select country, count(*) as orders,
       round(quantile_cont(revenue, 0.5), 1) as median_order,
       round(quantile_cont(revenue, 0.9), 1) as p90_order,
       round(avg(revenue), 1) as mean_order
from orders group by 1 having count(*) >= 200 order by median_order desc;
```

**Result** (5 rows shown, 141 ms):

| country        |   orders |   median_order |   p90_order |   mean_order |
|:---------------|---------:|---------------:|------------:|-------------:|
| EIRE           |      528 |          705.3 |      1652.1 |       1111   |
| Netherlands    |      216 |          657.1 |      8445.5 |       2545.2 |
| France         |      590 |          362.7 |       968.9 |        524.4 |
| Germany        |      753 |          360.3 |      1017.1 |        509   |
| United Kingdom |   33,361 |          299.5 |       761.8 |        428.3 |
