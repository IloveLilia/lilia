function SCHEMA:LiliaTablesLoaded()
    local ignore = function() end
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _skin TEXT"):catch(ignore)
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _descgenerator TEXT"):catch(ignore)
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _traits TEXT"):catch(ignore)
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _languages TEXT"):catch(ignore)
end

function SCHEMA:PlayerEnteredVehicle(client)
    if client:getChar():getInv():hasItem("drivingpermit") then return true end
    return false
end

function SCHEMA:WalletLimit(client)
    return 5000
end
