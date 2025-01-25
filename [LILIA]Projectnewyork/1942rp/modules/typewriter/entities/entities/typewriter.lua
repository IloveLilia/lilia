ENT.Type = "anim"
ENT.PrintName = "TypeWriter"
ENT.Author = "Samael"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Lilia"
ENT.IsPersistent = true
if SERVER then
    function ENT:Initialize()
        self:SetModel("models/slasherin/last year/props/retro-pack/sm_portablecomputer_01a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local physicsObject = self:GetPhysicsObject()
        if IsValid(physicsObject) then
            physicsObject:EnableMotion(false)
            physicsObject:Sleep()
        end
    end

    function ENT:Use(activator)
        net.Start("liaOpenTypewriter")
        net.Send(activator)
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end
