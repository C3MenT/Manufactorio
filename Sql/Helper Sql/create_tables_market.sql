/*
Just the tables involved with the Market system
*/


DROP TABLE IF EXISTS Buyer;
CREATE TABLE IF NOT EXISTS Buyer(
    buyer_key int PRIMARY KEY,
    name varchar(30) NOT NULL,
    wealth int NOT NULL -- A value (1-10) that guages how likely a buyer is to pay more than market price for an item from each buyer
);

DROP TABLE IF EXISTS Manufacturer;
CREATE TABLE IF NOT EXISTS Manufacturer(
    manufacturer_key int PRIMARY KEY, -- unique identitfier
    name varchar(30) NOT NULL UNIQUE, -- name of manufacturer
    -- Repuatation is a value (starting at 1) representing the general quality of the manufacturer's supplied items and their legitamacy. 
    -- If this number is high, wealthier buyers buy more items from them and generally more buyers have transactions in the market relation
    -- with the manufacturer that are worth more than each item's market price. The complete inverse is also true.
    reputation int NOT NULL UNIQUE, 
    money double DEFAULT 0.0,
    income_per_cycle double DEFAULT 0.0
);

DROP TABLE IF EXISTS Item;
CREATE TABLE IF NOT EXISTS Item(
    item_id varchar(30) PRIMARY KEY,
    name varchar(30) NOT NULL UNIQUE,
    state varchar(8), -- solid, liquid, gas, plasma
    description varchar(200),
    tier int, -- 0(Raw Resource)-5(Final Advanced Products)
    market_value NOT NULL, -- Base Price that a Buyer would pay for this item
    quantity float DEFAULT 0.0 -- stored quantity of this item
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