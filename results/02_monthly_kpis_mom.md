# 02_monthly_kpis_mom

**Question.** Monthly revenue, orders, active customers and average order value, with month-over-month change.

```sql
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
```

**Result** (25 rows shown, 75 ms):

| month   |   revenue |   orders |   customers |   aov |   revenue_mom_pct |
|:--------|----------:|---------:|------------:|------:|------------------:|
| 2009-12 |   677,916 |    1,497 |         951 | 452.8 |             nan   |
| 2010-01 |   533,713 |      959 |         701 | 556.5 |             -21.3 |
| 2010-02 |   497,938 |    1,093 |         771 | 455.6 |              -6.7 |
| 2010-03 |   665,974 |    1,509 |       1,051 | 441.3 |              33.7 |
| 2010-04 |   585,127 |    1,315 |         939 | 445   |             -12.1 |
| 2010-05 |   592,734 |    1,365 |         965 | 434.2 |               1.3 |
| 2010-06 |   628,809 |    1,479 |       1,034 | 425.2 |               6.1 |
| 2010-07 |   581,488 |    1,362 |         924 | 426.9 |              -7.5 |
| 2010-08 |   594,561 |    1,276 |         910 | 466   |               2.2 |
| 2010-09 |   805,545 |    1,659 |       1,136 | 485.6 |              35.5 |
| 2010-10 | 1,011,572 |    2,108 |       1,492 | 479.9 |              25.6 |
| 2010-11 | 1,155,978 |    2,570 |       1,606 | 449.8 |              14.3 |
| 2010-12 |   565,200 |    1,394 |         884 | 405.5 |             -51.1 |
| 2011-01 |   562,683 |      983 |         739 | 572.4 |              -0.4 |
| 2011-02 |   442,294 |      992 |         757 | 445.9 |             -21.4 |
| 2011-03 |   583,144 |    1,312 |         973 | 444.5 |              31.8 |
| 2011-04 |   454,441 |    1,139 |         853 | 399   |             -22.1 |
| 2011-05 |   659,228 |    1,544 |       1,054 | 427   |              45.1 |
| 2011-06 |   653,265 |    1,390 |         990 | 470   |              -0.9 |
| 2011-07 |   591,604 |    1,321 |         946 | 447.8 |              -9.4 |
| 2011-08 |   635,514 |    1,267 |         933 | 501.6 |               7.4 |
| 2011-09 |   938,753 |    1,739 |       1,259 | 539.8 |              47.7 |
| 2011-10 | 1,002,327 |    1,903 |       1,361 | 526.7 |               6.8 |
| 2011-11 | 1,135,997 |    2,642 |       1,660 | 430   |              13.3 |
| 2011-12 |   512,228 |      776 |         614 | 660.1 |             -54.9 |
