# 05_rolling_windows_with_calendar

**Question.** 7-day and 28-day rolling revenue, counting days with no sales as zero.

```sql
-- Q: 7-day and 28-day rolling revenue, counting days with no sales as zero.
-- Pattern: build a calendar spine, LEFT JOIN daily totals, then window frames over rows.
with cal as (
    select cast(d as date) as day
    from range(date '2011-09-01', date '2011-12-01', interval 1 day) t(d)
), daily as (
    select order_date as day, sum(revenue) as revenue from orders group by 1
)
select c.day, round(coalesce(d.revenue, 0)) as revenue,
       round(sum(coalesce(d.revenue, 0)) over (order by c.day rows between 6 preceding and current row)) as rolling_7d,
       round(sum(coalesce(d.revenue, 0)) over (order by c.day rows between 27 preceding and current row)) as rolling_28d
from cal c left join daily d using (day)
order by c.day desc limit 14;
```

**Result** (14 rows shown, 71 ms):

| day                 |   revenue |   rolling_7d |   rolling_28d |
|:--------------------|----------:|-------------:|--------------:|
| 2011-11-30 00:00:00 |    40,763 |      219,367 |     1,068,745 |
| 2011-11-29 00:00:00 |    48,163 |      248,740 |     1,066,447 |
| 2011-11-28 00:00:00 |    49,730 |      248,974 |     1,047,072 |
| 2011-11-27 00:00:00 |    16,963 |      243,833 |     1,029,207 |
| 2011-11-26 00:00:00 |         0 |      256,298 |     1,046,175 |
| 2011-11-25 00:00:00 |    25,973 |      256,298 |     1,046,175 |
| 2011-11-24 00:00:00 |    37,776 |      265,994 |     1,056,809 |
| 2011-11-23 00:00:00 |    70,136 |      282,417 |     1,065,908 |
| 2011-11-22 00:00:00 |    48,396 |      260,029 |     1,029,177 |
| 2011-11-21 00:00:00 |    44,590 |      257,914 |     1,015,841 |
| 2011-11-20 00:00:00 |    29,428 |      269,876 |     1,008,183 |
| 2011-11-19 00:00:00 |         0 |      268,863 |       990,861 |
| 2011-11-18 00:00:00 |    35,668 |      268,863 |       990,861 |
| 2011-11-17 00:00:00 |    54,199 |      269,331 |     1,015,362 |
