# Analytics SQL Patterns

Fifteen SQL patterns that come up again and again in analytics work, each written against real public data and run with DuckDB. Every query answers one business question and states the pattern it uses. The output of every run is saved under [`results/`](results/).

Data: UCI Online Retail II, about 1.07M invoice lines from a UK online wholesaler, December 2009 to December 2011 (CC BY 4.0). Author: Junyi (Stanley) Ye · [jyye.org](https://jyye.org)

## The patterns

| # | Business question | Pattern | Output |
|---|---|---|---|
| 01 | How many raw lines are exact duplicates, and how much revenue would they double count? | `ROW_NUMBER()` over the natural key | [result](results/01_find_and_remove_duplicates.md) |
| 02 | Monthly revenue, orders, customers and AOV, with month-over-month change | CTE + `LAG()` | [result](results/02_monthly_kpis_mom.md) |
| 03 | Of customers who first bought in month M, what share came back k months later? | Cohorts + `date_diff` + conditional counts | [result](results/03_cohort_retention.md) |
| 04 | How much monthly revenue comes from first orders versus repeat orders? | Order sequence with `ROW_NUMBER()` + `FILTER` | [result](results/04_first_vs_repeat_revenue.md) |
| 05 | 7-day and 28-day rolling revenue, with no-sale days counted as zero | Calendar spine + window frames | [result](results/05_rolling_windows_with_calendar.md) |
| 06 | Who bought last month but not this month? | Anti-join with `NOT EXISTS` | [result](results/06_bought_last_month_not_this_month.md) |
| 07 | Score customers on recency, frequency and monetary value and name the segments | `NTILE()` + `CASE` rules | [result](results/07_rfm_segments.md) |
| 08 | Top three products in each of the five largest export markets | `ROW_NUMBER()` per group + `QUALIFY` | [result](results/08_top_n_per_group.md) |
| 09 | Who has the longest run of consecutive months with an order? | Gaps and islands | [result](results/09_gaps_and_islands_streaks.md) |
| 10 | Which products are bought together, and how much more than chance? | Self-join on invoice, support and lift | [result](results/10_market_basket_pairs.md) |
| 11 | 2011 revenue by month against the same month in 2010 | Conditional aggregation by year | [result](results/11_year_over_year.md) |
| 12 | What share of revenue comes from the top 1%, 10% and 20% of customers? | Running share over a ranking | [result](results/12_pareto_customer_concentration.md) |
| 13 | Median and 90th percentile order value by country | `quantile_cont()` | [result](results/13_percentiles_by_group.md) |
| 14 | Monthly cancellation rate | `FILTER` clauses in one pass | [result](results/14_cancellation_rate.md) |
| 15 | How long do customers take to place a second order? | `LEAD()` + bucketing | [result](results/15_time_to_second_order.md) |

## A few things the data says

- **Exact duplicates are not rare.** 3.2% of raw lines repeat another line exactly, which would double count about £0.5M of sales if left in (query 01).
- **Revenue is concentrated.** The top 10% of customers bring in about 64% of revenue, and the top 20% about 77% (query 12).
- **Many first-time buyers never return.** About 28% of customers place no second order within the two-year window, and about 23% come back within 30 days (query 15).
- **Champions carry the business.** The highest-scoring RFM segment holds about 69% of revenue (query 07).

## Conventions

- `sql/00_setup.sql` defines three views used by every query:
  - `raw`: the file as downloaded;
  - `sales`: completed product sales to identified customers, without cancellations, returns, postage and adjustment codes, or exact duplicates;
  - `orders`: one row per invoice.
- Every query starts with a `-- Q:` line (the business question) and a `-- Pattern:` line.
- Rankings break ties on `customer_id`, so results are reproducible.

## Run it

Requires [uv](https://docs.astral.sh/uv/).

```bash
uv sync
uv run python -I scripts/download_data.py   # downloads the dataset to data/raw/
uv run python -I scripts/run_all.py         # runs every query and rewrites results/
```

## Data and license

Code: MIT. Data is not committed. It is downloaded from the UCI Machine Learning Repository under CC BY 4.0: Chen, D. (2012). *Online Retail II* [Dataset]. https://doi.org/10.24432/C5CG6D
