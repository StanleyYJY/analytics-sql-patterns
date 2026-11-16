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
