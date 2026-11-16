/*
Deepseek generated "random" tuple generator for the Market table such that
each tuple transaction refers to a buyer-manufacturer-item mapping influenced
by the buyer's wealth attribute and the manudacturer's reputation attribute.

--------------------------Additional Notes from LLM--------------------------

Uniqueness: 
The UNIQUE(manufacturer_key, buyer_key, item_id) constraint is enforced by the ROW_NUMBER() 
dedup step, which keeps only the first candidate for each triple. With 200 candidates and 
10×20×~160 possible triples, collisions are rare but possible, so dedup is necessary.

PRNG substitute: Since standard SQL has no RAND() inside a set-based insert that guarantees 
uniqueness, the script uses deterministic modular arithmetic (n * prime + offset) to spread 
values across manufacturers, buyers, items, and random-like floats. If your DBMS supports 
RAND()/RANDOM(), you can substitute it in the candidates CTE — just keep the dedup step.

Value bounds: 
The reputation term is ±0.25, wealth term ±0.20, noise ±0.05, giving a max natural deviation 
of ±0.50 — exactly the requested bound — and the MAX/MIN clamp guarantees it even if terms are 
combined.

Amount bought: 
Uniform 1..50; you can change % 50 + 1 to adjust.

Reputation 1–10 mapping: 
rep 1 → −0.25 (low quality, buyers pay less), rep 10 → +0.25. Wealth 1 → −0.20, wealth 10 → +0.20. 
This matches the schema comments ("higher reputation → wealthier buyers pay more"; "wealth gauges 
likelihood to pay above market").

Adjusting volume: 
Change WHERE n < 200 to increase/decrease the candidate pool. Because of dedup, the final row count 
will be ≤ the candidate count.
*/

-- ------------------------------------------------------------
-- Populate Market with ~200 randomized transactions.
-- Uses a recursive CTE to generate candidate rows, then
-- filters to unique (manufacturer, buyer, item) triples.
-- ------------------------------------------------------------
INSERT INTO Market (transaction_key, manufacturer_key, buyer_key, item_id, value, amnt_bought)
WITH RECURSIVE
  -- 1..200 candidate row numbers
  nums(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 200 -- Max Candidate Pool
  ),
  -- pseudo-randomly pick manufacturer, buyer, item for each candidate
  -- (uses n with different multipliers/moduli as a cheap PRNG)
  candidates AS (
    SELECT
      n AS transaction_key,
      -- Manufacturer: 1..10
      ((n * 7 + 3) % 10) + 1 AS manufacturer_key,
      -- Buyer: 1..20
      ((n * 13 + 5) % 20) + 1 AS buyer_key,
      -- Item: pick from all item_ids ordered, using modulo count
      (SELECT item_id FROM Item ORDER BY item_id
        LIMIT 1 OFFSET ((n * 31 + 11) % (SELECT COUNT(*) FROM Item))) AS item_id,
      -- raw random-like floats in [0,1)
      ((n * 97 + 17) % 1000) / 1000.0 AS rnd1,
      ((n * 53 + 29) % 1000) / 1000.0 AS rnd2,
      ((n * 71 + 41) % 1000) / 1000.0 AS rnd3,
      -- amount bought: 1..50
      ((n * 19 + 7) % 50) + 1 AS amnt_bought
    FROM nums
  ),
  -- join to get market_value, reputation, wealth
  joined AS (
    SELECT
      c.transaction_key,
      c.manufacturer_key,
      c.buyer_key,
      c.item_id,
      c.rnd1,
      c.rnd2,
      c.rnd3,
      c.amnt_bought,
      i.market_value,
      m.reputation,
      b.wealth
    FROM candidates c
    JOIN Item i ON i.item_id = c.item_id
    JOIN Manufacturer m ON m.manufacturer_key = c.manufacturer_key
    JOIN Buyer b ON b.buyer_key = c.buyer_key
  ),
  -- compute value with clamped deviation
  priced AS (
    SELECT
      transaction_key,
      manufacturer_key,
      buyer_key,
      item_id,
      amnt_bought,
      -- reputation deviation: rep 1..10 mapped to -0.25..+0.25
      --   (rep-1)/9 * 0.5 - 0.25
      -- wealth deviation: wealth 1..10 mapped to -0.20..+0.20
      --   (wealth-1)/9 * 0.4 - 0.20
      -- noise: (rnd3 - 0.5) * 0.10  -> -0.05..+0.05
      ROUND(
        market_value *
        (1.0 + MAX(-0.5, MIN(0.5,
            ( ((reputation - 1) / 9.0) * 0.5 - 0.25 )
          + ( ((wealth - 1) / 9.0) * 0.4 - 0.20 )
          + ( (rnd3 - 0.5) * 0.10 )
        ))),
        2
      ) AS value
    FROM joined
  ),
  -- keep only first occurrence of each (manufacturer, buyer, item)
  deduped AS (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY manufacturer_key, buyer_key, item_id
             ORDER BY transaction_key
           ) AS rn
    FROM priced
  )
SELECT transaction_key, manufacturer_key, buyer_key, item_id, value, amnt_bought
FROM deduped
WHERE rn = 1
ORDER BY transaction_key;