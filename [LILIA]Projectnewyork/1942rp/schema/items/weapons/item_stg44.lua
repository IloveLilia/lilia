ITEM.name = "Haenel StG-44 (Sturmgewehr-44)"
ITEM.desc = "The Sturmgewehr 44 (StG 44) is widely regarded as the world's first true assault rifle. Chambered in 7.92×33mm Kurz, it features a gas-operated, selective-fire mechanism, combining the firepower of a submachine gun with the range and accuracy of a rifle."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/w_waw_stg44.mdl"
ITEM.class = "arccw_bo3_stg44"
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
