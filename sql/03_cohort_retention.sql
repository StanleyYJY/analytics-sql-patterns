-- Q: Of customers who first bought in month M, what share bought again k months later?
-- Pattern: first-purchase cohort per customer, month offset with date_diff, divide by cohort size.
with firsts as (
    select customer_id, date_trunc('month', min(order_date)) as cohort from orders group by 1
), activity as (
    select distinct o.customer_id, f.cohort,
           date_diff('month', f.cohort, date_trunc('month', o.order_date)) as k
    from orders o join firsts f using (customer_id)
), sizes as (select cohort, count(*) as n from firsts group by 1)
select strftime(a.cohort, '%Y-%m') as cohort, s.n as cohort_size,
       round(100.0 * count(*) filter (where k = 1) / s.n, 1) as m1_pct,
       round(100.0 * count(*) filter (where k = 3) / s.n, 1) as m3_pct,
       round(100.0 * count(*) filter (where k = 6) / s.n, 1) as m6_pct,
       round(100.0 * count(*) filter (where k = 12) / s.n, 1) as m12_pct
from activity a join sizes s using (cohort)
group by a.cohort, s.n order by a.cohort;
