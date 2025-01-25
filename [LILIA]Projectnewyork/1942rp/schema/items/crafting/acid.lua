ITEM.name = "Acid (Hydrochloric Acid)"
ITEM.desc = ""
ITEM.model = "models/props_junk/plasticcontainer02.mdl"
ITEM.width = 1
ITEM.height = 2
ITEM.category = "Crafting"
-- 1 x 2
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 48, h - 98, 48, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 48, h - 3, 48, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 98, 3, 98)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 48, h - 98, 3, 98)
    end
end
