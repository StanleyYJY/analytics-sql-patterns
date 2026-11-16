# 11_year_over_year

**Question.** Revenue by month in 2011 compared with the same month in 2010.

```sql
-- Q: Revenue by month in 2011 compared with the same month in 2010.
-- Pattern: conditional aggregation by year, pivoted on month number.
select month(order_date) as month_num,
       round(sum(revenue) filter (where year(order_date) = 2010)) as rev_2010,
       round(sum(revenue) filter (where year(order_date) = 2011)) as rev_2011,
       round(100.0 * (sum(revenue) filter (where year(order_date) = 2011)
                    / sum(revenue) filter (where year(order_date) = 2010) - 1), 1) as yoy_pct
from orders where order_date < date '2011-12-01' and order_date >= date '2010-01-01'
group by 1 order by 1;
```

**Result** (12 rows shown, 76 ms):

|   month_num |   rev_2010 | rev_2011   |   yoy_pct |
|------------:|-----------:|:-----------|----------:|
|           1 |    533,713 | 562683     |       5.4 |
|           2 |    497,938 | 442294     |     -11.2 |
|           3 |    665,974 | 583144     |     -12.4 |
|           4 |    585,127 | 454441     |     -22.3 |
|           5 |    592,734 | 659228     |      11.2 |
|           6 |    628,809 | 653265     |       3.9 |
|           7 |    581,488 | 591604     |       1.7 |
|           8 |    594,561 | 635514     |       6.9 |
|           9 |    805,545 | 938753     |      16.5 |
|          10 |  1,011,572 | 1002327    |      -0.9 |
|          11 |  1,155,978 | 1135997    |      -1.7 |
|          12 |    565,200 | <NA>       |     nan   |
