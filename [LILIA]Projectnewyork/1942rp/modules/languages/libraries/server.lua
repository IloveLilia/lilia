function MODULE:PlayerLoadedChar(client)
    for k, v in pairs(player.GetAll()) do
        local char = v:getChar()
        if char then
            local langData = char:getData("languages", {})
            char:setData("languages", langData, false, player.GetAll())
        end
    end
end

function MODULE:LiliaTablesLoaded()
    local ignore = function() end
    lia.db.query("ALTER TABLE lia_characters ADD COLUMN _languages TEXT"):catch(ignore)
end
