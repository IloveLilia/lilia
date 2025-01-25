local MODULE = MODULE
local playerMeta = FindMetaTable("Player")
function playerMeta:CanInspectWeapon()
    if table.HasValue(MODULE.InspectorFactions, self:Team()) then return true end
    if MODULE.InspectGunFlag and self:getChar():hasFlags(MODULE.InspectGunFlag) then return true end
    return false
end
