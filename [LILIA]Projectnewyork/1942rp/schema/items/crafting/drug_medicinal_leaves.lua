﻿ITEM.name = "Medicinal Leaves"
ITEM.desc = ""
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.category = "Crafting"
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
