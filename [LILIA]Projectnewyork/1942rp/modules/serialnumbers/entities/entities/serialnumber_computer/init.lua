AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/props_lab/monitor02.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()
    if physObj:IsValid() then physObj:Wake() end
end

function ENT:Use(ply)
    if ply:Team() ~= FACTION_ASS then
        ply:notify("You do not have access to use the Police Serial Number Database.")
        return
    end

    if ply:GetEyeTrace().Entity == nil or (ply:GetEyeTrace().Entity ~= nil and ply:GetEyeTrace().Entity:GetClass() ~= "serialnumber_computer") then
        ply:notify("Cannot perform: Make sure you are looking directly at the computer.")
        return false
    end

    net.Start("OpenComputer")
    net.Send(ply)
end
