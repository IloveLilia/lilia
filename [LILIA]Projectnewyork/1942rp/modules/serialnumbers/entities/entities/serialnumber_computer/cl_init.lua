include("shared.lua")
local toScreen = FindMetaTable("Vector").ToScreen
function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + Vector(0, 0, -20))
    local x, y = position.x, position.y
    lia.util.drawText("Police Computer", x, y, ColorAlpha(lia.config.Color, alpha), 1, 1, nil, alpha * 0.65)
end
