CREATE TABLE IF NOT EXISTS Biome(
    biome_key int PRIMARY KEY,
    type varchar(20) NOT NULL,
    size int DEFAULT 1,
    name varchar(20)
);

CREATE TABLE IF NOT EXISTS Item(
    item_key int PRIMARY KEY,
    name varchar(30) NOT NULL,
    quantity float DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS Extractor(
    extractor_key int PRIMARY KEY,
    efficiency float DEFAULT 1.0,
    deposit_key int NOT NULL
);

CREATE TABLE IF NOT EXISTS Constructor(
    constructor_key int PRIMARY KEY,
    efficiency float DEFAULT 1.0
);

CREATE TABLE IF NOT EXISTS Buyer(
    buyer_key int PRIMARY KEY,
    name varchar(30)
);

CREATE TABLE IF NOT EXISTS Manufacturer(
    manufacturer_key int PRIMARY KEY,
    name varchar(30) NOT NULL UNIQUE,
    money double DEFAULT 0.0,
    income_per_cycle double DEFAULT 0.0
);

/* Junction Tables */

-- Each tuple corresponds to an input
CREATE TABLE IF NOT EXISTS Recipe(
    recipe_key int NOT NULL,
    input_item_key int NOT NULL,
    output_item_key int NOT NULL,
    byproduct_item_key int,
    input_consumption float DEFAULT 1.0,
    base_output_yield float DEFAULT 1.0,
    base_byproduct_yield float DEFAULT 0.0,
    PRIMARY KEY(recipe_key, input_item_key, output_item_key)
);

CREATE TABLE IF NOT EXISTS Deposits(
    deposit_key int PRIMARY KEY,
    item_key int NOT NULL,
    extractor_key NOT NULL UNIQUE,
    purity float DEFAULT 0.5
);

CREATE TABLE IF NOT EXISTS Extractions(
    extraction_key int PRIMARY KEY,
    extractor_key int NOT NULL,
    deposit_key int NOT NULL,
    quantity_per_cycle float,
    UNIQUE(extractor_key, deposit_key)
);

CREATE TABLE IF NOT EXISTS Production(
    production_key int PRIMARY KEY,
    constructor_key int NOT NULL,
    recipe_id int NOT NULL,
    UNIQUE(constructor_key, recipe_id)
);

CREATE TABLE IF NOT EXISTS Market(
    market_key int PRIMARY KEY,
    manufacturer_key int NOT NULL,
    buyer_key int NOT NULL,
    item_key int NOT NULL,
    UNIQUE(manufacturer_key, buyer_key, item_key)
);

-- A + BC = (A + B)(A + C)