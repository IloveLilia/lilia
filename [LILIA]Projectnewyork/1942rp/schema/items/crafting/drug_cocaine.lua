ITEM.name = "Cocaine"
ITEM.desc = ""
ITEM.model = "models/cocn.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.category = "Crafting"
ITEM.functions.Use = {
    name = "Consume",
    tip = "Consume the pill.",
    icon = "icon16/pill.png",
    onCanRun = function(item) return not IsValid(item.entity) end,
    onRun = function(item)
        local client = item.player
        local character = client:getChar()
        if character then
            -- Slow down player's movement speed
            local originalWalkSpeed = client:GetWalkSpeed()
            client:SetWalkSpeed(originalWalkSpeed * 1.1) -- Walking Speed
            client:SetRunSpeed(originalWalkSpeed * 1.1) -- Sprint Speed
        end
    end,
}

-- 2 x 1
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 98, h - 48, 98, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 98, h - 3, 98, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 48, 3, 48)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 98, h - 48, 3, 48)
    end
end
