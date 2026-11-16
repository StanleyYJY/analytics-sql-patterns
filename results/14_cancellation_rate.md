# 14_cancellation_rate

**Question.** Monthly cancellation rate (cancelled amount over gross sales) for identified customers.

```sql
-- Q: Monthly cancellation rate (cancelled amount over gross sales) for identified customers.
-- Pattern: FILTER clauses for conditional sums in one pass over the raw table.
select strftime(date_trunc('month', invoice_ts), '%Y-%m') as month,
       round(sum(quantity * unit_price) filter (where not starts_with(invoice, 'C') and quantity > 0)) as gross,
       round(-sum(quantity * unit_price) filter (where starts_with(invoice, 'C'))) as cancelled,
       round(100.0 * -sum(quantity * unit_price) filter (where starts_with(invoice, 'C'))
             / sum(quantity * unit_price) filter (where not starts_with(invoice, 'C') and quantity > 0), 2) as cancel_rate_pct
from raw where customer_id is not null
group by 1 order by 1;
```

**Result** (25 rows shown, 57 ms):

| month   |     gross |   cancelled |   cancel_rate_pct |
|:--------|----------:|------------:|------------------:|
| 2009-12 |   686,654 |      23,382 |              3.41 |
| 2010-01 |   557,319 |      25,366 |              4.55 |
| 2010-02 |   506,371 |      16,971 |              3.35 |
| 2010-03 |   699,609 |      63,613 |              9.09 |
| 2010-04 |   594,609 |      33,974 |              5.71 |
| 2010-05 |   599,986 |      40,061 |              6.68 |
| 2010-06 |   639,067 |      67,607 |             10.58 |
| 2010-07 |   591,637 |      28,851 |              4.88 |
| 2010-08 |   604,243 |      16,986 |              2.81 |
| 2010-09 |   831,615 |      50,582 |              6.08 |
| 2010-10 | 1,036,680 |      71,690 |              6.92 |
| 2010-11 | 1,172,336 |      37,457 |              3.2  |
| 2010-12 |   884,592 |      25,365 |              2.87 |
| 2011-01 |   569,445 |      94,371 |             16.57 |
| 2011-02 |   447,137 |      10,591 |              2.37 |
| 2011-03 |   595,501 |      15,536 |              2.61 |
| 2011-04 |   469,200 |      43,153 |              9.2  |
| 2011-05 |   678,595 |      30,343 |              4.47 |
| 2011-06 |   661,214 |      53,201 |              8.05 |
| 2011-07 |   600,091 |      25,853 |              4.31 |
| 2011-08 |   645,344 |      28,976 |              4.49 |
| 2011-09 |   952,838 |      21,398 |              2.25 |
| 2011-10 | 1,039,319 |      64,715 |              6.23 |
| 2011-11 | 1,161,817 |      29,410 |              2.53 |
| 2011-12 |   518,211 |     175,686 |             33.9  |
