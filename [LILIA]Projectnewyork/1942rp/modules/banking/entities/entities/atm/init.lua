AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/project-new-york/winter/baseline_male06_vendor.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)
    self.LastUseTime = 0 -- Initialize the last use time
end

function ENT:Use(ply)
    if not IsValid(ply) then return end
    local currentTime = CurTime() -- Get the current time
    if self.LastUseTime and currentTime - self.LastUseTime < 1 then -- 1 second cooldown
        return -- If the cooldown has not passed, return and do nothing
    end

    self.LastUseTime = currentTime -- Update the last use time
    net.Start("Banking::OpenBankGUI")
    net.Send(ply)
end
