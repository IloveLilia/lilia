ITEM.name = "Walther P.38"
ITEM.desc = "The Walther P38 is a historic semi-automatic pistol developed by Carl Walther GmbH in the late 1930s for the German military. Chambered in 9×19mm Parabellum, it features a distinctive double-action trigger and an innovative locking block system, enhancing safety and reliability. Known for its solid construction and effective performance, the P38 served extensively during World War II and has influenced many modern pistol designs."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/c_waw_p38.mdl"
ITEM.class = "arccw_waw_p38"
ITEM.slot = "weapons"
ITEM.width = 3
ITEM.height = 1
ITEM.isWeapon = true
ITEM.weaponCategory = "secondary"
ITEM.TeamBlacklist = {FACTION_CITIZEN}
-- 3 x 1
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 148, h - 48, 148, 3)
        -- Bottom
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 148, h - 3, 148, 3)
        -- Right
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 3, h - 48, 3, 48)
        -- Left
        surface.SetDrawColor(179, 179, 179)
        surface.DrawRect(w - 148, h - 48, 3, 48)
    end
end
