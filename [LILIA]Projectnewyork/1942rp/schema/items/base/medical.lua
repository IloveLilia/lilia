ITEM.name = "Aid Items"
ITEM.desc = "Heals you bruh."
ITEM.model = "models/weapons/w_package.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.Ticks = 0
ITEM.TimePerTick = 0
ITEM.HealPerTick = 0
ITEM.functions.use = {
    name = "Heal",
    onRun = function(item)
        local client = item.player
        timer.Create(client:SteamID() .. "_healing_" .. item.uniqueID, item.TimePerTick, item.Ticks, function()
            if (client:Health() + item.HealPerTick) >= client:GetMaxHealth() then
                client:SetHealth(client:GetMaxHealth())
            else
                client:SetHealth(client:Health() + item.HealPerTick)
            end
        end)
    end
}

ITEM.functions.target = {
    name = "Target Heal",
    onRun = function(item)
        local client = item.player
        local target = client:GetEyeTrace().Entity
        if not (IsValid(target) and target:IsPlayer()) then
            client:notify("Target not valid! You must be looking at it!")
            return
        else
            timer.Create(target:SteamID() .. "_healing_" .. item.uniqueID, item.TimePerTick, item.Ticks, function()
                if (target:Health() + item.HealPerTick) >= target:GetMaxHealth() then
                    target:SetHealth(target:GetMaxHealth())
                else
                    target:SetHealth(target:Health() + item.HealPerTick)
                end
            end)
        end
    end
}
