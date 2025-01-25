local MODULE = MODULE
function MODULE:HUDPaint()
    local ent = LocalPlayer():GetEyeTrace().Entity
    if IsValid(ent) and ent:GetClass() == "representativevotingbox" then
        local distSquared = LocalPlayer():GetPos():DistToSqr(ent:GetPos())
        local color = Color(255, 255, 255, (1 - math.Clamp(distSquared / (300 * 300), 0, 1)) * 255)
        local color2 = Color(0, 0, 0, (1 - math.Clamp(distSquared / (300 * 300), 0, 1)) * 200)
        draw.SimpleText("Representative Box", "liaBigFont", ScrW() / 2 + 2, ScrH() / 2 + 2, color2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Representative Box", "liaBigFont", ScrW() / 2, ScrH() / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end
