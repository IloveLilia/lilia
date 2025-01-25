util.AddNetworkString("InitiateSerialScratch")
util.AddNetworkString("FinishSerialScratch")
util.AddNetworkString("OpenComputer")
util.AddNetworkString("OwnerRequest")
net.Receive("FinishSerialScratch", function(len, ply)
    local weaponID = net.ReadUInt(32)
    local SerialBool = net.ReadBool()
    local character = ply:getChar()
    local inventory = character:getInv()
    local invItems = inventory:getItems()
    local targetWeapon = lia.item.instances[weaponID]
    for k, item in pairs(invItems) do
        if targetWeapon ~= item then return end
    end

    if SerialBool then
        scratchSuccess = true
    else
        scratchSuccess = false
    end

    if scratchSuccess then targetWeapon:setData("serialNumber_Scratched", scratchSuccess or nil) end
end)

net.Receive("OwnerRequest", function(len, ply)
    local SerialNumber = net.ReadUInt(32)
    local weaponOwnerList = {}
    if not SerialNumber then return end
    local searchChar = ply:getChar()
    local searchInv = searchChar:getInv()
    local searchItems = searchInv:getItems()
    returnSearchTrue = false
    for k, item in pairs(searchItems) do
        if item:getData("gunSerialNumber") then
            returnSearchTrue = true
            local weaponOwner = item:getData("serialNumberOwner")
            if not weaponOwner then return end
            table.insert(weaponOwnerList, weaponOwner)
        end
    end

    if returnSearchTrue then
        net.Start("OwnerRequest")
        net.WriteTable(weaponOwnerList)
        net.Send(ply)
    else
        ply:notify("You must have the weapon in your inventory to search the Serial number.")
    end
end)
