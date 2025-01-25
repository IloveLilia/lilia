local MODULE = MODULE
lia.command.add("repelectionresults", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client)
        if not RepresentativeVoting then return "There is no election running" end
        netstream.Start(client, "ChatPrintRepVotes", MODULE.RepresentativeBoxVotes)
    end
})

lia.command.add("repelectionaddcandidate", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "RepAddCandidate") end
})

lia.command.add("replistcurrentcandidates", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        RepresentativeVoting = false
        MODULE.RepresentativeBoxVotes = {}
        MODULE.RepresentativeBoxCandidates = {}
        MODULE.RepresentativeBoxSteamIDVoted = {}
        if not table.IsEmpty(MODULE.RepresentativeBoxCandidates) then
            netstream.Start(client, "ListCurrentCandidates", MODULE.RepresentativeBoxCandidates)
        else
            client:notify("Table is empty!")
        end
    end
})

lia.command.add("repelectionend", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client)
        if not RepresentativeVoting then return "There is no election running" end
        client:ChatPrint("Election has ended. Results:")
        netstream.Start(client, "ChatPrintRepVotes", MODULE.RepresentativeBoxVotes)
        RepresentativeVoting = false
        MODULE.RepresentativeBoxVotes = {}
        MODULE.RepresentativeBoxCandidates = {}
        MODULE.RepresentativeBoxSteamIDVoted = {}
        MODULE:SaveData()
    end
})

lia.command.add("repmenu", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client) netstream.Start(client, "RepresentativeMenu") end
})

lia.command.add("repelectionnew", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if RepresentativeVoting then return "There is already an election running" end
        RepresentativeVoting = true
        MODULE.RepresentativeBoxVotes = {}
        MODULE.RepresentativeBoxCandidates = {}
        MODULE.RepresentativeBoxSteamIDVoted = {}
        MODULE:SaveData()
    end
})
