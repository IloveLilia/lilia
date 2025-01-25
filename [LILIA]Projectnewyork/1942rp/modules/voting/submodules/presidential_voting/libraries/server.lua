local MODULE = MODULE
PresidentialVoting = PresidentialVoting or {}
file.CreateDir("presidentialvotingbox/elections")
file.CreateDir("presidentialvotingbox/entities")
function MODULE:SaveData()
    local data = {}
    for k, v in pairs(ents.FindByClass("presidentialvotingbox")) do
        data[#data + 1] = {
            pos = v:GetPos(),
            angles = v:GetAngles()
        }
    end

    file.Write("presidentialvotingbox/entities/" .. game.GetMap() .. ".txt", util.TableToJSON(data))
end

function MODULE:LoadData()
    local data = util.JSONToTable(file.Read("presidentialvotingbox/entities/" .. game.GetMap() .. ".txt") or "[]") or {}
    for k, v in pairs(data) do
        local position = v.pos
        local angles = v.angles
        local entity = ents.Create("presidentialvotingbox")
        entity:SetPos(position)
        entity:SetAngles(angles)
        entity:Spawn()
        entity:Activate()
        local phys = entity:GetPhysicsObject()
        if phys and phys:IsValid() then phys:EnableMotion(false) end
    end
end

if file.Exists("presidentialvotingbox/metadata.txt", "DATA") then
    PresidentialVoting.MetaData = util.JSONToTable(file.Read("presidentialvotingbox/metadata.txt"))
else
    PresidentialVoting.MetaData = {
        NextElectionID = 0,
        CurrentElection = nil,
        CurrentElectionLength = nil,
        CurrentElectionPaused = false,
        ElectionIndex = {}
    }
end

function PresidentialVoting.SaveMetaData()
    file.Write("presidentialvotingbox/metadata.txt", util.TableToJSON(PresidentialVoting.MetaData, true))
end

PresidentialVoting.SaveMetaData()
if file.Exists("presidentialvotingbox/results.txt", "DATA") then
    PresidentialVoting.Results = util.JSONToTable(file.Read("presidentialvotingbox/results.txt"))
else
    PresidentialVoting.Results = {}
end

if PresidentialVoting.MetaData.CurrentElection then
    local currentElectionFile = "presidentialvotingbox/elections/election_" .. PresidentialVoting.MetaData.CurrentElection .. ".txt"
    if not file.Exists(currentElectionFile, "DATA") then
        PresidentialVoting.MetaData.CurrentElection = nil
        print("[PresidentialVoting] Current Election File does not exist! Did you mess with it?")
    else
        PresidentialVoting.CurrentElection = util.JSONToTable(file.Read(currentElectionFile))
        if PresidentialVoting.CurrentElection.ID ~= PresidentialVoting.MetaData.CurrentElection then
            PresidentialVoting.CurrentElection = nil
            PresidentialVoting.MetaData.CurrentElection = nil
            print("[PresidentialVoting] Some weird ass issue! MetaData CurrentElection isn't the same as the ID of the election loaded")
            return
        end

        print("[PresidentialVoting] Loaded current election (" .. PresidentialVoting.CurrentElection.Name .. ")")
    end
end

local MODULE = MODULE
PresidentialVoting = PresidentialVoting or {}
function PresidentialVoting.NewElection(electionData)
    if PresidentialVoting.MetaData.CurrentElection then return end
    local newElectionTable = {
        ID = PresidentialVoting.MetaData.NextElectionID,
        Name = electionData.Name,
        Results = {},
        Description = electionData.Description,
        Candidates = electionData.Candidates,
        Votes = {},
    }

    PresidentialVoting.CurrentElection = newElectionTable
    PresidentialVoting.MetaData.CurrentElection = newElectionTable.ID
    PresidentialVoting.MetaData.CurrentElectionPaused = false
    if electionData.Duration then
        PresidentialVoting.MetaData.CurrentElectionLength = electionData.Duration * 60
    else
        PresidentialVoting.MetaData.CurrentElectionLength = nil
    end

    PresidentialVoting.MetaData.NextElectionID = PresidentialVoting.MetaData.NextElectionID + 1
    PresidentialVoting.MetaData.ElectionIndex[newElectionTable.ID] = {
        Name = newElectionTable.Name
    }

    PresidentialVoting.SaveMetaData()
    PresidentialVoting.SaveCurrentElection()
    print("[PresidentialVoting] New election started for " .. PresidentialVoting.CurrentElection.Name)
    PresidentialVoting.Message("The election ", Color(100, 255, 100), PresidentialVoting.CurrentElection.Name, Color(255, 255, 255), " has just begun!")
    PresidentialVoting.Message("Description: ", Color(100, 100, 255), PresidentialVoting.CurrentElection.Description)
    PresidentialVoting.Message("To participate in the election, find your nearest ", Color(255, 255, 100), "Presidential Voting Box", Color(255, 255, 255), " and press E on it.")
end

function PresidentialVoting.SaveCurrentElection()
    if not PresidentialVoting.CurrentElection then return end
    file.Write("presidentialvotingbox/elections/election_" .. PresidentialVoting.CurrentElection.ID .. ".txt", util.TableToJSON(PresidentialVoting.CurrentElection, true))
end

function PresidentialVoting.EndCurrentElection()
    if not PresidentialVoting.CurrentElection then return end
    print("[PresidentialVoting] " .. PresidentialVoting.CurrentElection.Name .. " has ended.")
    local elData = PresidentialVoting.CurrentElection
    local votedSteamIDs = {}
    local votedIPs = {}
    local results = {}
    for k, v in pairs(elData.Candidates) do
        results[k] = 0
    end

    for k, v in pairs(elData.Votes) do
        if not v.Vote or not v.SteamID or not v.IP or not elData.Candidates[v.Vote] then continue end
        if votedSteamIDs[v.SteamID] or votedIPs[v.IP] then
            print("[PresidentialVoting] Found duplicate vote: (" .. v.SteamID .. ", " .. v.IP .. ", VoteFor: " .. v.Vote .. "). Skipped in counting")
            continue
        end

        votedSteamIDs[v.SteamID] = true
        votedIPs[v.IP] = true
        results[v.Vote] = results[v.Vote] + 1
    end

    local resultsSorted = {}
    local winner = nil
    for k, v in pairs(results or {}) do
        local curResult = {
            SteamID = k,
            CandidateName = elData.Candidates[k],
            Votes = v
        }

        resultsSorted[#resultsSorted + 1] = curResult
        if winner == nil or v > winner.Votes then winner = curResult end
    end

    table.sort(resultsSorted, function(a, b) return a.Votes > b.Votes end)
    PresidentialVoting.MetaData.LastResults = {
        Name = elData.Name,
        Results = resultsSorted
    }

    PresidentialVoting.CurrentElection.Winner = winner
    PresidentialVoting.CurrentElection.Results = resultsSorted
    PresidentialVoting.SaveCurrentElection()
    PresidentialVoting.MetaData.ElectionIndex[elData.ID].Winner = winner
    PresidentialVoting.MetaData.ElectionIndex[elData.ID].Results = resultsSorted
    PresidentialVoting.MetaData.CurrentElection = nil
    PresidentialVoting.MetaData.CurrentElectionLength = nil
    PresidentialVoting.MetaData.CurrentElectionPaused = false
    PresidentialVoting.SaveMetaData()
    PresidentialVoting.CurrentElection = nil
    PresidentialVoting.Message("The election for ", Color(100, 255, 100), elData.Name, Color(255, 255, 255), " has Ended!")
    PresidentialVoting.Message("The Winner is ", Color(100, 100, 255), winner.CandidateName)
    PresidentialVoting.Message("For detailed results type ", Color(255, 255, 100), "/electionresults")
end

function PresidentialVoting.Message(...)
    local argsTable = {...}
    for k, v in pairs(player.GetAll()) do
        v:SendMessage("[", Color(255, 100, 100), "Elections", Color(255, 255, 255), "] ", unpack(argsTable))
    end
end

function GetIPAddressNoPort(client)
    if IsValid(client) and client:IsPlayer() then
        local ipAddress = client:IPAddress()
        local ipWithoutPort = ipAddress:match("^(%d+%.%d+%.%d+%.%d+)")
        return ipWithoutPort
    else
        return nil, "Invalid player"
    end
end
