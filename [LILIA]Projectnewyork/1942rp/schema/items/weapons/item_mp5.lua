ITEM.name = "Heckler & Koch MP5-A5 (Maschinenpistole 5-A5)"
ITEM.desc = "The MP5A5, developed by Heckler & Koch, is a highly reliable and versatile 9×19mm Parabellum submachine gun. Known for its roller-delayed blowback system, it offers exceptional accuracy and low recoil. Featuring a collapsible stock, multiple fire modes (including semi-automatic, 3-round burst, and fully automatic), and compatibility with various optics and suppressors, the MP5A5 is ideal for military, law enforcement, and security operations. Its robust construction and ease of maintenance ensure consistent performance in diverse tactical environments."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/c_bo2_mp5.mdl"
ITEM.class = "arccw_bo2_mp5"
ITEM.slot = "weapons"
ITEM.width = 5
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "primary"
ITEM.TeamBlacklist = {FACTION_CITIZEN}
-- 5 x 2
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 248, h - 98, 248, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 248, h - 3, 248, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 98, 3, 98)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 248, h - 98, 3, 98)
    end
end
