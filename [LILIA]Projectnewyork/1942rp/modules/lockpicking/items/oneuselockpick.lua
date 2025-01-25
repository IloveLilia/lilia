ITEM.name = "One Use Lockpick"
ITEM.desc = "A device used to bypass door locks."
ITEM.model = "models/weapons/w_crowbar.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.functions.Use = {
    onRun = function(item)
        if item.beingUsed then return false end
        local client = item.player
        local target = client:GetEyeTrace().Entity
        if not client:getNetVar("restricted") and IsValid(target) or target:IsVehicle() and target:isLocked() then
            item.beingUsed = true
            local timerID = "Lockpicksnd" .. client:SteamID()
            timer.Create(timerID, 1, 15, function()
                if not client or not client:getNetVar("isPicking") then
                    timer.Remove(timerID)
                else
                    local snd = {1, 3, 4}
                    client:EmitSound("weapons/357/357_reload" .. tostring(snd[math.random(1, #snd)]) .. ".wav", 75, 100)
                end
            end)

            client:setNetVar("isPicking", true)
            client:setAction("Lockpicking", 15)
            client:doStaredAction(target, function()
                item:remove()
                client:EmitSound("doors/door_latch3.wav")
                target:Fire("unlock")
                if target:IsVehicle() and target.IsSimfphyscar then target.IsLocked = false end
                client:setNetVar("isPicking")
                timer.Remove(timerID)
                return true
            end, 15, function()
                client:setNetVar("isPicking")
                client:setAction()
                item.beingUsed = false
                timer.Remove(timerID)
            end)
        else
            item.player:notifyLocalized("Target is already unlocked.")
        end
        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) end
}

function ITEM:OnCanBeTransfered(inventory, newInventory)
    return not self.beingUsed
end
