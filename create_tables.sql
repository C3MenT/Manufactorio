/* Entity Tables*/
CREATE TABLE IF NOT EXISTS Biome(
    biome_key int PRIMARY KEY,

    type varchar(20) NOT NULL,
    size int DEFAULT 1,
    name varchar(20)
);

CREATE TABLE IF NOT EXISTS Deposit(
    deposit_key int PRIMARY KEY,

    biome_key int,
    item_key NOT NULL,
    purity float,

    FOREIGN KEY (biome_key) REFERENCES Biome(biome_key),
    FOREIGN KEY (item_key) REFERENCES Item(item_key)
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

    item_key int, -- Of item used in library of items
    recipe_key int, -- Of recipe this is respective to
    cost float DEFAULT 0.0,

    UNIQUE(item_key, recipe_key, cost),

    FOREIGN KEY (item_key) REFERENCES Item(item_key),
    FOREIGN KEY (recipe_key) REFERENCES Recipe(recipe_key)
);

CREATE TABLE IF NOT EXISTS Product(
    product_key int PRIMARY KEY,

    item_key int,
    recipe_key int,
    base_yield float DEFAULT 0.0,

    UNIQUE(item_key, recipe_key, base_yield),
    FOREIGN KEY (item_key) REFERENCES Item(item_key),
    FOREIGN KEY (recipe_key) REFERENCES Recipe(recipe_key)
);

CREATE TABLE IF NOT EXISTS Recipe(
    recipe_key int PRIMARY KEY,

    product_key int,
    byproduct_key int, -- Null OK

    FOREIGN KEY (product_key) REFERENCES Product(product_key),
    FOREIGN KEY (byproduct_key) REFERENCES Product(product_key)
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

    extractor_key int,
    deposit_key int,
    amnt_per_cycle float,

    UNIQUE(extractor_key, deposit_key),
    FOREIGN KEY (extractor_key) REFERENCES Extractor(extractor_key),
    FOREIGN KEY (deposit_key) REFERENCES Deposit(deposit_key)
);

CREATE TABLE IF NOT EXISTS Production(
    production_key int PRIMARY KEY,

    constructor_key int,
    recipe_key int,
    amnt_per_cycle float,

    UNIQUE(constructor_key, recipe_key),
    FOREIGN KEY (constructor_key) REFERENCES Constructor(constructor_key),
    FOREIGN KEY (recipe_key) REFERENCES Recipe(recipe_key)
);

CREATE TABLE IF NOT EXISTS Market(
    transaction_key int PRIMARY KEY,

    manufacturer_key int,
    buyer_key int,
    item_key int,
    value double NOT NULL DEFAULT 1.00, -- in dollars
    amnt_bought int NOT NULL DEFAULT 1,

    UNIQUE(manufacturer_key, buyer_key, item_key),
    FOREIGN KEY (manufacturer_key) REFERENCES Manufacturer(manufacturer_key),
    FOREIGN KEY (buyer_key) REFERENCES Buyer(buyer_key),
    FOREIGN KEY (item_key) REFERENCES Item(constructor_key)
);