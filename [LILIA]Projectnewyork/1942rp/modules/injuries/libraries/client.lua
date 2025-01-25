function MODULE:RenderScreenspaceEffects()
    local client = LocalPlayer()
    local blood = client:GetNWInt("blood", 100)
    local desaturation = 1 - (blood / 100)
    local colorModifyTable = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1 - desaturation,
        ["$pp_colour_colour"] = 1 - desaturation,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    if not (IsValid(client) or client:Alive()) then return end
    if client:GetNWBool("DidntUseMorphineProperly", false) or (client:GetNWBool("Bleeding", false) or client:GetNWBool("BleedingBandaged", false)) then DrawColorModify(colorModifyTable) end
end
