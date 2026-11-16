# 08_top_n_per_group

**Question.** Top three products by revenue in each of the five largest non-UK countries.

```sql
-- Q: Top three products by revenue in each of the five largest non-UK countries.
-- Pattern: ROW_NUMBER() partitioned by group, filtered with QUALIFY.
with top_countries as (
    select country from orders where country <> 'United Kingdom'
    group by 1 order by sum(revenue) desc limit 5
)
select country, stock_code, any_value(description) as description, round(sum(amount)) as revenue
from sales where country in (select country from top_countries)
group by country, stock_code
qualify row_number() over (partition by country order by sum(amount) desc) <= 3
order by country, revenue desc;
```

**Result** (15 rows shown, 162 ms):

| country     | stock_code   | description                         |   revenue |
|:------------|:-------------|:------------------------------------|----------:|
| Australia   | 23084        | RABBIT NIGHT LIGHT                  |     3,376 |
| Australia   | 22423        | REGENCY CAKESTAND 3 TIER            |     2,931 |
| Australia   | 21731        | RED TOADSTOOL LED NIGHT LIGHT       |     2,464 |
| EIRE        | 22423        | REGENCY CAKESTAND 3 TIER            |    14,637 |
| EIRE        | 20914        | SET/5 RED RETROSPOT LID GLASS BOWLS |     7,710 |
| EIRE        | 21843        | RETRO SPOT CAKE STAND               |     6,075 |
| France      | 23084        | RABBIT NIGHT LIGHT                  |     7,234 |
| France      | 21731        | RED TOADSTOOL LED NIGHT LIGHT       |     4,308 |
| France      | 22326        | ROUND SNACK BOXES SET OF4 WOODLAND  |     3,643 |
| Germany     | 22423        | REGENCY CAKESTAND 3 TIER            |    13,549 |
| Germany     | 22326        | ROUND SNACK BOXES SET OF4 WOODLAND  |     7,690 |
| Germany     | 22328        | ROUND SNACK BOXES SET OF 4 FRUITS   |     4,574 |
| Netherlands | 22326        | ROUND SNACK BOXES SET OF4 WOODLAND  |    13,315 |
| Netherlands | 85123A       | WHITE HANGING HEART T-LIGHT HOLDER  |    10,933 |
| Netherlands | 22630        | DOLLY GIRL LUNCH BOX                |    10,798 |
