PresidentialVoting = PresidentialVoting or {}
lia.command.add("preselectionnew", {
    privilege = "Management - Create Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if PresidentialVoting.MetaData.CurrentElection then return "There is already an election running" end
        netstream.Start(client, "PresElectionNew")
    end
})

lia.command.add("preselectionend", {
    privilege = "Management - End Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if not PresidentialVoting.MetaData.CurrentElection or not PresidentialVoting.CurrentElection then return "There is currently no election running" end
        PresidentialVoting.EndCurrentElection()
    end
})

lia.command.add("preselectionpausetoggle", {
    privilege = "Management - Toggle Elections Pause",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if not PresidentialVoting.MetaData.CurrentElection or not PresidentialVoting.CurrentElection then return "There is currently no election running" end
        PresidentialVoting.MetaData.CurrentElectionPaused = not PresidentialVoting.MetaData.CurrentElectionPaused
        if PresidentialVoting.MetaData.CurrentElectionPaused then
            PresidentialVoting.Message("The election ", Color(100, 100, 255), PresidentialVoting.CurrentElection.Name, color_white, " has been ", Color(255, 100, 100), "PAUSED")
        else
            PresidentialVoting.Message("The election ", Color(100, 100, 255), PresidentialVoting.CurrentElection.Name, color_white, " has been ", Color(100, 255, 100), "RESUMED")
        end

        PresidentialVoting.SaveMetaData()
    end
})

lia.command.add("preselectionresults", {
    syntax = "",
    onRun = function(client, arguments)
        if PresidentialVoting.MetaData.CurrentElection then return "Results will only be available at the end of the election" end
        if not PresidentialVoting.MetaData.LastResults then return "There are no recent election results" end
        netstream.Start(client, "ElectionResults", PresidentialVoting.MetaData.LastResults)
    end
})

lia.command.add("preselectionresultsadmin", {
    privilege = "Management - Verify Election Results - Admin Version",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "ElectionResultsAdmin", PresidentialVoting.MetaData.ElectionIndex, PresidentialVoting.MetaData.CurrentElection and PresidentialVoting.CurrentElection) end
})
