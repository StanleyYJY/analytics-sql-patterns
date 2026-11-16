-- Q: Score customers on recency, frequency and monetary value (1 to 5) and name the segments.
-- Pattern: NTILE() per dimension, CASE for segment rules, as of a fixed analysis date.
with base as (
    select customer_id,
           date_diff('day', max(order_date), date '2011-12-10') as recency_days,
           count(*) as frequency, sum(revenue) as monetary
    from orders group by 1
), scored as (
    select *, 6 - ntile(5) over (order by recency_days, customer_id) as r,
           ntile(5) over (order by frequency, customer_id) as f, ntile(5) over (order by monetary, customer_id) as m
    from base
)
select case
         when r >= 4 and f >= 4 then 'champions'
         when r >= 3 and f >= 3 then 'loyal'
         when r >= 4 and f <= 2 then 'new or returning'
         when r <= 2 and f >= 4 then 'at risk, high value'
         when r <= 2 and f <= 2 then 'lapsed'
         else 'needs attention' end as segment,
       count(*) as customers, round(sum(monetary)) as revenue,
       round(100.0 * sum(monetary) / sum(sum(monetary)) over (), 1) as revenue_share_pct
from scored group by 1 order by revenue desc;
