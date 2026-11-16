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
