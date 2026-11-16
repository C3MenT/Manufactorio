/*
Just the tables involved with the Biomes
*/

DROP TABLE IF EXISTS Biome;
CREATE TABLE IF NOT EXISTS Biome(
    biome_key int PRIMARY KEY, -- unique identifier for this biome
    type varchar(20) NOT NULL, -- Type of biome (forest, desert, tundra, volcano, hot_spring, savanna, ocean, etc.)
    size int DEFAULT 1, -- Amount of deposits in the biome (1-12)
    name varchar(20) -- More descriptive name for this biome
);

DROP TABLE IF EXISTS Deposit;
CREATE TABLE IF NOT EXISTS Deposit(
    deposit_key int PRIMARY KEY, -- unique identifier
    biome_key int NOT NULL, -- key of biome this deposit is in
    item_id varchar(30) NOT NULL, -- ID of raw Tier 0 resource present
    purity float, -- A value between 0.1 and 10.0 arbitrary

    FOREIGN KEY (biome_key) REFERENCES Biome(biome_key),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);