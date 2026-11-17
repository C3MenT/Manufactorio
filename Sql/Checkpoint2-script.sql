-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: Manufactorio
-- Team Members: Ri'chard McCray, Joshua Parilla
-- File: Checkpoint2-script.sql
-- ============================================================================

-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- Explain any modifications to your relational schema made since Checkpoint 1.
-- (e.g., added indexes, modified check constraints, renamed columns, or 
--  clarified weak entity vs. junction relationships). If no changes were made, 
--  explicitly state: "No modifications made to the Checkpoint 1 schema."
--
-- Modifications:
-- 1. Item's item_key (int) attribute change to item_id (varchar)
-- 2. Item received state (varchar) attribute
-- 3. Item received tier (int) attribute
-- 4. Referencial foreign keys have been added for most shared item_id instances
-- 5. Deposit received a Unique constraint between deposit_id and biome_id
-- 6. Constructor and Extractor recieved power_consumption (float) attribute
-- 7. Extraction and Production relations lost amnt_per_cycle (float) attribute due to redundancy
-- 8. Item relation recieved a market_value (double) attribute
-- 9. Buyer relation recieved a wealth (int) attribute
-- 10. Manufacturer relation received a reputation (int) attribute
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 02: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 03: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 04: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 05: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 06: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 07: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 08: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 09: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 10: Ri'chard McCray: 100%, Joshua Parilla: 0%

-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 12: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 13: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 14: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 15: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 16: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 17: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 18: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 19: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 20: Ri'chard McCray: 100%, Joshua Parilla: 0%

-- SECTION 3: COMPLEX STATEMENTS
-- Statement 21: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 22: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 23: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 24: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 25: Ri'chard McCray: 0%, Joshua Parilla: 100%
-- Statement 26: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 27: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 28: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 29: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- Statement 30: Ri'chard McCray: 100%, Joshua Parilla: 0%
-- ============================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
--.headers on
--.mode column


-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Roughly 10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes, 
--        basic sorting, simple aggregate functions, and pattern matching.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: Query 1
-- Explanation: Retrieve names and market values of all items with market value > 100
-- ----------------------------------------------------------------------------
select distinct(name), market_value from item where market_value > 100; 

-- ----------------------------------------------------------------------------
-- Statement 02: Query 2
-- Explanation: Retrieve names and tiers of all items in the Solid state, ordered by tier (high/low) 
-- ----------------------------------------------------------------------------
select distinct(name), tier from item where state = "Solid" order by tier desc; 

-- ----------------------------------------------------------------------------
-- Statement 03: Query 3
-- Explanation: Count the total number of items in each state 
-- ----------------------------------------------------------------------------
select state, count(name) from item group by state; 

-- ----------------------------------------------------------------------------
-- Statement 04: Query 4
-- Explanation: Retrieve names and wealth of all buyers whose wealth exceeds 5 
-- ----------------------------------------------------------------------------
select name, wealth from buyer where wealth > 5; 

-- ----------------------------------------------------------------------------
-- Statement 05: Query 5
-- Explanation: Retrieve names of all items containing "Iron" in their name 
-- ----------------------------------------------------------------------------
select name from item where name like "%Iron%"; 

-- ----------------------------------------------------------------------------
-- Statement 06: Purity Report
-- Explanation: Get all deposits and their purity
-- ----------------------------------------------------------------------------
SELECT Deposit.deposit_key, Deposit.purity
FROM Deposit
ORDER BY Deposit.purity DESC;

-- ----------------------------------------------------------------------------
-- Statement 07: Desert Counter
-- Explanation: Count the amount of desert biomes
-- ----------------------------------------------------------------------------
SELECT COUNT(Biome.biome_key) AS Amount
FROM Biome
WHERE Biome.type = 'desert';

-- ----------------------------------------------------------------------------
-- Statement 08: Desert Adder
-- Explanation: Inserts a new desert biome.
-- ----------------------------------------------------------------------------
INSERT INTO Biome
VALUES ((SELECT MAX(Biome.biome_key) FROM Biome) + 1, 'desert', 9, 'New Desert');

-- ----------------------------------------------------------------------------
-- Statement 09: Specific Biome Selection by Name
-- Explanation: Get the specific Biome specified by name. Checks for previously
-- added new desert.
-- ----------------------------------------------------------------------------
-- Query for getting the new desert
SELECT * FROM Biome WHERE Biome.name = 'New Desert';

-- ----------------------------------------------------------------------------
-- Statement 10: Specific Biome Deletion by Name
-- Explanation: Delete the specific Biome specified by name. Removes previously
-- added new desert.
-- ----------------------------------------------------------------------------
DELETE FROM Biome WHERE Biome.name = 'New Desert';


-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Roughly 10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY 
--        and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Query 1
-- Explanation: Retrieve each manufacturer's name alongside the total number of market transactions they 
-- participated in
-- ----------------------------------------------------------------------------
select MAN.name, count(transaction_key) 
from manufacturer MAN, market MAR
where MAN.manufacturer_key = MAR.manufacturer_key 
group by MAN.name; 

-- ----------------------------------------------------------------------------
-- Statement 12: Query 2
-- Explanation: Retrieve names of all items sold in the market, along with their transaction values 
-- ----------------------------------------------------------------------------
select I.name, m.value 
from item I, market M 
where I.item_id = M.item_id; 

-- ----------------------------------------------------------------------------
-- Statement 13: Query 3
-- Explanation: Retrieve each biome's name and the total number of deposits within it 
-- ----------------------------------------------------------------------------
select B.name, count(deposit_key) 
from biome B, deposit D 
where D.biome_key = B.biome_key 
group by B.name; 

-- ----------------------------------------------------------------------------
-- Statement 14: Query 4
-- Explanation: Retrieve names of manufacturers whose total market sales value exceeds 1000
--          (transaction value * amount bought)
-- ----------------------------------------------------------------------------
select distinct(MAN.name), sum(MAR.value * amnt_bought) as total_market_sales
from manufacturer MAN, market MAR 
where MAN.manufacturer_key = MAR.manufacturer_key 
group by MAN.name 
having total_market_sales > 1000; 

-- ----------------------------------------------------------------------------
-- Statement 15: Query 5
-- Explanation: Retrieve names and market values of all items whose market value exceeds the 
--          average market value across all items 
-- ----------------------------------------------------------------------------
select I1.name, I1.market_value 
from item I1 
where I1.market_value > (
    select avg(I2.market_value) from item I2
); 


-- ----------------------------------------------------------------------------
-- Statement 16: Biomes(s) with the Most Raw Resource Value.
-- Explanation: Query returns the Biome(s) with the highest combinesd 
-- raw available resource market value.
-- ----------------------------------------------------------------------------
SELECT name AS 'Biome Name', MAX(total_value) AS Value
FROM (
SELECT Biome.name, SUM(Item.market_value) AS total_value
FROM Item
INNER JOIN Deposit ON Item.item_id = Deposit.item_id
INNER JOIN Biome ON Biome.biome_key = Deposit.biome_key
GROUP BY Biome.biome_key
);

-- ----------------------------------------------------------------------------
-- Statement 17: Biomes(s) with Greater than Average Deposit Purity
-- Explanation: Query returns the Biome(s) with average deposit purity
-- greater than the avearage deposit purity across all biomes.
-- ----------------------------------------------------------------------------

WITH BiomePurAvg AS (
-- Biomes to their average deposit purity
    SELECT Biome.name AS biome_name, Biome.biome_key, AVG(Deposit.purity) AS avg_purity
    FROM Deposit
    INNER JOIN Biome ON Biome.biome_key = Deposit.biome_key
    GROUP BY Biome.biome_key
),
AvgBiomePurity AS (
SELECT AVG(avg_purity) AS val
FROM BiomePurAvg
)

SELECT biome_name, avg_purity
FROM BiomePurAvg, AvgBiomePurity
WHERE BiomePurAvg.avg_purity > AvgBiomePurity.val
ORDER BY avg_purity DESC;

-- ----------------------------------------------------------------------------
-- Statement 18: Recipes With the Most Power Consumption
-- Explanation: Query returns which recipes have the most power consumption
-- amongst constructors responsible for them.
-- ----------------------------------------------------------------------------
WITH RecipePower AS (
    SELECT Recipe.recipe_key, Recipe.name, Constructor.power_consumption AS power
    FROM Recipe
    INNER JOIN Production ON Production.recipe_key = Recipe.recipe_key
    INNER JOIN Constructor ON Production.constructor_key = Constructor.constructor_key
),
MaxPower AS (
    SELECT MAX(power) AS val
    FROM RecipePower
)
SELECT DISTINCT name, power
FROM RecipePower, MaxPower
WHERE power = MaxPower.val;

-- ----------------------------------------------------------------------------
-- Statement 19: 
-- Explanation: 
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- Statement 20: 
-- Explanation: 
-- ----------------------------------------------------------------------------



-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: 
-- Explanation: 
-- ----------------------------------------------------------------------------
-- Query 1: Retrieve names of items appearing in at least one Market transaction 
select I1.name 
from item I1 
where exists (
    select I2.name 
    from item I2, market M
    where I2.item_id = M.item_id
        and I1.name = I2.name
); 
-- ----------------------------------------------------------------------------
-- Statement 22: 
-- Explanation: Retrieve names of items that have never appeared in a Market transaction 
-- ----------------------------------------------------------------------------
select I1.name 
from item I1 
where not exists (
    select I2.name 
    from item I2, market M 
    where I2.item_id = M.item_id 
        and I1.name = I2.name
); 

-- ----------------------------------------------------------------------------
-- Statement 23: 
-- Explanation: Calculate manufacturer revenue and retrieve the top five 
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- Statement 24: 
-- Explanation: Rank item market values within their tiers using dense_rank 
-- ----------------------------------------------------------------------------
select name, tier, market_value, 
    dense_rank() over (
        partition by tier 
        order by market_value desc
    ) as item_rank 
from item; 

-- ----------------------------------------------------------------------------
-- Statement 25: 
-- Explanation: Use intersect to retrieve item ids appearing in both Ingredient and Product
-- ----------------------------------------------------------------------------
select item_id from ingredient 
intersect 
select item_id from product; 



-- ----------------------------------------------------------------------------
-- Statement 26: Item-Recipe View
-- Explanation: Query declares a view that maps essential Item data with each
-- Recipe which they are apart of's key and recipe name.
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS ItemRecipe;

CREATE VIEW IF NOT EXISTS ItemRecipe AS
SELECT Item.item_id, Item.name AS item_name, tier, Recipe.recipe_key, Recipe.name AS recipe_name
FROM Item 
INNER JOIN Product ON Item.item_id = Product.item_id
INNER JOIN Recipe ON Product.recipe_key = Recipe.recipe_key;

SELECT * FROM ItemRecipe;

-- ----------------------------------------------------------------------------
-- Statement 27: Item-Constructor View 
-- Explanation: Query makes a view mapping Items, their constructor, and the Power 
-- Consumption required to make them.
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS ItemConstructor;

CREATE VIEW IF NOT EXISTS ItemConstructor AS
SELECT Item.item_id, Item.name, Constructor.constructor_key, Constructor.power_consumption, Constructor.efficiency
FROM Item
INNER JOIN Product ON Product.item_id = Item.item_id
INNER JOIN Production ON Production.recipe_key = Product.recipe_key
INNER JOIN Constructor ON Constructor.constructor_key = Production.constructor_key;


SELECT * FROM ItemConstructor;

-- ----------------------------------------------------------------------------
-- Statement 28: Recursive Recipe Roadmap
-- Explanation: Query recursively lists all of the items that make up a given
-- item and their associated "depth" or step they are a part of in a branch.
-- Alternative recipes are shown as seperate branches.
-- Intermediate branches without leaves are also shown.
-- The item used in the query is currently a Car as an example.
-- ----------------------------------------------------------------------------
WITH RECURSIVE
    ItemRecipeIngredient AS (
        SELECT
            ItemRecipe.item_id AS product_id, -- Recipe output (current parent)
            ItemRecipe.recipe_key AS recipe_key, -- For grouping tuples in aggregation after
            Ingredient.item_id AS ingredient_id -- Required ingredient (will be child)
        FROM ItemRecipe
        INNER JOIN Ingredient
            ON Ingredient.recipe_key = ItemRecipe.recipe_key
    ),
    CraftingTree AS (
        -- 1. Anchor: Start with the target item to craft
        SELECT
            product_id,
            recipe_key,
            ingredient_id,
            1 AS depth,
            CAST(product_id || ' -> ' || ingredient_id AS TEXT) AS craft_path
        FROM ItemRecipeIngredient
        WHERE product_id = 'vehicle_car'  -- Target item id (arbitrary)

        UNION ALL

        -- 2. Recursive Step: Find and add for recipes that produce the required ingredients
        SELECT
            child.product_id,
            child.recipe_key,
            child.ingredient_id,
            parent.depth + 1,
            parent.craft_path || ' -> ' || child.ingredient_id
        FROM ItemRecipeIngredient AS child
        INNER JOIN CraftingTree AS parent
            ON child.product_id = parent.ingredient_id
    )
-- Output all branches
SELECT DISTINCT product_id AS 'Item', craft_path AS 'Ingredient Branch', depth, recipe_key 
FROM CraftingTree
GROUP BY recipe_key
ORDER BY depth DESC;

-- ----------------------------------------------------------------------------
-- Statement 29: Predict Manufacturer(s) Total Power Consumption
-- Explanation: Query returns a prediction of each manufacturer(s) total
-- power consumption in industry based on the constructors and the extractors
-- of the player and what items each manufacturer is selling in the market.
-- ----------------------------------------------------------------------------
SELECT Manufacturer.name AS Manufactuerer, SUM(power_consumption) AS PowerUse
FROM (
    SELECT 
        ItemConstructor.item_id, 
        ItemConstructor.name AS item_name, 
        ItemConstructor.constructor_key, 
        Market.manufacturer_key, 
        Market.amnt_bought, 
        Market.transaction_key, 
        ItemConstructor.power_consumption
    FROM ItemConstructor
    INNER JOIN Market ON Market.item_id = ItemConstructor.item_id
) AS ItemTransPower
INNER JOIN Manufacturer 
    ON Manufacturer.manufacturer_key = ItemTransPower.manufacturer_key

GROUP BY ItemTransPower.manufacturer_key
ORDER BY PowerUse DESC, Manufactuerer
;


/*
-- ----------------------------------------------------------------------------
-- Statement 30: 
-- Explanation: Get All Manufacturers with a total revenue between the lowest 0.25
-- and highest 0.25 percentage of the average total market (market value) revenue
-- ----------------------------------------------------------------------------
WITH AvgMarketSaleValue AS (
    SELECT AVG(Market.amnt_bought * Item.market_value) AS val
    FROM Market
    INNER JOIN Item ON Item.item_id = Market.item_id
    
), ManufMarket AS ( -- Manuf-Value they sold item tuples
    SELECT Manufacturer.name, SUM(Market.amnt_bought * Market.value) AS TotalRev
    FROM Market
    INNER JOIN Manufacturer ON Manufacturer.manufacturer_key = Market.manufacturer_key
    GROUP BY Manufacturer.manufacturer_key
)

-- Manufacturers that make less than 0.5 of Avg
SELECT *
FROM ManufMarket, AvgMarketSaleValue
WHERE ManufMarket.TotalRev < (0.5 * AvgMarketSaleValue.val);

*/