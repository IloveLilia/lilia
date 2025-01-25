local playerMeta = FindMetaTable("Player")
function playerMeta:IsPlayerInRankedFaction()
    for factionID, _ in pairs(lia.config.RankTable) do
        if self:getChar():getClass() == factionID then return true end
    end
    return false
end

function playerMeta:GetPlayerFactionRankTable()
    local factionID = self:getChar():getClass()
    if not self:IsPlayerInRankedFaction() then return end
    return lia.config.RankTable[factionID] or {}
end

function playerMeta:GetPlayerRankData()
    if not self:getChar() then return end
    if not self:IsPlayerInRankedFaction() then return end
    local factionRankTable = self:GetPlayerFactionRankTable()
    local rankInfo = self:getChar():getRank()
    if not rankInfo or not rankInfo.ID then
        for rank, data in pairs(factionRankTable) do
            if data.Tier == 1 then return data end
        end
    else
        for rank, data in pairs(factionRankTable) do
            if data.ID == rankInfo.ID then return data end
        end
    end
end

function playerMeta:IsTierHigherThan(target)
    local rankData = self:GetPlayerRankData()
    local targetRankData = target:GetPlayerRankData()
    if not rankData then return false end
    if not targetRankData then return false end
    print("Tiers", rankData.Tier, targetRankData.Tier)
    local result = rankData.Tier >= targetRankData.Tier
    return result
end

function playerMeta:CanTransfer(target)
    local rankData = self:GetPlayerRankData()
    if not rankData then
        self:notify("You don't have a rank.")
        return false
    end
    return rankData.IsOfficer
end

function playerMeta:CanDemote(target)
    local rankData = self:GetPlayerRankData()
    local targetRankData = target:GetPlayerRankData()
    return rankData.CanDemote and targetRankData > 1
end

function playerMeta:CanPromote(target)
    local rankData = self:GetPlayerRankData()
    local targetRankData = target:GetPlayerRankData()
    if not rankData then
        self:notify("You don't have a rank.")
        return false
    end

    if not targetRankData then
        self:notify(target:getChar():getName() .. " doesn't have a rank.")
        return false
    end

    if target:GetPromotionsLast24Hours() >= 2 and not target:getChar():getData("promotionCooldownReset", false) then
        self:notify(target:getChar():getName() .. " has been promoted twice in the last 24 hours. You can't promote them for now!")
        return false
    end

    local isHigherTier = self:IsTierHigherThan(target)
    local CanPromote = rankData.CanPromote
    local promotionCap = self:GetPromotionCap()
    local TargetTier = targetRankData.Tier
    if target:getChar():getClass() ~= self:getChar():getClass() then
        self:notify(target:getChar():getName() .. " is not in your faction.")
        return false
    end

    local maxTierInFaction = GetMaxTierInFaction(target)
    if maxTierInFaction == nil then
        self:notify("Unable to determine the maximum tier in the faction.")
        return false
    end

    if CanPromote and self:GetPromotionCount() >= promotionCap and not target:getChar():getData("promotionCooldownReset", false) then
        self:notify("You have reached your promotion limit of " .. promotionCap)
        return false
    end

    if not isHigherTier then
        self:notify("You can only promote to a tier below your own.")
        return false
    end

    if TargetTier + 1 > maxTierInFaction then
        self:notify(target:getChar():getName() .. " can't be promoted further.")
        return false
    end

    if target:getChar():getData("promotionCooldownReset", false) then target:getChar():setData("promotionCooldownReset", false) end
    local result = isHigherTier and CanPromote
    print("HT", isHigherTier, "CP", CanPromote)
    return result
end

function playerMeta:GetPromotionCount()
    local promotionData = self:getChar():getData("promotions", {})
    local currentTime = os.time()
    local count = 0
    for timestamp, data in pairs(promotionData) do
        if (currentTime - timestamp) <= 86400 then count = count + 1 end
    end
    return count
end

function playerMeta:GetPromotionCap()
    local rankData = self:GetPlayerRankData()
    if not rankData then return end
    if rankData.UnlimitedPromotions then return 9999999999999999 end
    return rankData.PromotionCap or 0
end
