local playerMeta = FindMetaTable("Player")
function playerMeta:PlayGestureAnimation(animation)
    net.Start("GestureAnimation")
    net.WriteEntity(self)
    net.WriteString(animation)
    net.SendPVS(self:GetPos())
end
