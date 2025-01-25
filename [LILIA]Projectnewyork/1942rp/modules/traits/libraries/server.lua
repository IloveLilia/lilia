function MODULE:PlayerLoadedChar(client)
    local character = client:getChar()
    local inv = character:getInv()
    timer.Simple(0.5, function()
        if self:hasTrait(client, "The Cook") and not character:getData("WeedReceived", false) then
            character:setData("WeedReceived", true)
            inv:add("weedseeds")
        end

        if self:hasTrait(client, "Spokesperson") and not character:getData("MeinKampfReceived", false) then
            character:setData("MeinKampfReceived", true)
            inv:add("meinkampf")
        end

        if self:hasTrait(client, "Hardy") then
            client:SetMaxHealth(150)
            client:SetHealth(150)
        end

        if self:hasTrait(client, "Burglar") and not character:getData("LockpickReceived", false) then
            character:setData("LockpickReceived", true)
            inv:add("oneuselockpick")
        end

        if self:hasTrait(client, "Craftsman") and not character:getData("CraftingReceived", false) then
            character:setData("CraftingReceived", true)
            inv:add("axe")
            inv:add("pickaxe")
        end

        if self:hasTrait(client, "The Businessman") then
            if not character:getData("BriefCaseReceived", false) then
                inv:add("briefcase")
                character:setData("BriefCaseReceived", true)
            end

            character:giveMoney(500)
        end

        if self:hasTrait(client, "The Sportsman") then
            client:SetWalkSpeed(lia.config.WalkSpeed * 1.25)
            client:SetRunSpeed(lia.config.RunSpeed * 1.25)
        end

        for k, v in pairs(player.GetAll()) do
            if v:getChar() then v:getChar():setData("traits", v:getChar():getData("traits", {}), false, player.GetAll()) end
        end
    end)
end

function MODULE:LiliaTablesLoaded()
    local ignore = function() end
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _languages TEXT"):catch(ignore)
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _traits TEXT"):catch(ignore)
end
