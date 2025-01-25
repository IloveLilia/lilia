ITEM.name = "Splint"
ITEM.desc = "This is a splint. Used to Patch Broken Legs."
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
        if client:getChar():setData("leg_broken", false) then
            client:notify("You are not bleeding")
            return false
        end

        Injuries:RemoveFracture(client)
        return true
    end,
    onCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity) and client:getChar():getData("leg_broken", false)
    end
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
            Injuries:RemoveFracture(target)
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
