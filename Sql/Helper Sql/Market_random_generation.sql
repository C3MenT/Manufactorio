/*ChatGPT Script*/

-- Generate randomized Market transactions from the populated Buyer,
-- Manufacturer, and Item tables.
-- Intended for SQLite 3.25+ (uses window functions).
--
-- Pricing:
--   Buyer wealth and manufacturer reputation influence the price.
--   A small random fluctuation adds variety.
--   The final price is clamped to +/- 50% of Item.market_value.
--
-- Transaction selection:
--   Each manufacturer/buyer/item combination is considered once.
--   Higher buyer wealth and manufacturer reputation increase the chance
--   of a transaction. Probability ranges from 8% to 35%.
--
-- Existing Market rows are preserved. The UNIQUE constraint prevents
-- duplicate manufacturer/buyer/item combinations if this is rerun.

PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

DROP TABLE IF EXISTS temp._MarketCandidates;

CREATE TEMP TABLE _MarketCandidates AS
WITH
ManufacturerRanks AS (
    SELECT
        manufacturer_key,
        reputation,
        CASE
            WHEN COUNT(*) OVER () <= 1 THEN 0.5
            ELSE CAST(RANK() OVER (ORDER BY reputation) - 1 AS REAL)
                 / (COUNT(*) OVER () - 1)
        END AS reputation_rank
    FROM Manufacturer
),
CandidatePairs AS (
    SELECT
        m.manufacturer_key,
        b.buyer_key,
        i.item_id,
        i.market_value,
        b.wealth,
        mr.reputation_rank,
        0.08
          + 0.12 * ((b.wealth - 1.0) / 9.0)
          + 0.15 * mr.reputation_rank AS transaction_probability,
        (random() + 9223372036854775808.0)
          / 18446744073709551616.0 AS selection_draw,
        (random() + 9223372036854775808.0)
          / 18446744073709551616.0 AS price_noise_draw,
        1 + (abs(random()) % 5) AS quantity_bought
    FROM Manufacturer AS m
    CROSS JOIN Buyer AS b
    CROSS JOIN Item AS i
    JOIN ManufacturerRanks AS mr
      ON mr.manufacturer_key = m.manufacturer_key
    WHERE i.market_value IS NOT NULL
)
SELECT
    manufacturer_key,
    buyer_key,
    item_id,
    market_value,
    wealth,
    reputation_rank,
    price_noise_draw,
    quantity_bought
FROM CandidatePairs
WHERE selection_draw < transaction_probability;

INSERT OR IGNORE INTO Market (
    transaction_key,
    manufacturer_key,
    buyer_key,
    item_id,
    value,
    amnt_bought
)
SELECT
    COALESCE((SELECT MAX(transaction_key) FROM Market), 0)
      + ROW_NUMBER() OVER (
          ORDER BY manufacturer_key, buyer_key, item_id
        ) AS transaction_key,
    manufacturer_key,
    buyer_key,
    item_id,
    ROUND(
        market_value * (
            1.0 + MAX(
                -0.50,
                MIN(
                    0.50,
                    0.225 * ((wealth - 5.5) / 4.5)
                    + 0.225 * ((2.0 * reputation_rank) - 1.0)
                    + (price_noise_draw * 0.10 - 0.05)
                )
            )
        ),
        2
    ) AS value,
    quantity_bought AS amnt_bought
FROM _MarketCandidates;

DROP TABLE temp._MarketCandidates;
COMMIT;

-- Optional validation:
-- SELECT COUNT(*) AS market_transaction_count FROM Market;
-- SELECT * FROM Market ORDER BY transaction_key;
-- SELECT MIN(value), MAX(value), AVG(value) FROM Market;
