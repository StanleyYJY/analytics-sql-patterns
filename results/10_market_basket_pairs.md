# 10_market_basket_pairs

**Question.** Which product pairs are bought together most often, and how much more than chance (lift)?

```sql
-- Q: Which product pairs are bought together most often, and how much more than chance (lift)?
-- Pattern: self-join on invoice with a < b to count each pair once; support and lift from counts.
with items as (select distinct invoice, stock_code from sales),
n as (select count(distinct invoice) as total from items),
single as (select stock_code, count(*) as cnt from items group by 1),
names as (select stock_code, mode(description) as name from sales group by 1),
pairs as (
    select a.stock_code as a, b.stock_code as b, count(*) as together
    from items a join items b on a.invoice = b.invoice and a.stock_code < b.stock_code
    group by 1, 2 having count(*) >= 300
)
select na.name as item_a, nb.name as item_b, p.together,
       round(100.0 * p.together / n.total, 2) as support_pct,
       round(p.together * n.total * 1.0 / (sa.cnt * sb.cnt), 1) as lift
from pairs p, n
join single sa on sa.stock_code = p.a
join single sb on sb.stock_code = p.b
join names na on na.stock_code = p.a
join names nb on nb.stock_code = p.b
order by lift desc limit 10;
```

**Result** (10 rows shown, 394 ms):

| item_a                             | item_b                          |   together |   support_pct |   lift |
|:-----------------------------------|:--------------------------------|-----------:|--------------:|-------:|
| COFFEE MUG DOG + BALL DESIGN       | COFFEE MUG CAT + BIRD DESIGN    |        323 |          0.88 |   61.7 |
| POPPY'S PLAYHOUSE BATHROOM         | POPPY'S PLAYHOUSE KITCHEN       |        302 |          0.83 |   54.9 |
| POPPY'S PLAYHOUSE BEDROOM          | POPPY'S PLAYHOUSE LIVINGROOM    |        382 |          1.04 |   54.7 |
| SMALL DOLLY MIX DESIGN ORANGE BOWL | SMALL MARSHMALLOWS PINK BOWL    |        303 |          0.83 |   53.1 |
| POPPY'S PLAYHOUSE LIVINGROOM       | POPPY'S PLAYHOUSE KITCHEN       |        408 |          1.11 |   52.7 |
| CHILDS BREAKFAST SET SPACEBOY      | CHILDS BREAKFAST SET DOLLY GIRL |        300 |          0.82 |   52.6 |
| POPPY'S PLAYHOUSE BEDROOM          | POPPY'S PLAYHOUSE KITCHEN       |        472 |          1.29 |   50.4 |
| KEY FOB , BACK DOOR                | KEY FOB , FRONT  DOOR           |        319 |          0.87 |   49.8 |
| PINK  SPOTTY CUP                   | BLUE  SPOTTY CUP                |        388 |          1.06 |   45.4 |
| KEY FOB , GARAGE DESIGN            | KEY FOB , SHED                  |        409 |          1.12 |   43.8 |
