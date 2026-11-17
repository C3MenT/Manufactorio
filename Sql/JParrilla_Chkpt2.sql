.headers on 
.mode column 

-- Simple Statements 
-- Query 1: Retrieve names and market values of all items with market value > 100
select distinct(name), market_value from item where market_value > 100; 

-- Query 2: Retrieve names and tiers of all items in the Solid state, ordered by tier (high/low) 
select distinct(name), tier from item where state = "Solid" order by tier desc; 

-- Query 3: Count the total number of items in each state 
select state, count(name) from item group by state; 

-- Query 4: Retrieve names and wealth of all buyers whose wealth exceeds 5 
select name, wealth from buyer where wealth > 5; 

-- Query 5: Retrieve names of all items containing "Iron" in their name 
select name from item where name like "%Iron%"; 

----------------------------------------------------------------------------------------------------- 

-- Intermediate Statements 
-- Query 1: Retrieve each manufacturer's name alongside the total number of market transactions they 
--          participated in
select MAN.name, count(transaction_key) 
from manufacturer MAN, market MAR
where MAN.manufacturer_key = MAR.manufacturer_key 
group by MAN.name; 

-- Query 2: Retrieve names of all items sold in the market, along with their transaction values 
select I.name, m.value 
from item I, market M 
where I.item_id = M.item_id; 

-- Query 3: Retrieve each biome's name and the total number of deposits within it 
select B.name, count(deposit_key) 
from biome B, deposit D 
where D.biome_key = B.biome_key 
group by B.name; 

-- Query 4: Retrieve names of manufacturers whose total market sales value exceeds 1000
--          (transaction value * amount bought)
select distinct(MAN.name), sum(MAR.value * amnt_bought) as total_market_sales
from manufacturer MAN, market MAR 
where MAN.manufacturer_key = MAR.manufacturer_key 
group by MAN.name 
having total_market_sales > 1000; 

-- Query 5: Retrieve names and market values of all items whose market value exceeds the 
--          average market value across all items 
select I1.name, I1.market_value 
from item I1 
where I1.market_value > (
    select avg(I2.market_value) from item I2
); 

----------------------------------------------------------------------------------------------------- 

-- Complex Statements 
-- Query 1: Retrieve names of items appearing in at least one Market transaction 
select I1.name 
from item I1 
where exists (
    select I2.name 
    from item I2, market M
    where I2.item_id = M.item_id
        and I1.name = I2.name
); 

-- Query 2: Retrieve names of items that have never appeared in a Market transaction 
select I1.name 
from item I1 
where not exists (
    select I2.name 
    from item I2, market M 
    where I2.item_id = M.item_id 
        and I1.name = I2.name
); 

-- Query 3: Calculate manufacturer revenue and retrieve the top five 
with manufacturer_revenue as (
    select MAN.name, sum(MAR.value * amnt_bought) as revenue
    from manufacturer MAN, market MAR 
    where MAN.manufacturer_key = MAR.manufacturer_key
    group by MAN.name 
)
select name, revenue 
from manufacturer_revenue 
order by revenue desc 
limit 5; 

-- Query 4: Rank item market values within their tiers using dense_rank 
select name, tier, market_value, 
    dense_rank() over (
        partition by tier 
        order by market_value desc
    ) as item_rank 
from item; 

-- Query 5: Use intersect to retrieve item ids appearing in both Ingredient and Product 
select item_id from ingredient 
intersect 
select item_id from product; 