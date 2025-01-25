PIM:AddOption("Enlist Target", {
    runServer = true,
    shouldShow = function(client, target)
        if not SERVER then return end
        local rankData = client:GetPlayerRankData()
        local rankedFaction = client:IsPlayerInRankedFaction()
        local targetChar = target:getChar()
        local clientChar = client:getChar()
        local clientClass = clientChar:getClass()
        return rankedFaction and rankData and targetChar and clientChar and rankData.IsOfficer and clientClass
    end,
    onRun = function(client, target)
        local tChar = target:getChar()
        local clientClass = client:getChar():getClass()
        if tChar then
            if target:Team() ~= client:Team() then
                local name = team.GetName(client:Team())
                local faction = lia.faction.teams[name]
                if not faction then
                    for _, v in pairs(lia.faction.indices) do
                        if lia.util.stringMatches(L(v.name, client), name) then
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
                    client:notify("You have transferred " .. target:Name() .. " to " .. faction.name)
                    target:notify("You have been transferred to " .. faction.name .. " by " .. client:Name())
                end
            end

            tChar:setClass(clientClass)
        end
    end
})
