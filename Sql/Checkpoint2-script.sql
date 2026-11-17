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
-- Statement 01: [Member 1]: XX%, [Member 2]: XX%
-- Statement 02: [Member 1]: XX%, [Member 2]: XX%
-- Statement 03: [Member 1]: XX%, [Member 2]: XX%
-- Statement 04: [Member 1]: XX%, [Member 2]: XX%
-- Statement 05: [Member 1]: XX%, [Member 2]: XX%
-- Statement 06: [Member 1]: XX%, [Member 2]: XX%
-- Statement 07: [Member 1]: XX%, [Member 2]: XX%
-- Statement 08: [Member 1]: XX%, [Member 2]: XX%
-- Statement 09: [Member 1]: XX%, [Member 2]: XX%
-- Statement 10: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: [Member 1]: XX%, [Member 2]: XX%
-- Statement 12: [Member 1]: XX%, [Member 2]: XX%
-- Statement 13: [Member 1]: XX%, [Member 2]: XX%
-- Statement 14: [Member 1]: XX%, [Member 2]: XX%
-- Statement 15: [Member 1]: XX%, [Member 2]: XX%
-- Statement 16: [Member 1]: XX%, [Member 2]: XX%
-- Statement 17: [Member 1]: XX%, [Member 2]: XX%
-- Statement 18: [Member 1]: XX%, [Member 2]: XX%
-- Statement 19: [Member 1]: XX%, [Member 2]: XX%
-- Statement 20: [Member 1]: XX%, [Member 2]: XX%
-- Statement 21: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: [Member 1]: XX%, [Member 2]: XX%
-- Statement 23: [Member 1]: XX%, [Member 2]: XX%
-- Statement 24: [Member 1]: XX%, [Member 2]: XX%
-- Statement 25: [Member 1]: XX%, [Member 2]: XX%
-- Statement 26: [Member 1]: XX%, [Member 2]: XX%
-- Statement 27: [Member 1]: XX%, [Member 2]: XX%
-- Statement 28: [Member 1]: XX%, [Member 2]: XX%
-- Statement 29: [Member 1]: XX%, [Member 2]: XX%
-- Statement 30: [Member 1]: XX%, [Member 2]: XX%
-- Statement 31: [Member 1]: XX%, [Member 2]: XX%
-- Statement 32: [Member 1]: XX%, [Member 2]: XX%
-- ============================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
.headers on
.mode column


-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Roughly 10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes, 
--        basic sorting, simple aggregate functions, and pattern matching.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: [Brief Title]
-- Explanation: [1 to 2 sentences explaining what data the query retrieves 
--              or what state modification it performs].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 01 Here];

-- ----------------------------------------------------------------------------
-- Statement 02: [Brief Title]
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 02 Here];

-- [Continue Statements 03 through 10...]


-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Roughly 10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY 
--        and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the join logic, filtering, 
--              or conditional modification].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 11 Here];

-- [Continue Statements 12 through 21...]


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 22: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------

;

-- [Continue Statements 23 through 32...]