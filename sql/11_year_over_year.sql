-- Q: Revenue by month in 2011 compared with the same month in 2010.
-- Pattern: conditional aggregation by year, pivoted on month number.
select month(order_date) as month_num,
       round(sum(revenue) filter (where year(order_date) = 2010)) as rev_2010,
       round(sum(revenue) filter (where year(order_date) = 2011)) as rev_2011,
       round(100.0 * (sum(revenue) filter (where year(order_date) = 2011)
                    / sum(revenue) filter (where year(order_date) = 2010) - 1), 1) as yoy_pct
from orders where order_date < date '2011-12-01' and order_date >= date '2010-01-01'
group by 1 order by 1;
