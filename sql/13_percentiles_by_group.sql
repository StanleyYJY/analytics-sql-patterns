-- Q: Median and 90th percentile order value by country (countries with 200+ orders).
-- Pattern: quantile_cont() as an ordered-set aggregate.
select country, count(*) as orders,
       round(quantile_cont(revenue, 0.5), 1) as median_order,
       round(quantile_cont(revenue, 0.9), 1) as p90_order,
       round(avg(revenue), 1) as mean_order
from orders group by 1 having count(*) >= 200 order by median_order desc;
