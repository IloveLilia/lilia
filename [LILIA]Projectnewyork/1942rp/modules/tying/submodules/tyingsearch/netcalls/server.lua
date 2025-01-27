﻿local MODULE = MODULE
util.AddNetworkString("RequestSearch")
util.AddNetworkString("ApproveID")
util.AddNetworkString("ApproveSearch")
netstream.Hook("searchExit", function(client) MODULE:stopSearching(client) end)
net.Receive("ApproveSearch", function(_, client)
    local requester = client.SearchRequested
    if not requester then return end
    if not requester.SearchRequested then return end
    local approveSearch = net.ReadBool()
    if not approveSearch then
        requester:notifyLocalized("searchDenied")
        requester.SearchRequested = nil
        client.SearchRequested = nil
        return
    end

    if requester:GetPos():DistToSqr(client:GetPos()) > 250 * 250 then return end
    MODULE:searchPlayer(requester, client, true)
    requester.SearchRequested = nil
    client.SearchRequested = nil
end)
