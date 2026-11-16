/* Entity Tables*/
DROP TABLE IF EXISTS Biome;
CREATE TABLE IF NOT EXISTS Biome(
    biome_key int PRIMARY KEY, -- unique identifier for this biome
    type varchar(20) NOT NULL, -- Type of biome (forest, desert, tundra, volcano, hot_spring, savanna, ocean, etc.)
    size int DEFAULT 1, -- Amount of deposits in the biome (1-12)
    name varchar(20) -- More descriptive name for this biome
);

DROP TABLE IF EXISTS Extractor;
CREATE TABLE IF NOT EXISTS Extractor(
    extractor_key int PRIMARY KEY,
    power_consumption float DEFAULT 1.0,
    efficiency float DEFAULT 1.0
);

DROP TABLE IF EXISTS Constructor;
CREATE TABLE IF NOT EXISTS Constructor(
    constructor_key int PRIMARY KEY,
    power_consumption float DEFAULT 1.0, -- Increases by 1 for every ingredient in recipe
    efficiency float DEFAULT 1.0
);

DROP TABLE IF EXISTS Item;
CREATE TABLE IF NOT EXISTS Item(
    item_id varchar(30) PRIMARY KEY,
    name varchar(30) NOT NULL UNIQUE,
    state varchar(8), -- solid, liquid, gas, plasma
    description varchar(200),
    tier int, -- 0(Raw Resource)-5(Final Advanced Products)
    quantity float DEFAULT 0.0 -- stored quantity of this item
);

DROP TABLE IF EXISTS Ingredient;
CREATE TABLE IF NOT EXISTS Ingredient(
    ingredient_key int PRIMARY KEY,
    item_id varchar(30) NOT NULL, -- Of item used in library of items
    recipe_key int NOT NULL, -- Of recipe this is respective to
    cost float DEFAULT 0.0, -- quantity of ingredient needed for this recipe

    UNIQUE(item_id, recipe_key),
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (recipe_key) REFERENCES Recipe(recipe_key)
);

DROP TABLE IF EXISTS Product;
CREATE TABLE IF NOT EXISTS Product(
    product_key int PRIMARY KEY,
    item_id varchar(30),
    recipe_key int,
    base_yield float DEFAULT 0.0,

    UNIQUE(item_id, recipe_key, base_yield),
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (recipe_key) REFERENCES Recipe(recipe_key)
);

DROP TABLE IF EXISTS Recipe;
CREATE TABLE IF NOT EXISTS Recipe(
    recipe_key int PRIMARY KEY, -- unique recipe identifier
    product_key int NOT NULL,
    byproduct_key int, -- Null OK
    name varchar(30), -- optional name for this recipe

    FOREIGN KEY (product_key) REFERENCES Product(product_key),
    FOREIGN KEY (byproduct_key) REFERENCES Product(product_key)
);

DROP TABLE IF EXISTS Buyer;
CREATE TABLE IF NOT EXISTS Buyer(
    buyer_key int PRIMARY KEY,
    name varchar(30) NOT NULL
);

DROP TABLE IF EXISTS Manufacturer;
CREATE TABLE IF NOT EXISTS Manufacturer(
    manufacturer_key int PRIMARY KEY,
    name varchar(30) NOT NULL UNIQUE,
    money double DEFAULT 0.0,
    income_per_cycle double DEFAULT 0.0
);

/* Junction Tables */
DROP TABLE IF EXISTS Deposit;
CREATE TABLE IF NOT EXISTS Deposit(
    deposit_key int PRIMARY KEY, -- unique identifier
    biome_key int NOT NULL, -- key of biome this deposit is in
    item_id varchar(30) NOT NULL, -- ID of raw Tier 0 resource present
    purity float, -- A value between 0.1 and 10.0 arbitrary

    UNIQUE(biome_key, deposit_key),
    FOREIGN KEY (biome_key) REFERENCES Biome(biome_key),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

DROP TABLE IF EXISTS Extractions;
CREATE TABLE IF NOT EXISTS Extractions(
    extraction_key int PRIMARY KEY,
    extractor_key int NOT NULL,
    deposit_key int NOT NULL,

    UNIQUE(extractor_key, deposit_key), -- each extraction instance uses a unique extractor
    FOREIGN KEY (extractor_key) REFERENCES Extractor(extractor_key),
    FOREIGN KEY (deposit_key) REFERENCES Deposit(deposit_key)
);

DROP TABLE IF EXISTS Production;
CREATE TABLE IF NOT EXISTS Production(
    production_key int PRIMARY KEY,
    constructor_key int NOT NULL,
    recipe_key int NOT NULL,

    UNIQUE(production_key, constructor_key), -- each production intance uses a unique constructor
    FOREIGN KEY (constructor_key) REFERENCES Constructor(constructor_key),
    FOREIGN KEY (recipe_key) REFERENCES Recipe(recipe_key)
);

DROP TABLE IF EXISTS Market;
CREATE TABLE IF NOT EXISTS Market(
    transaction_key int PRIMARY KEY, -- unique identifier for this transaction
    manufacturer_key int NOT NULL, -- the manufacturer bought from
    buyer_key int NOT NULL, -- the buyer buying
    item_id varchar(30), -- the item being bought
    value double NOT NULL DEFAULT 1.00, -- price paid per cycle in dollars
    amnt_bought int NOT NULL DEFAULT 1, -- quantity buying

    UNIQUE(manufacturer_key, buyer_key, item_id), -- every manuf-buyer-item transaction should be unique
    FOREIGN KEY (manufacturer_key) REFERENCES Manufacturer(manufacturer_key),
    FOREIGN KEY (buyer_key) REFERENCES Buyer(buyer_key),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);