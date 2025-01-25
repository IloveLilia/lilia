ITEM.name = "M1 Garand"
ITEM.desc = ""
ITEM.category = "Weapons"
ITEM.model = "models/weapons/tfa_doi/w_m1garand.mdl"
ITEM.class = "arccw_waw_garand"
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
