-- Q: How long do customers take to place a second order?
-- Pattern: LEAD() to get the next order date, bucket the gap, share of first-time buyers per bucket.
with seq as (
    select customer_id, order_date,
           row_number() over w as n, lead(order_date) over w as next_date
    from orders window w as (partition by customer_id order by order_date, invoice)
), firsts as (
    select customer_id, date_diff('day', order_date, next_date) as days_to_second
    from seq where n = 1
)
select case when days_to_second is null then 'never (in window)'
            when days_to_second <= 30 then '0-30 days'
            when days_to_second <= 90 then '31-90 days'
            when days_to_second <= 180 then '91-180 days'
            else '181+ days' end as bucket,
       count(*) as customers,
       round(100.0 * count(*) / sum(count(*)) over (), 1) as pct
from firsts group by 1 order by min(coalesce(days_to_second, 99999));
