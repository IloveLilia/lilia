ITEM.name = "Colt Model 1921A Thompson"
ITEM.desc = "The Colt Model 1921A Thompson, also known as the 'Tommy Gun', is a .45 ACP submachine gun developed by General John T. Thompson. Famous for its high rate of fire and reliability, it features a distinctive vertical foregrip and drum or box magazines. Widely used by law enforcement and military personnel, as well as notorious during the Prohibition era, the Thompson became an iconic firearm of the early 20th century."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/arccw/c_bo2_thompson.mdl"
ITEM.class = "arccw_bo2_thompson"
ITEM.slot = "weapons"
ITEM.width = 5
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "primary"
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
