local MODULE = MODULE
netstream.Hook("SubmitVotes", function(client, voteData)
    for _, candidate in ipairs(voteData.candidates) do
        MODULE.RepresentativeBoxVotes[candidate.name] = (MODULE.RepresentativeBoxVotes[candidate.name] or 0) + 1
    end

    table.insert(MODULE.RepresentativeBoxSteamIDVoted, client:SteamID())
    MODULE:SaveData()
end)

netstream.Hook("RepRegisterCandidate", function(client, topic) table.insert(MODULE.RepresentativeBoxCandidates, topic) end)
