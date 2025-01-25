local MODULE = MODULE
function MODULE:SaveData()
    local data = {}
    for k, v in ipairs(ents.FindByClass("representativevotingbox")) do
        data[#data + 1] = {
            pos = v:GetPos(),
            angles = v:GetAngles(),
            RepresentativeVoting = RepresentativeVoting or false,
            RepresentativeBoxVotes = self.RepresentativeBoxVotes,
            RepresentativeBoxCandidates = self.RepresentativeBoxCandidates or {},
            RepresentativeBoxSteamIDs = self.RepresentativeBoxSteamIDs or {},
            RepresentativeBoxSteamIDVoted = self.RepresentativeBoxSteamIDVoted or {}
        }
    end

    self:setData(data)
end

function MODULE:LoadData()
    for k, v in ipairs(self:getData() or {}) do
        local entity = ents.Create("representativevotingbox")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
        RepresentativeVoting = v.RepresentativeVoting or false
        self.RepresentativeBoxVotes = v.RepresentativeBoxVotes or {}
        self.RepresentativeBoxCandidates = v.RepresentativeBoxCandidates or {}
        self.RepresentativeBoxSteamIDs = v.RepresentativeBoxSteamIDs or {}
        self.RepresentativeBoxSteamIDVoted = v.RepresentativeBoxSteamIDVoted or {}
        if RepresentativeVoting and not RepVotingNotified then
            RepVotingNotified = true
            print("LOADING ACTIVE LEGISLATIVE VOTING!")
        end
    end
end
