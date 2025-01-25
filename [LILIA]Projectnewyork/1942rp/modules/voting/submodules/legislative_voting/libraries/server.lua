local MODULE = MODULE
function MODULE:SaveData()
    local data = {}
    for k, v in ipairs(ents.FindByClass("legislativevotingbox")) do
        data[#data + 1] = {
            pos = v:GetPos(),
            angles = v:GetAngles(),
            LegislativeBoxVotes = self.LegislativeBoxVotes,
            LegislativeVoting = LegislativeVoting,
            LegislativeBoxTopics = self.LegislativeBoxTopics or {},
            LegislativeBoxSteamIDs = self.LegislativeBoxSteamIDs or {},
            LegislativeBoxSteamIDVoted = self.LegislativeBoxSteamIDVoted or {}
        }
    end

    self:setData(data)
end

function MODULE:LoadData()
    for k, v in ipairs(self:getData() or {}) do
        local entity = ents.Create("legislativevotingbox")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
        self.LegislativeBoxVotes = v.LegislativeBoxVotes or {
            Abstain = 0,
            Aye = 0,
            Nye = 0
        }

        LegislativeVoting = v.LegislativeVoting or false
        self.LegislativeBoxTopics = v.LegislativeBoxTopics or {}
        self.LegislativeBoxSteamIDs = v.LegislativeBoxSteamIDs or {}
        self.LegislativeBoxSteamIDVoted = v.LegislativeBoxSteamIDVoted or {}
        if LegislativeVoting and not LegVotingNotified then
            LegVotingNotified = true
            print("LOADING ACTIVE LEGISLATIVE VOTING!")
        end
    end
end
