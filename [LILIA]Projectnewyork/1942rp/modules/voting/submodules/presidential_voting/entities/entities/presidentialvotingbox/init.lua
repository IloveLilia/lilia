AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
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
    if PresidentialVoting.MetaData.CurrentElectionPaused then
        activator:SendMessage("[", Color(255, 100, 100), "PresidentialVoting", Color(255, 255, 255), "] The current election has been paused.")
        return
    end

    if not PresidentialVoting.MetaData.CurrentElection or not PresidentialVoting.CurrentElection then
        activator:SendMessage("[", Color(255, 100, 100), "PresidentialVoting", Color(255, 255, 255), "] There is currently no active election.")
        return
    end

    if lia.config.MinimumPlayTimeVoting and lia.config.MinimumPlayTimeVoting > 0 and activator:getPlayTime() < lia.config.MinimumPlayTimeVoting then
        activator:SendMessage("[", Color(255, 100, 100), "PresidentialVoting", Color(255, 255, 255), "] You lack the minimum required playtime to vote (" .. math.Round(lia.config.MinimumPlayTimeVoting / 3600, 2) .. " hours)")
        return
    end

    local elData = PresidentialVoting.CurrentElection
    activator:SendMessage("[", Color(255, 100, 100), "PresidentialVoting", Color(255, 255, 255), "] Current election is for ", Color(100, 255, 100), elData.Name)
    activator:SendMessage("[", Color(255, 100, 100), "PresidentialVoting", Color(255, 255, 255), "] Description: ", Color(100, 100, 255), elData.Description)
    for k, v in pairs(elData.Votes) do
        if v.SteamID == activator:SteamID() or v.IP == GetIPAddressNoPort(activator) then
            activator:SendMessage(Color(255, 100, 100), "You have already cast your vote in this election.")
            return
        end
    end

    activator:SendMessage(Color(100, 255, 100), "You are eligible to vote in this election.")
    netstream.Start(activator, "ElectionVote", elData)
end
