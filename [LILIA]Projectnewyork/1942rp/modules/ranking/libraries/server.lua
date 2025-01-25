local lastInsurance = 0
function MODULE:EnsureData()
    for k, v in pairs(player.GetAll()) do
        if not v:getChar() then continue end
        local RankInfo = v:GetPlayerRankData()
        if not RankInfo then return end
        local RankToggled = v:getChar():getData("RankToggled", true)
        local TitleToggled = v:getChar():getData("TitleToggled", true)
        local charClass = v:getChar():getClass()
        local classData = lia.class.list[charClass]
        v:setNetVar("rank", RankInfo.Rank, player.GetAll(), false)
        v:setNetVar("rankID", RankInfo.ID, player.GetAll(), false)
        v:setNetVar("title", v:getChar():getData("title", ""), player.GetAll(), false)
        if classData and classData.name then v:setNetVar("branch", classData.name, player.GetAll(), false) end
        v:setNetVar("RankToggled", RankToggled, player.GetAll(), false)
        v:setNetVar("TitleToggled", TitleToggled, player.GetAll(), false)
    end

    lastInsurance = CurTime() + 5
end

function MODULE:Think()
    if lastInsurance <= CurTime() then self:EnsureData() end
end

function MODULE:OnTransferred(client)
    SetTier1RankDataForTargetedFaction(client)
end

function MODULE:OnPlayerSwitchClass(client, class, oldClass)
    SetTier1RankDataForTargetedFaction(client)
end

function Promote(ply, target)
    if not ply:CanPromote(target) then return end
    local currentRankData = ply:GetPlayerRankData()
    local targetRankData = target:GetPlayerRankData()
    if not currentRankData or not targetRankData then return end
    local newTier = targetRankData.Tier + 1
    local newRankData = FindRankByTierAndFaction(newTier, target:getChar():getClass())
    if not newRankData then return end
    if newRankData.Tier >= currentRankData.Tier then
        ply:notify("You can only promote players to ranks below your own.")
        return
    end

    ply:RegisterPromotion(target)
    target:SetPlayerRankData(newRankData)
    ply:notify("You just promoted " .. target:Nick())
    target:notify("You were just promoted!")
    hook.Run("PlayerLoadout", target)
end

function Demote(ply, target)
    if not ply:CanDemote(target) then return end
    local currentRankData = ply:GetPlayerRankData()
    local targetRankData = target:GetPlayerRankData()
    if not currentRankData or not targetRankData then return end
    local newTier = targetRankData.Tier - 1
    local newRankData = FindRankByTierAndFaction(newTier, target:getChar():getClass())
    if not newRankData then return end
    ply:RegisterDemotion(target)
    target:SetPlayerRankData(newRankData)
    hook.Run("PlayerLoadout", target)
end

function FindRankByTierAndFaction(tier, factionID)
    local factionRanks = lia.config.RankTable[factionID]
    if not factionRanks then return nil end
    local rankCount = 0
    for _ in pairs(factionRanks) do
        rankCount = rankCount + 1
    end

    print("Number of ranks in faction:", rankCount)
    if tier > rankCount then tier = rankCount end
    for _, rankData in pairs(factionRanks) do
        if rankData.Tier == tier then return rankData end
    end
    return nil
end

function SetTier1RankDataForTargetedFaction(target)
    local targetedFaction = target:getChar():getClass()
    if not target:IsPlayerInRankedFaction() then
        target:SetPlayerRankData({})
        target:setNetVar("rank", "", player.GetAll(), false)
        target:setNetVar("rankID", "", player.GetAll(), false)
        --        hook.Run("PlayerLoadout", target)
        return
    end

    local tier1RankData = GetTier1RankDataForTargetedFaction(targetedFaction)
    if tier1RankData then
        local model = tier1RankData.Model
        if model then
            if istable(model) then
                netstream.Start(target, "InitializePlayerModelUI", model)
            else
                target:getChar():setModel(model)
            end
        end

        target:SetPlayerRankData(tier1RankData)
        --    hook.Run("PlayerLoadout", target)
    end
end