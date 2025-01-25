ITEM.name = "Colt M1911"
ITEM.desc = "The M1911 is a classic semi-automatic pistol, renowned for its reliability, accuracy, and stopping power. Originally designed by John Browning and adopted by the U.S. military in 1911, this .45 ACP handgun has served in numerous conflicts and remains a popular choice for military, law enforcement, and civilian use."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/c_waw_m1911.mdl"
ITEM.class = "arccw_bo1_m1911"
ITEM.slot = "weapons"
ITEM.width = 3
ITEM.height = 1
ITEM.isWeapon = true
ITEM.weaponCategory = "secondary"
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
