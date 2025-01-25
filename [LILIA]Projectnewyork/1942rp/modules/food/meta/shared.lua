local playerMeta = FindMetaTable("Player")
function playerMeta:getHunger()
    return self:getNetVar("hunger", 100)
end

function playerMeta:addHunger(amount)
    local currentThrist = self:getNetVar("thrist", 100)
    local newThrist = math.min(currentThrist + amount, 100)
    self:setNetVar("hunger", newThrist)
end

function playerMeta:getThrist()
    return self:getNetVar("thrist", 100)
end

function playerMeta:addThrist(amount)
    local currentThrist = self:getNetVar("thrist", 100)
    local newThrist = math.min(currentThrist + amount, 100)
    self:setNetVar("thrist", newThrist)
end
