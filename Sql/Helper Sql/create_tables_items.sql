/*
Just the tables involved with the Crafting and Item system
*/

DROP TABLE IF EXISTS Item;
CREATE TABLE IF NOT EXISTS Item(
    item_id varchar(30) PRIMARY KEY,
    name varchar(30) NOT NULL UNIQUE,
    state varchar(8), -- solid, liquid, gas, plasma
    tier int, -- What tier of item this is, 0(Raw resource)-5(Advanced Products)
    description varchar(200),
    quantity float DEFAULT 0.0
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