local toScreen = FindMetaTable("Vector").ToScreen
include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end

function ENT:onShouldDrawEntityInfo()
    return true
end

function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + Vector(0, 0, 0))
    local x, y = position.x, position.y
    lia.util.drawText("Bank Manager", x, y - 65, ColorAlpha(lia.config.Color, alpha), 1, 1, nil, alpha * 0.65)
end
