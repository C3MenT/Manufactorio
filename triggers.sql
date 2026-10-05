-- TRIGGERS


-- Core Driver Trigger, used for the game loop
-- A frame is a single update of the cycle attribute
-- Any time we want the game to progress, we simply update the cycle attribute of the Global_State table
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
        
        -- Add to amount stored
        UPDATE Inventory
        SET amount_stored = amount_stored + amount_per_cycle
        WHERE item_name IN (SELECT item_name FROM Inventory);

    END;


CREATE TRIGGER IF NOT EXISTS new_extractor
    
