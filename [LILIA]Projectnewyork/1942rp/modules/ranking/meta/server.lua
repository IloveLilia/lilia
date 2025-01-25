local MODULE = MODULE
local playerMeta = FindMetaTable("Player")
function playerMeta:SetPlayerRankData(newData)
    local char = self:getChar()
    if not char then return end
    char:setRank(newData)
    if RankInfo then
        if RankInfo.Rank then self:setNetVar("rank", RankInfo.Rank, player.GetAll(), false) end
        if RankInfo.ID then self:setNetVar("rankID", RankInfo.ID, player.GetAll(), false) end
    end

    MODULE:EnsureData()
end

function playerMeta:RegisterPromotion(playerPromoted)
    local rankData = playerPromoted:GetPlayerRankData()
    if not rankData then return false end
    if playerPromoted:GetPromotionsLast24Hours() >= 2 then return false end
    local promotionData = self:getChar():getData("promotions", {})
    local timestamp = os.time()
    promotionData[timestamp] = {
        PlayerName = playerPromoted:Nick(),
        PlayerRank = rankData.ID,
        PromotedAt = os.date("%c", timestamp)
    }

    local whenPromoted = playerPromoted:getChar():getData("selfpromotions", {})
    whenPromoted[timestamp] = {
        PromotedAt = os.date("%c", timestamp)
    }

    self:getChar():setData("promotions", promotionData)
    playerPromoted:getChar():setData("selfpromotions", whenPromoted)
    return true
end

function playerMeta:GetPromotionsLast24Hours()
    local promotionData = self:getChar():getData("selfpromotions", {})
    local currentTime = os.time()
    local promotionsInLast24Hours = 0
    for timestamp, data in pairs(promotionData) do
        if currentTime - timestamp <= 24 * 60 * 60 then promotionsInLast24Hours = promotionsInLast24Hours + 1 end
    end
    return promotionsInLast24Hours
end

function playerMeta:isRankingBlacklisted()
    return self:getLiliaData("rankingBlacklisted", false)
end

function playerMeta:RegisterDemotion(playerDemoted)
    local rankData = playerDemoted:GetPlayerRankData()
    if not rankData then return end
    local demotionData = self:getChar():getData("demotions", {})
    local timestamp = os.time()
    demotionData[timestamp] = {
        PlayerName = playerDemoted:Nick(),
        PlayerRank = rankData.ID,
        DemotedAt = os.date("%c", timestamp)
    }

    self:getChar():setData("demotions", demotionData)
end
