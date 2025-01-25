ForgedItems = ForgedItems or {}
ForgedItems.List = ForgedItems.List or {}
netstream.Hook("ItemMakerGUI", function(client, id, itemData)
    if not id or not itemData then return end
    if not itemData.name or not itemData.desc then return end
    ForgedItems.List[id] = itemData
    ForgedItems.RegisterCustomItem(id, itemData)
    netstream.Start(nil, "ForgedItemsLoadSingle", id, itemData)
    client:notify("You've successfully registered '" .. id .. "'. It can now be spawned in and used as an item!")
end)

netstream.Hook("ItemMakerDelete", function(uniqueID)
    lia.item.list[uniqueID] = nil
    ForgedItems.List[uniqueID] = nil
end)
