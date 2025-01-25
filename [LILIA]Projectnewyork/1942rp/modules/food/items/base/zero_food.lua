ITEM.name = "Zero Food base"
ITEM.desc = "Tasty"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.hunger = 0
ITEM.thrist = 0
ITEM.alcohol = 0
ITEM.functions.Eat = {
    text = "Eat",
    icon = "icon16/cup.png",
    onRun = function(item)
        local client = item.player
        if client:isObserving() then
            client:notify("You can't eat while observing.")
            return false
        end

        client:EmitSound("npc/barnacle/barnacle_gulp1.wav")
        client:addHunger(item.hunger)
        client:addThrist(item.thrist)
        client:AddBAC(item.alcohol)
    end
}

ITEM.functions.Cook = {
    name = "Use for Cooking",
    onRun = function(item)
        local tr = item.player:GetEyeTrace()
        local name = item.name
        zmc.Item.Spawn(tr.HitPos, name)
    end
}
