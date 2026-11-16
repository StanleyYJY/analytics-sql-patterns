# 01_find_and_remove_duplicates

**Question.** How many raw lines are exact duplicates, and how much revenue would they double count?

```sql
-- Q: How many raw lines are exact duplicates, and how much revenue would they double count?
-- Pattern: ROW_NUMBER() over the natural key; rows with rn > 1 are the extra copies.
with ranked as (
    select *, row_number() over (
        partition by invoice, stock_code, quantity, unit_price, invoice_ts, customer_id
        order by description) as rn
    from raw
)
select
    count(*) filter (where rn > 1)                                   as duplicate_rows,
    round(100.0 * count(*) filter (where rn > 1) / count(*), 2)      as pct_of_rows,
    round(sum(quantity * unit_price) filter (where rn > 1 and quantity > 0), 0) as double_counted_amount
from ranked;
```

**Result** (1 rows shown, 243 ms):

|   duplicate_rows |   pct_of_rows |   double_counted_amount |
|-----------------:|--------------:|------------------------:|
|           34,337 |          3.22 |                 496,886 |
