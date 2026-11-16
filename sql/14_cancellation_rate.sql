-- Q: Monthly cancellation rate (cancelled amount over gross sales) for identified customers.
-- Pattern: FILTER clauses for conditional sums in one pass over the raw table.
select strftime(date_trunc('month', invoice_ts), '%Y-%m') as month,
       round(sum(quantity * unit_price) filter (where not starts_with(invoice, 'C') and quantity > 0)) as gross,
       round(-sum(quantity * unit_price) filter (where starts_with(invoice, 'C'))) as cancelled,
       round(100.0 * -sum(quantity * unit_price) filter (where starts_with(invoice, 'C'))
             / sum(quantity * unit_price) filter (where not starts_with(invoice, 'C') and quantity > 0), 2) as cancel_rate_pct
from raw where customer_id is not null
group by 1 order by 1;
