local MODULE = MODULE
netstream.Hook("SendVote", function(client, topic, vote, ent)
    local steamID = client:SteamID()
    if ent:GetClass() ~= "legislativevotingbox" or not (table.HasValue(MODULE.LegislativeBoxSteamIDs, client:SteamID()) or client:IsSuperAdmin()) then return end
    MODULE.LegislativeBoxVotes[topic] = MODULE.LegislativeBoxVotes[topic] or {
        Abstain = 0,
        Aye = 0,
        Nye = 0
    }

    MODULE.LegislativeBoxVotes[topic][vote] = (MODULE.LegislativeBoxVotes[topic][vote] or 0) + 1
    print(steamID .. " voted for " .. topic .. ": " .. vote)
end)

netstream.Hook("RegisterFinaledVoting", function(client) table.insert(MODULE.LegislativeBoxSteamIDVoted, client:SteamID()) end)
netstream.Hook("LegRegisterTopic", function(client, topic)
    table.insert(MODULE.LegislativeBoxTopics, topic)
    client:ChatPrint("Added Topic " .. topic .. " to the legislative voting!")
end)

netstream.Hook("LegRegisterSteamID", function(client, steamid)
    if not MODULE.LegislativeBoxSteamIDs then
        print("LegislativeBoxSteamIDs table not initialized. Initializing now.")
        MODULE.LegislativeBoxSteamIDs = {}
    end

    table.insert(MODULE.LegislativeBoxSteamIDs, steamid)
    MODULE:SaveData()
    client:ChatPrint("Given Permission to SteamID " .. steamid .. " to vote on the legislative voting!")
end)

netstream.Hook("LegUnRegisterSteamID", function(client, steamid)
    for key, steamID in pairs(MODULE.LegislativeBoxSteamIDs) do
        if steamID == steamid then
            table.remove(MODULE.LegislativeBoxSteamIDs, key)
            client:ChatPrint("Revoked Permission to SteamID " .. steamid .. " to vote on the legislative voting!")
            break
        end
    end
end)
