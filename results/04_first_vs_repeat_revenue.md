# 04_first_vs_repeat_revenue

**Question.** Each month, how much revenue comes from customers' first orders versus repeat orders?

```sql
-- Q: Each month, how much revenue comes from customers' first orders versus repeat orders?
-- Pattern: rank each customer's orders by date, label rank 1 as first, aggregate conditionally.
with ranked as (
    select *, row_number() over (partition by customer_id order by order_date, invoice) as n
    from orders
)
select strftime(date_trunc('month', order_date), '%Y-%m') as month,
       round(sum(revenue) filter (where n = 1))  as first_order_revenue,
       round(sum(revenue) filter (where n > 1))  as repeat_revenue,
       round(100.0 * sum(revenue) filter (where n > 1) / sum(revenue), 1) as repeat_share_pct
from ranked group by 1 order by 1;
```

**Result** (25 rows shown, 75 ms):

| month   |   first_order_revenue |   repeat_revenue |   repeat_share_pct |
|:--------|----------------------:|-----------------:|-------------------:|
| 2009-12 |               397,474 |          280,442 |               41.4 |
| 2010-01 |               143,711 |          390,002 |               73.1 |
| 2010-02 |               147,316 |          350,621 |               70.4 |
| 2010-03 |               176,920 |          489,054 |               73.4 |
| 2010-04 |               117,210 |          467,917 |               80   |
| 2010-05 |               101,716 |          491,018 |               82.8 |
| 2010-06 |               114,978 |          513,832 |               81.7 |
| 2010-07 |                58,207 |          523,281 |               90   |
| 2010-08 |                55,522 |          539,039 |               90.7 |
| 2010-09 |               146,172 |          659,372 |               81.9 |
| 2010-10 |               159,334 |          852,237 |               84.2 |
| 2010-11 |               135,003 |        1,020,976 |               88.3 |
| 2010-12 |                25,813 |          539,386 |               95.4 |
| 2011-01 |                42,123 |          520,560 |               92.5 |
| 2011-02 |                38,789 |          403,504 |               91.2 |
| 2011-03 |                65,245 |          517,898 |               88.8 |
| 2011-04 |                37,030 |          417,411 |               91.9 |
| 2011-05 |                45,589 |          613,638 |               93.1 |
| 2011-06 |                40,761 |          612,504 |               93.8 |
| 2011-07 |                37,686 |          553,918 |               93.6 |
| 2011-08 |                42,496 |          593,018 |               93.3 |
| 2011-09 |                85,289 |          853,464 |               90.9 |
| 2011-10 |                85,459 |          916,868 |               91.5 |
| 2011-11 |                62,205 |        1,073,792 |               94.5 |
| 2011-12 |                19,429 |          492,799 |               96.2 |
