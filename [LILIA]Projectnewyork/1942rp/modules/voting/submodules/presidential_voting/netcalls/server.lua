PresidentialVoting = PresidentialVoting or {}
netstream.Hook("ElectionVoteSubmit", function(client, vote)
    if not PresidentialVoting.CurrentElection or not PresidentialVoting.MetaData.CurrentElection or PresidentialVoting.MetaData.CurrentElectionPaused then return end
    if lia.config.MinimumPlayTimeVoting and lia.config.MinimumPlayTimeVoting > 0 and client:getPlayTime() < lia.config.MinimumPlayTimeVoting then return end
    local elData = PresidentialVoting.CurrentElection
    for k, v in pairs(elData.Votes) do
        if v.SteamID == client:SteamID() or v.IP == GetIPAddressNoPort(client) then return end
    end

    if not elData.Candidates[vote] then return end
    local voteTable = {
        SteamID = client:SteamID(),
        IP = GetIPAddressNoPort(client),
        Vote = vote
    }

    table.insert(elData.Votes, voteTable)
    PresidentialVoting.SaveCurrentElection()
    client:SendMessage("[", Color(255, 100, 100), "Presidential Votation", Color(255, 255, 255), "] ", "Your vote for ", Color(100, 255, 100), elData.Candidates[vote], Color(255, 255, 255), " has been submitted. Thank you for voting.")
end)

netstream.Hook("PresElectionNew", function(client, electionData)
    if not CAMI.PlayerHasAccess(client, "Management - Create Elections", nil) then return end
    if PresidentialVoting.MetaData.CurrentElection then
        client:notify("There is already an election running")
        return
    end

    PresidentialVoting.NewElection(electionData)
end)
