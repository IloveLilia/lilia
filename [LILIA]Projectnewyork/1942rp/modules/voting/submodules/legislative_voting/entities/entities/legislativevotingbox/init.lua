local MODULE = MODULE
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
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
    if not LegislativeVoting then
        activator:notify("No Legislative Voting is OnGoing!")
        return
    end

    if MODULE.LegislativeBoxSteamIDVoted and table.HasValue(MODULE.LegislativeBoxSteamIDVoted, activator:SteamID()) then
        activator:notify("You already voted!")
        return
    end

    if MODULE.LegislativeBoxTopics and table.IsEmpty(MODULE.LegislativeBoxTopics) then
        activator:notify("There's no topics!")
        return
    end

    if MODULE.LegislativeBoxSteamIDs and table.IsEmpty(MODULE.LegislativeBoxSteamIDs) then
        activator:notify("There's no defined SteamIDs!")
        return
    end

    netstream.Start(activator, "CreateLegislativeVotingMenu", self, MODULE.LegislativeBoxTopics, MODULE.LegislativeBoxSteamIDs, activator:SteamID())
end
