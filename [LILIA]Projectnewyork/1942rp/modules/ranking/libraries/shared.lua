function GetMaxTierInFaction(target)
    local factionRankTable = target:GetPlayerFactionRankTable()
    local maxTier = 0
    for _, data in pairs(factionRankTable) do
        if data.Tier > maxTier then maxTier = data.Tier end
    end
    return maxTier
end

function PrintDemotions(client, target)
    local demotionData = target:getChar():getData("demotions", {})
    if table.IsEmpty(demotionData) then
        target:ChatPrint("This player has no recorded demotions.")
        return
    end

    target:ChatPrint("Demotion History:")
    for timestamp, data in pairs(demotionData) do
        local demotionTime = data.DemotedAt or "Unknown Time"
        local playerName = data.PlayerName or "Unknown Player"
        local playerRank = data.PlayerRank or "Unknown Rank"
        target:ChatPrint(string.format("%s was demoted to %s at %s.", playerName, playerRank, demotionTime))
    end
end

function PrintPromotions(client, target)
    local promotionData = target:getChar():getData("promotions", {})
    if table.IsEmpty(promotionData) then
        target:ChatPrint("This player has no recorded promotions.")
        return
    end

    target:ChatPrint("Promotion History:")
    for timestamp, data in pairs(promotionData) do
        local promotionTime = data.PromotedAt or "Unknown Time"
        local playerName = data.PlayerName or "Unknown Player"
        local playerRank = data.PlayerRank or "Unknown Rank"
        target:ChatPrint(string.format("%s was promoted to %s at %s.", playerName, playerRank, promotionTime))
    end
end

function GetTier1RankDataForTargetedFaction(targetedFaction)
    if not targetedFaction or not lia.config.RankTable[targetedFaction] then return nil end
    for rankID, rankData in pairs(lia.config.RankTable[targetedFaction]) do
        if rankData.Tier == 1 then return rankData end
    end
    return nil
end

lia.char.registerVar("rank", {
    field = "_rank",
    fieldType = "text",
    default = {},
    index = 2211,
    noDisplay = true,
    shouldDisplay = function(panel) return false end
})
