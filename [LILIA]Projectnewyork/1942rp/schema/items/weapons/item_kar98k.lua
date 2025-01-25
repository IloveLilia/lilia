ITEM.name = "Kar98k (Karabiner 98 kurz)"
ITEM.desc = "The Karabiner 98k (Kar98k), developed by Mauser in the 1930s, is a bolt-action rifle chambered in 7.92×57mm Mauser. Renowned for its accuracy, durability, and reliability, it served as the standard service rifle for the German Armed Forces Its robust design and effective performance in various combat conditions have made it one of the most iconic and widely used weapon globally"
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/w_waw_k98k.mdl"
ITEM.class = "arccw_waw_k98k"
ITEM.slot = "weapons"
ITEM.width = 6
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "primary"
ITEM.TeamBlacklist = {FACTION_CITIZEN}
-- 6 x 2
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 300, h - 98, 300, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 300, h - 3, 300, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 98, 3, 98)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 298, h - 98, 3, 98)
    end
end
