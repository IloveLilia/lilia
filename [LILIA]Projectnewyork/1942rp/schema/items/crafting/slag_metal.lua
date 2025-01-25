ITEM.name = "Metal Slag"
ITEM.desc = ""
ITEM.model = "models/props_clutter/ore_iron.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Crafting"
-- 2 x 2
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 98, h - 98, 98, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 98, h - 3, 98, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 98, 3, 98)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 98, h - 98, 3, 98)
    end
end
