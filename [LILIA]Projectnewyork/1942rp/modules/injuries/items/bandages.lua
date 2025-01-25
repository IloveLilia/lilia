ITEM.name = "Bandages"
ITEM.desc = "This is a Bandage. Used to stop bleeding."
ITEM.category = "Medical"
ITEM.model = "models/Gibs/wood_gib01e.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.functions.use = {
    name = "Use",
    tip = "equipTip",
    icon = "icon16/tick.png",
    onRun = function(item)
        local client = item.player
        Injuries:RemoveBleeding(client)
        client:SetNWBool("BleedingBandaged", true)
        client:ChatPrint("You have successfully stopped your bleeding!")
        return true
    end,
    onCanRun = function(item) return not IsValid(item.entity) end
}

ITEM.functions.usef = {
    name = "Use Forward",
    tip = "useTip",
    icon = "icon16/arrow_up.png",
    onRun = function(item)
        local client = item.player
        local trace = client:GetEyeTraceNoCursor()
        local target = trace.Entity
        if target and target:IsValid() and target:IsPlayer() and target:Alive() then
            Injuries:RemoveBleeding(target)
            target:SetNWBool("BleedingBandaged", true)
            client:ChatPrint("You have successfully stopped this player's bleeding!")
            return true
        end
        return false
    end,
    onCanRun = function(item)
        local client = item.player
        local trace = client:GetEyeTraceNoCursor()
        local target = trace.Entity
        return not IsValid(item.entity) and IsValid(target) and target:IsPlayer() and target:getChar()
    end
}
