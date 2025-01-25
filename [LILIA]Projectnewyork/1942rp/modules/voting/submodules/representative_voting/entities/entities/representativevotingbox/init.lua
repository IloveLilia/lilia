AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
local MODULE = MODULE
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/props_c17/furnitureStove001a.mdl")
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then phys:Wake() end
end

function ENT:Use(activator, caller)
    if not RepresentativeVoting then
        activator:notify("No Representative Voting is OnGoing!")
        return
    end

    if MODULE.RepresentativeBoxSteamIDVoted and table.HasValue(MODULE.RepresentativeBoxSteamIDVoted, activator:SteamID()) then
        activator:notify("You already voted!")
        return
    end

    if MODULE.RepresentativeBoxCandidates and table.IsEmpty(MODULE.RepresentativeBoxCandidates) then
        activator:notify("There's no candidates!")
        return
    end

    netstream.Start(activator, "CreateRepresentativeVotingMenu", self, MODULE.RepresentativeBoxCandidates)
end
