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
