-- Shared views. raw = the file as downloaded; sales = completed product sales to known
-- customers, exact duplicates removed; orders = one row per invoice.
create or replace view raw as
select * from read_parquet('data/raw/online_retail_ii.parquet');

create or replace view sales as
select
    invoice, upper(trim(stock_code)) as stock_code, description, quantity, unit_price,
    quantity * unit_price as amount, invoice_ts, cast(invoice_ts as date) as order_date,
    customer_id, country
from raw
where not starts_with(invoice, 'C')
  and quantity > 0 and unit_price > 0 and customer_id is not null
  and not regexp_matches(upper(trim(stock_code)), '^(POST|DOT|M|D|C2|BANK CHARGES|AMAZONFEE|CRUK|PADS|S|B|ADJUST2?|GIFT_.*|TEST.*)$')
qualify row_number() over (partition by invoice, stock_code, quantity, unit_price, invoice_ts, customer_id order by description) = 1;

create or replace view orders as
select invoice, any_value(customer_id) as customer_id, min(order_date) as order_date,
       any_value(country) as country, sum(amount) as revenue, count(*) as lines
from sales group by invoice;
