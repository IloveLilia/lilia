﻿ITEM.name = "Paraffin Wax"
ITEM.desc = ""
ITEM.model = "models/props_junk/glassjug01.mdl"
ITEM.price = 20
ITEM.category = "Crafting"
-- 1 x 1
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 48, h - 48, 48, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 48, h - 3, 48, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 48, 3, 48)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 48, h - 48, 3, 48)
    end
end
