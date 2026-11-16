# 03_cohort_retention

**Question.** Of customers who first bought in month M, what share bought again k months later?

```sql
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
```

**Result** (25 rows shown, 88 ms):

| cohort   |   cohort_size |   m1_pct |   m3_pct |   m6_pct |   m12_pct |
|:---------|--------------:|---------:|---------:|---------:|----------:|
| 2009-12  |           951 |     35   |     42.5 |     37.6 |      37.6 |
| 2010-01  |           368 |     21.5 |     31.5 |     26.9 |      22.8 |
| 2010-02  |           375 |     23.5 |     29.3 |     19.2 |      15.2 |
| 2010-03  |           441 |     19   |     24.3 |     24.7 |      20   |
| 2010-04  |           294 |     19   |     16   |     27.6 |      14.3 |
| 2010-05  |           255 |     15.7 |     17.6 |     21.2 |      15.3 |
| 2010-06  |           267 |     17.6 |     20.6 |     12.7 |      15   |
| 2010-07  |           185 |     15.7 |     29.7 |     11.4 |      13   |
| 2010-08  |           163 |     19.6 |     32.5 |      9.8 |      14.7 |
| 2010-09  |           239 |     23   |     13   |     13.8 |      22.6 |
| 2010-10  |           375 |     25.9 |     12.5 |     13.1 |      19.2 |
| 2010-11  |           326 |     17.5 |      9.5 |     12.9 |      25.2 |
| 2010-12  |            76 |      9.2 |      9.2 |      5.3 |       2.6 |
| 2011-01  |            72 |     16.7 |     19.4 |     15.3 |       0   |
| 2011-02  |           125 |     16   |     18.4 |     16   |       0   |
| 2011-03  |           179 |     17.9 |     20.1 |     20.7 |       0   |
| 2011-04  |           106 |     24.5 |     19.8 |     17.9 |       0   |
| 2011-05  |           111 |     23.4 |     16.2 |     26.1 |       0   |
| 2011-06  |           108 |     23.1 |     26.9 |      8.3 |       0   |
| 2011-07  |           101 |     20.8 |     27.7 |      0   |       0   |
| 2011-08  |           107 |     26.2 |     26.2 |      0   |       0   |
| 2011-09  |           188 |     27.1 |     14.9 |      0   |       0   |
| 2011-10  |           221 |     31.7 |      0   |      0   |       0   |
| 2011-11  |           191 |     14.1 |      0   |      0   |       0   |
| 2011-12  |            28 |      0   |      0   |      0   |       0   |
