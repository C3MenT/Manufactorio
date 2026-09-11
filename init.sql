DROP TABLE IF EXISTS Biomes;
DROP TABLE IF EXISTS Resources;


CREATE TABLE if NOT EXISTS Biomes (
    id int PRIMARY KEY,
    name varchar(50) UNIQUE, -- User given name, can be NULL
    biome_type varchar(50) NOT NULL, -- Type of biome (e.g., forest, desert, tundra)
    resources array varchar(30), -- List of resources available in the biome
    size int NOT NULL -- Size value used in resource yield calculations and max number of structures that can be built in the biome
);

CREATE TABLE if NOT EXISTS Resources (
    id int PRIMARY KEY, -- Deposit ID for multiple instances of a resource in a biome
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome deposit is in)
    resource_type varchar(30) NOT NULL, -- Type of resource (e.g., wood, coal, etc.)
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
    extractor_type varchar(30) NOT NULL, -- Type of extractor (e.g., mining rig, water pump, etc.)
    efficiency int NOT NULL, -- Efficiency value used in resource yield calculations
    amount_stored float NOT NULL -- Amount of resource currently stored in the extractor
);

CREATE TABLE if NOT EXISTS Fabricators (
    id int PRIMARY KEY,
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome fabricator is in)
    fabricator_type varchar(30) NOT NULL, -- Type of fabricator (e.g., smelter, assembler, etc.)
    efficiency int NOT NULL, -- Efficiency value used in resource yield calculations
    amount_stored float NOT NULL DEFAULT 0, -- Amount of material or products currently stored in the fabricator (products will be natural numbers)
    product varchar(30) NOT NULL, -- Type of material or product being produced by the fabricator
    byproduct varchar(30) -- Type of byproduct being produced by the fabricator (can be NULL if no byproduct is produced)

);

-- JUNCTION TABLES 
CREATE TABLE if NOT EXISTS Resource_Locations (
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome resource is in)
    resource_id int NOT NULL REFERENCES Resources(id), -- Foreign key to Resources table (for resource in biome)
    PRIMARY KEY (biome_id, resource_id) -- Composite primary key to ensure uniqueness of biome-resource pairs
);

CREATE TABLE if NOT EXISTS Fabricator_Locations (
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome fabricator is in)
    fabricator_id int NOT NULL REFERENCES Fabricators(id), -- Foreign key to Fabricators table (for fabricator in biome)
    PRIMARY KEY (biome_id, fabricator_id) -- Composite primary key to ensure uniqueness of biome-fabricator pairs
);

CREATE TABLE if NOT EXISTS Extractor_Locations (
    biome_id int NOT NULL REFERENCES Biomes(id), -- Foreign key to Biomes table (for biome extractor is in)
    extractor_id int NOT NULL REFERENCES Extractors(id), -- Foreign key to Extractors table (for extractor in biome)
    PRIMARY KEY (biome_id, extractor_id) -- Composite primary key to ensure uniqueness of biome-extractor pairs
);

CREATE TABLE if NOT EXISTS Recipes (
    name varchar(30) PRIMARY KEY,
    fabricator_type varchar(30) NOT NULL, -- Type of fabricator (e.g., smelter, assembler, etc.)
    input_materials array varchar(30), -- List of input materials required for the recipe
    products array varchar(30), -- List of output products produced by the recipe
    byproducts array varchar(30) -- List of byproducts produced by the recipe (can be NULL if no byproducts are produced)
);