ForgedItems = ForgedItems or {}
ForgedItems.List = ForgedItems.List or {}
function MODULE:SaveData()
    self:setData(ForgedItems.List)
end

function MODULE:LoadData()
    ForgedItems.List = self:getData() or {}
    for uniqueID, itemData in pairs(ForgedItems.List) do
        ForgedItems.RegisterCustomItem(uniqueID, itemData)
    end

    netstream.Start(nil, "ForgedItemsLoad", ForgedItems.List)
end

function MODULE:PlayerInitialSpawn(client)
    netstream.Start(client, "ForgedItemsLoad", ForgedItems.List)
end
