lia.command.add("ItemMaker", {
    adminOnly = true,
    privilege = "Management - Use Item Maker",
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "ItemMakerGUI") end
})

lia.command.add("ItemMakerlist", {
    adminOnly = true,
    privilege = "Management - Use Item Maker",
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "ItemMakerList", ForgedItems.List) end
})

lia.command.add("ItemMakerdetails", {
    adminOnly = true,
    privilege = "Management - Use Item Maker",
    syntax = "<uniqueID>",
    onRun = function(client, arguments)
        local uniqueID = arguments[1]
        if not uniqueID or not ForgedItems.List[uniqueID] then
            client:notify("Unique ID is invalid. Consider using /ItemMakerlist")
            return
        end

        netstream.Start(client, "ItemMakerDetails", uniqueID, ForgedItems.List[uniqueID])
    end
})

lia.command.add("ItemMakerdelete", {
    adminOnly = true,
    privilege = "Management - Use Item Maker",
    syntax = "<uniqueID>",
    onRun = function(client, arguments)
        local uniqueID = arguments[1]
        if not uniqueID then
            client:notify("You have to specify a unique ID")
            return
        end

        if not ForgedItems.List[uniqueID] then
            client:notify("That is not an item-forge generated item ID.")
            return
        end

        ForgedItems.List[uniqueID] = nil
        local count = 0
        for k, v in pairs(lia.item.instances) do
            if v and istable(v) and v.uniqueID and v.uniqueID == uniqueID then
                count = count + 1
                v:remove()
            end
        end

        lia.item.list[uniqueID] = nil
        client:notify("Removed " .. count .. " instances of " .. uniqueID .. " in the world & removed item type!")
        netstream.Start(nil, "ItemMakerDelete", uniqueID)
    end
})
