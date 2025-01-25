function MODULE:CanPlayerDropItem(client, item)
    if item.uniqueID == "citizenid" then return false end
end

function MODULE:CanPlayerInteractItem(client, action, item, data)
    if item:getOwner() ~= client and item.uniqueID == "citizenid" then return false end
end
