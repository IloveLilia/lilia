ITEM.name = "Mauser MG-42 (Maschinengewehr-42)"
ITEM.desc = "The Maschinengewehr 42 (MG42) is a general-purpose machine gun known for its exceptional rate of fire, up to 1,200 rounds per minute. Chambered in 7.92×57mm Mauser, it features a recoil-operated mechanism and is praised for its durability, reliability, and ease of use."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/c_waw_mg42.mdl"
ITEM.class = "arccw_waw_mg42"
ITEM.slot = "weapons"
ITEM.width = 7
ITEM.height = 3
ITEM.isWeapon = true
ITEM.weaponCategory = "primary"
ITEM.TeamBlacklist = {FACTION_CITIZEN}
-- 7 x 3
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 350, h - 146, 350, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 350, h - 3, 350, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 146, 3, 146)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 350, h - 146, 3, 146)
    end
end
