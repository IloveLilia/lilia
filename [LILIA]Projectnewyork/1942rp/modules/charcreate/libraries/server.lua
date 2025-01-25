local characterMeta = lia.meta.character
function characterMeta:ban(time)
    time = tonumber(time)
    if time then time = os.time() + math.max(math.ceil(time), 60) end
    self:setData("banned", time or true)
    self:save()
    -- self:kick()
    hook.Run("OnCharPermakilled", self, time or nil)
end

function MODULE:OnCharPermakilled(char)
    net.Start("openCharMenu")
    net.Send(char:getPlayer())
    char:kick()
end

util.AddNetworkString("openCharMenu")
