ITEM.name = "Blood Bag"
ITEM.desc = "This is a Blood Bag. Used to fill blood."
ITEM.category = "Medical"
ITEM.model = "models/Gibs/wood_gib01e.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.BloodAmount = 50
ITEM.functions.use = {
    name = "Use",
    tip = "equipTip",
    icon = "icon16/tick.png",
    onRun = function(item)
        local client = item.player
        local currentBlood = client:GetNWInt("blood", 0)
        local newBlood = math.min(currentBlood + item.BloodAmount, 100)
        client:SetNWInt("blood", newBlood)
        client:ChatPrint("You have restored your body's condition!")
        return true
    end,
}

ITEM.functions.usef = {
    name = "Use Forward",
    tip = "useTip",
    icon = "icon16/arrow_up.png",
    onRun = function(item)
        local client = item.player
        local trace = client:GetEyeTraceNoCursor()
        local target = trace.Entity
        local currentBlood = target:GetNWInt("blood", 0)
        local newBlood = math.min(currentBlood + item.BloodAmount, 100)
        if target and target:IsValid() and target:IsPlayer() and target:Alive() then
            client:SetNWInt("blood", newBlood)
            client:ChatPrint("You have restored this player's body's condition!")
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
--TODO ADD TRAIT // Doctor of Medicine
