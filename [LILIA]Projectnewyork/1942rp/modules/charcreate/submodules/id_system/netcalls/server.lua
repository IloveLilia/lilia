util.AddNetworkString("IDInvInteraction")
netstream.Hook("showIDToPlayer", function(ply, target) netstream.Start(ply, "OpenID") end)
net.Receive("ApproveID", function(len, ply)
    local requester = ply.IDRequested
    if not requester then return end
    if not requester.IDRequested then return end
    local approveIDView = net.ReadBool()
    if not approveIDView then
        requester:notify("Player denied your request to view their inventory.")
        requester.IDRequested = nil
        ply.IDRequested = nil
        return
    end

    if requester:GetPos():DistToSqr(ply:GetPos()) > 250 * 250 then return end
    netstream.Start(requester, "openUpID", ply)
    requester.IDRequested = nil
    ply.IDRequested = nil
end)

netstream.Hook("setCharCharacteristics", function(ply, vals, setOnChar)
    if setOnChar then
        ply:getChar():setData("charCharacteristics", vals)
    elseif setOnChar == nil or not setOnChar then
        ply:setNetVar("characsToBeSet", vals)
    end
end)

netstream.Hook("getPlayerCharacs", function(ply, target)
    local data = target:getChar():getData("charCharacteristics", {})
    netstream.Start(ply, "returnPlayerCharacs", data)
end)

net.Receive("ApproveID", function(len, ply)
    local requester = ply.IDRequested
    if not requester then return end
    if not requester.IDRequested then return end
    local approveIDView = net.ReadBool()
    if not approveIDView then
        requester:notify("Player denied your request to view their inventory.")
        requester.IDRequested = nil
        ply.IDRequested = nil
        return
    end

    if requester:GetPos():DistToSqr(ply:GetPos()) > 250 * 250 then return end
    netstream.Start(requester, "OpenID", ply)
    requester:getChar():recognize(ply:getChar():getID())
    requester.IDRequested = nil
    ply.IDRequested = nil
end)

net.Receive("IDInvInteraction", function(len, client)
    local target = client:GetTracedEntity()
    local isSelf = net.ReadBool()
    if isSelf then
        netstream.Start(client, "OpenID", client)
    else
        if IsValid(target) and target:IsPlayer() then
            netstream.Start(target, "OpenID", client)
        else
            client:notify("Invalid Target!")
        end
    end
end)
