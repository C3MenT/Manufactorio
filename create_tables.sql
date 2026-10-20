/* Entity Tables*/

CREATE TABLE IF NOT EXISTS Biome(
    biome_key int PRIMARY KEY,
    type varchar(20) NOT NULL,
    size int DEFAULT 1,
    name varchar(20)
);

CREATE TABLE IF NOT EXISTS Deposit(
    deposit_key int PRIMARY KEY,
    biome_key int NOT NULL FOREIGN KEY (Biome),
    item_key NOT NULL FOREIGN KEY (Item),
    purity float
);

CREATE TABLE IF NOT EXISTS Extractor(
    extractor_key int PRIMARY KEY,
    item_extracting VARCHAR(30),
    efficiency float DEFAULT 1.0
);

CREATE TABLE IF NOT EXISTS Constructor(
    constructor_key int PRIMARY KEY,
    efficiency float DEFAULT 1.0
);

CREATE TABLE IF NOT EXISTS Item(
    item_key int PRIMARY KEY,
    name varchar(30) NOT NULL,
    quantity float DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS Ingredient(
    ingredient_key int PRIMARY KEY,
    item_key int NOT NULL FOREIGN KEY (Item),
    recipe_key int NOT NULL FOREIGN KEY (Recipe),
    cost float NOT NULL,
    UNIQUE(item_key, recipe_key, cost)
);

CREATE TABLE IF NOT EXISTS Product(
    product_key int PRIMARY KEY,
    item_key int NOT NULL FOREIGN KEY (Item),
    recipe_key int NOT NULL FOREIGN KEY (Recipe),
    base_yield float DEFAULT 0.0,
    UNIQUE(item_key, recipe_key, cost)
);

-- Each tuple corresponds to an input
CREATE TABLE IF NOT EXISTS Recipe(
    recipe_key int PRIMARY KEY,
    ingredient_key int NOT NULL FOREIGN KEY (Ingredient),
    product_key int NOT NULL FOREIGN KEY (Product),
    byproduct_key int FOREIGN KEY (Product), -- Null OK
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

CREATE TABLE IF NOT EXISTS Extractions(
    extraction_key int PRIMARY KEY,
    extractor_key int NOT NULL FOREIGN KEY (Extractor),
    deposit_key int NOT NULL FOREIGN KEY (Deposit),
    amnt_per_cycle float,
    UNIQUE(extractor_key, deposit_key)
);

CREATE TABLE IF NOT EXISTS Production(
    production_key int PRIMARY KEY,
    constructor_key int NOT NULL FOREIGN KEY (Constructor),
    recipe_id int NOT NULL FOREIGN KEY (Recipe),
    amnt_per_cycle float,
    UNIQUE(constructor_key, recipe_id)
);

CREATE TABLE IF NOT EXISTS Market(
    transaction_key int PRIMARY KEY,
    manufacturer_key int NOT NULL FOREIGN KEY (Manufacturer),
    buyer_key int NOT NULL FOREIGN KEY (Buyer),
    item_key int NOT NULL FOREIGN KEY (Item),
    value double NOT NULL DEFAULT 1.00, -- in dollars
    UNIQUE(manufacturer_key, buyer_key, item_key)
);