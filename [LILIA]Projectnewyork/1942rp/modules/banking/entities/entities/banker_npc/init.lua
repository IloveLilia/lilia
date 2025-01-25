AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/project-new-york/winter/baseline_male06_vendor.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
    timer.Simple(0.5, function()
        if IsValid(self) then
            self:SetAnim()
            self:SetPos(self:GetPos() - Vector(0, 0, 3))
        end
    end)
end

function ENT:Use(activator)
    if not IsValid(activator) then return end
    activator.AntiSpamNPC = activator.AntiSpamNPC or CurTime()
    local timeRemaining = activator.AntiSpamNPC - CurTime()
    if activator.AntiSpamNPC > CurTime() then
        activator:notify("You must wait 3 seconds to use the Banker NPC again. You must wait " .. math.ceil(timeRemaining) .. " more second(s).")
        return
    end

    activator.AntiSpamNPC = CurTime() + 3
    net.Start("Banking::OpenBankerUI")
    net.Send(activator)
end

function ENT:SetAnim()
    for k, v in ipairs(self:GetSequenceList()) do
        if v:lower():find("idle") and v ~= "idlenoise" then return self:ResetSequence(k) end
    end

    if self:GetSequenceCount() > 1 then self:ResetSequence(4) end
end
