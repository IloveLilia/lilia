local MODULE = MODULE
function MODULE:PlayerLoadedChar(ply, char, lastChar)
    local newCharacterID = char:getID()
    local oldCharacterID = lastChar and lastChar:getID() or 0
    if oldCharacterID ~= newCharacterID then ply:SetModelScale(1.0, 1) end
    for characteristic, v in pairs(char:getData("charCharacteristics", {})) do
        for _, var in pairs(lia.config.HeightEquivalentTable) do
            if characteristic == "Height" and v == var[1] then ply:SetModelScale(ply:GetModelScale() * var[2], 1) end
        end
    end
end

function MODULE:CanPlayerDropItem(client, item)
    if item.uniqueID == "citizenid" then return false end
end

function MODULE:CanPlayerInteractItem(client, action, item, data)
    if item:getOwner() ~= client and item.uniqueID == "citizenid" then return false end
end

resource.AddFile("materials/documents/cover.png")
resource.AddFile("materials/documents/infos.png")
