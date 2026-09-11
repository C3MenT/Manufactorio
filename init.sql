DROP TABLE IF EXISTS Biomes;
DROP TABLE IF EXISTS Resources;
DROP TABLE IF EXISTS Materials;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Extractors;
DROP TABLE IF EXISTS Fabricators;
DROP TABLE IF EXISTS Resource_Locations;
DROP TABLE IF EXISTS Fabricator_Locations;
DROP TABLE IF EXISTS Extractor_Locations;
DROP TABLE IF EXISTS Recipes;


CREATE TABLE if NOT EXISTS Biomes (
    id int PRIMARY KEY,
    name varchar(50) UNIQUE, -- User given name, can be NULL
    biome_type varchar(50) NOT NULL, -- Type of biome (e.g., forest, desert, tundra)
    size int NOT NULL -- Size value used in resource yield calculations and max number of structures that can be built in the biome
);

CREATE TABLE if NOT EXISTS Resources (
    id int PRIMARY KEY, -- Deposit ID for multiple instances of a resource in a biome
    name varchar(30) NOT NULL, -- Name of resource (e.g., wood, coal, etc.)
    abundance int NOT NULL, -- Abundance value used in resource yield calculations
    purity int NOT NULL -- Purity value used in resource yield calculations
);

-- Materials table considers only one instance of each material type per tuple
-- Since Materials are simply produced and accumulated, they need no partial information 
-- on their creation efficiency or source (it's contained in other relations).
CREATE TABLE if NOT EXISTS Materials (
    name varchar(30) PRIMARY KEY, -- Name of the material being produced by the fabricator (steel, plastic, etc.)
    amount_stored float NOT NULL DEFAULT 0 -- Amount of material currently stored in total (across all fabricators)
);

-- Products table also considers only one instance of each product type per tuple
-- Since Products are simply produced and accumulated, they need no partial information either
CREATE TABLE if NOT EXISTS Products (
    name varchar(30) PRIMARY KEY, -- Name of the product being produced by the fabricator (steel beam, plastic sheet, etc.)
    amount_stored float NOT NULL DEFAULT 0 -- Amount of product currently stored in total (across all fabricators)
);

CREATE TABLE if NOT EXISTS Extractors (
    id int PRIMARY KEY,
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome extractor is in)
    resource_id int NOT NULL REFERENCES Resources(id), -- Foreign key to Resources table (for resource extractor is extracting)
    type varchar(30) NOT NULL, -- Type of extractor (e.g., mining rig, water pump, etc.)
    efficiency float NOT NULL DEFAULT 1.0, -- Efficiency value used in resource yield calculations
    amount_stored float NOT NULL DEFAULT 0 -- Amount of resource currently stored in the extractor
);

CREATE TABLE if NOT EXISTS Fabricators (
    id int PRIMARY KEY,
    type varchar(30) NOT NULL, -- Type of fabricator (e.g., smelter, assembler, etc.)
    efficiency float NOT NULL DEFAULT 1.0, -- Efficiency value used in resource yield calculations
    amount_stored float NOT NULL DEFAULT 0, -- Amount of material or products currently stored in the fabricator (products will be natural numbers)
    product varchar(30) NOT NULL, -- Name of material or product being produced by the fabricator
    byproduct varchar(30) -- Name of byproduct being produced by the fabricator (can be NULL if no byproduct is produced)

);

-- JUNCTION TABLES

-- Resources:Biomes (Many-to-Many)
CREATE TABLE if NOT EXISTS Resource_Locations (
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome resource is in)
    resource_id int NOT NULL REFERENCES Resources(id), -- Foreign key to Resources table (for resource in biome)
    PRIMARY KEY (biome_id, resource_id) -- Composite primary key to ensure uniqueness of biome-resource pairs
);

-- Fabricators:Biomes (Many-to-Many)
CREATE TABLE if NOT EXISTS Fabricator_Locations (
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome fabricator is in)
    fabricator_id int NOT NULL REFERENCES Fabricators(id), -- Foreign key to Fabricators table (for fabricator in biome)
    PRIMARY KEY (biome_id, fabricator_id) -- Composite primary key to ensure uniqueness of biome-fabricator pairs
);

-- Extractors:Biomes (Many-to-Many)
CREATE TABLE if NOT EXISTS Extractor_Locations (
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome extractor is in)
    extractor_id int NOT NULL REFERENCES Extractors(id), -- Foreign key to Extractors table (for extractor in biome)
    PRIMARY KEY (biome_id, extractor_id) -- Composite primary key to ensure uniqueness of biome-extractor pairs
);

-- Resources/Materials:Products (and Byproducts) (Many-to-Many)
CREATE TABLE if NOT EXISTS Recipes (
    name varchar(30) PRIMARY KEY,
    type varchar(30) NOT NULL, -- Type of product being produced by the recipe (e.g., material, product, etc.)
    fabricator_type varchar(30) NOT NULL, -- Type of fabricator (e.g., smelter, assembler, etc.)
    input_material varchar(30) NOT NULL, -- An input material required for the output
    product varchar(30) NOT NULL, -- An output product produced by the recipe
    byproduct varchar(30), -- A byproduct produced by the recipe (can be NULL if no byproducts are produced)
    UNIQUE (input_material, product, byproduct) -- Ensure uniqueness of recipe combinations
);


CREATE TABLE if NOT EXISTS Inventory (
    item_name varchar(30) PRIMARY KEY,
    amount_stored float NOT NULL DEFAULT 0 CHECK (amount_stored >= 0),-- Amount of item currently stored in total (across all fabricators and extractors)
    amount_per_cycle float NOT NULL DEFAULT 0 -- Amount of item produced or consumed per cycle (can be negative for dominant consumption)
);


CREATE TABLE if NOT EXISTS Global_State (
    id int PRIMARY KEY CHECK (id = 1), -- Ensure only one row exists in the table
    cycle int NOT NULL DEFAULT 0 -- Current cycle number, starting from 0
);


-- TRIGGERS


-- Core Driver Trigger, used for the game loop
-- A frame is a single update of the cycle attribute
CREATE TRIGGER IF NOT EXISTS new_cycle
    AFTER UPDATE OF cycle ON Global_State
    BEGIN
        
        -- Update Extractors
        UPDATE Extractors
        SET amount_stored = amount_stored + (
            efficiency * (
                SELECT abundance 
                FROM Resources 
                WHERE Resources.id = Extractors.resource_id) * (
                    SELECT purity 
                    FROM Resources 
                    WHERE Resources.id = Extractors.resource_id)
            );
        
        -- Update Fabricators
        UPDATE Fabricators
        SET amount_stored = amount_stored + (
            efficiency * (
                SELECT abundance 
                FROM Resources 
                WHERE Resources.id = Fabricators.resource_id) * (
                    SELECT purity 
                    FROM Resources 
                    WHERE Resources.id = Fabricators.resource_id)
            );
        
        

        -- Update global inventory
        UPDATE Inventory
        -- Sum of all amounts produced and consumed per cycle for each item in the inventory
        -- Or specifically,
        -- Term 1: Sum of all amounts produced by extractors for each resource in the inventory
        SET amount_per_cycle = (
            SELECT SUM(amount_stored) 
            FROM Extractors 
            WHERE Extractors.resource_id = (
                SELECT id 
                FROM Resources 
                WHERE Resources.name = Inventory.item_name)
        -- Term 2: Sum of all amounts produced by fabricators for each product in the inventory
        ) + (
            SELECT SUM(amount_stored) 
            FROM Fabricators 
            WHERE Fabricators.product = Inventory.item_name
        -- Term 3: Sum of all amounts consumed by recipes for each input material in the inventory
        ) - (
            SELECT SUM(amount_stored) 
            FROM Recipes 
            WHERE Recipes.input_material = Inventory.item_name
        );
        SET amount_stored = amount_stored + amount_per_cycle
        WHERE item_name IN (SELECT item_name FROM Inventory);

    END;

