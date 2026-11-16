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