netstream.Hook("SetRankInformation", function(_, target, RankInfo)
    local model = RankInfo.Model
    if model then
        if istable(model) then
            netstream.Start(target, "InitializePlayerModelUI", model)
        else
            target:getChar():setModel(model)
        end
    end

    target:SetPlayerRankData(RankInfo)
 //   hook.Run("PlayerLoadout", target)
end)

netstream.Hook("setModelRanked", function(client, model)
    local RankData = client:GetPlayerRankData()
    RankData.Model = model
    client:SetPlayerRankData(RankData)
    client:getChar():setModel(model)
    hook.Run("PlayerLoadout", client)
end)

net.Receive("ApproveTransfer", function(len, client)
    local officer = client.TransferRequested
    local clientRankData = client:GetPlayerRankData()
    local officerRankData = officer:GetPlayerRankData()
    local approveTransfer = net.ReadBool()
    if not IsValid(officer) or not IsValid(client) then
        print("Transfer cannot be processed. Either officer or client is invalid.")
        return
    end

    if approveTransfer then
        if officer:CanTransfer(client) then
            if clientRankData and officerRankData then
                local minPaygrade = math.max(clientRankData.Paygrade - 3, 1)
                local officerPaygrade = officerRankData.Paygrade
                local rankTable = lia.config.RankTable[officer:getChar():getClass()]
                local options = {}
                local hasExactPaygrade = false
                for rank, data in pairs(rankTable) do
                    if data.Paygrade == clientRankData.Paygrade then
                        hasExactPaygrade = true
                        table.insert(options, rank)
                    end
                end

                if not hasExactPaygrade then
                    for rank, data in pairs(rankTable) do
                        if not data.Paygrade then continue end
                        if data.Paygrade > clientRankData.Paygrade then continue end
                        if data.Paygrade < minPaygrade then continue end
                        table.insert(options, rank)
                    end
                end

                local validOptions = {}
                for _, rank in ipairs(options) do
                    local data = rankTable[rank]
                    if data.Paygrade < officerPaygrade then table.insert(validOptions, rank) end
                end

                if #validOptions == 0 then
                    officer:ChatPrint("No valid ranks available within your paygrade.")
                    return
                end

                officer:requestDropdown("Choose Rank", "Select the new rank for the player:", validOptions, function(selectedOption)
                    local newRankData = rankTable[selectedOption]
                    if not newRankData then
                        officer:ChatPrint("Invalid rank selected.")
                        return
                    end

                    local name = team.GetName(officer:Team())
                    local faction = lia.faction.teams[name]
                    if not faction then
                        for _, v in pairs(lia.faction.indices) do
                            if lia.util.stringMatches(v.name, name) then
                                faction = v
                                break
                            end
                        end
                    end

                    if faction then
                        client:getChar().vars.faction = faction.uniqueID
                        client:getChar():setFaction(faction.index)
                        client:getChar():joinClass(officer:getChar():getClass(), true)
                        client:SetPlayerRankData(newRankData)
                        hook.Run("PlayerLoadout", client)
                    else
                        officer:ChatPrint("Faction not found.")
                    end
                end)
            else
                officer:ChatPrint("This player has no Paygrade!")
            end
        else
            officer:ChatPrint("You can't transfer this player!")
        end
    else
        officer:ChatPrint("The player denied your transfer request.")
    end

    officer.TransferRequested = nil
    client.TransferRequested = nil
end)

net.Receive("ApproveEnlist", function(len, target)
    local officer = target.EnlistRequested
    local ApproveEnlist = net.ReadBool()
    if not IsValid(officer) or not IsValid(target) then return end
    if ApproveEnlist then
        local rankData = officer:GetPlayerRankData()
        local rankedFaction = officer:IsPlayerInRankedFaction()
        local targetChar = target:getChar()
        local clientChar = officer:getChar()
        local clientClass = clientChar:getClass()
        if IsValid(target) and target:IsPlayer() and targetChar and rankedFaction and rankData and clientChar and rankData.IsOfficer and clientClass and target:Team() == FACTION_CITIZEN then
            if officer:GetPos():DistToSqr(target:GetPos()) <= 256 ^ 2 then
                if target:Team() ~= officer:Team() then
                    local name = team.GetName(officer:Team())
                    local faction = lia.faction.teams[name]
                    if not faction then
                        for _, v in pairs(lia.faction.indices) do
                            if lia.util.stringMatches(L(v.name, officer), name) then
                                faction = v
                                break
                            end
                        end
                    end

                    if faction then
                        target:getChar().vars.faction = faction.uniqueID
                        target:getChar():setFaction(faction.index)
                        hook.Run("OnTransferred", target)
                        if faction.onTransfered then faction:onTransfered(target) end
                        officer:notify("You have transferred " .. target:Name() .. " to " .. faction.name)
                        target:notify("You have been transferred to " .. faction.name .. " by " .. officer:Name())
                    end
                end

                target:getChar():setClass(clientClass)
            else
                officer:notify("The target is too far away.")
            end
        else
            officer:notify("Invalid target or conditions not met.")
        end
    else
        officer:ChatPrint("The player denied your transfer request.")
    end

    officer.EnlistRequested = nil
    target.EnlistRequested = nil
end)

util.AddNetworkString("RequestTransfer")
util.AddNetworkString("ApproveTransfer")
util.AddNetworkString("RequestEnlist")
util.AddNetworkString("ApproveEnlist")
