ITEM.name = "Morphine"
ITEM.desc = "This is Morphine. Used to Avoid Bleeding Effects."
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
        local currentTime = os.time()
        local LastMorphine = client:GetNWInt("LastMorphine")
        if LastMorphine and LastMorphine > (currentTime + 60) then
            client:SetNWInt("LastMorphine", currentTime)
            if client:GetNWBool("Bleeding", false) then
                client:SetNWBool("UsedMorphineProperly", true)
            else
                client:SetNWBool("DidntUseMorphineProperly", true)
            end
        else
            client:Kill()
        end
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
        local currentTime = os.time()
        local LastMorphine = target:GetNWInt("LastMorphine")
        if target and target:IsValid() and target:IsPlayer() and target:Alive() then
            if LastMorphine and LastMorphine > (currentTime + 60) then
                target:SetNWInt("LastMorphine", currentTime)
                if target:GetNWBool("Bleeding", false) then
                    target:SetNWBool("UsedMorphineProperly", true)
                else
                    target:SetNWBool("DidntUseMorphineProperly", true)
                end
            else
                target:Kill()
            end
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
