ITEM.name = "Battery"
ITEM.desc = "A mobile power source."
ITEM.model = "models/items/car_battery01.mdl"
ITEM.price = 1880
ITEM.category = "crafting"
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
