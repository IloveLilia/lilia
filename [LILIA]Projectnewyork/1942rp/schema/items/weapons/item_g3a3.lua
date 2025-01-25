ITEM.name = "Heckler & Koch G3A3 (Gewehr 3)"
ITEM.desc = "The G3A3, developed by Heckler & Koch, is a robust and reliable 7.62×51mm NATO battle rifle. Featuring a roller-delayed blowback system, it provides excellent accuracy and durability. With its fixed polymer stock, iron sights, and compatibility with various optics, the G3A3 is well-suited for military use. Its design ensures consistent performance in harsh conditions, making it a preferred choice for armed forces worldwide."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/c_bo1_g3.mdl"
ITEM.class = "arccw_bo1_g3"
ITEM.slot = "weapons"
ITEM.width = 5
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
