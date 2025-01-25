local MODULE = MODULE
lia.command.add("legelectionresults", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client) netstream.Start(client, "ChatPrintLegVotes", MODULE.LegislativeBoxVotes) end
})

lia.command.add("legelectionnew", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if LegislativeVoting then return "There is already an election running" end
        LegislativeVoting = true
        MODULE.LegislativeBoxVotes = {
            Abstain = 0,
            Aye = 0,
            Nye = 0
        }

        MODULE.LegislativeBoxTopics = {}
        MODULE.LegislativeBoxSteamIDVoted = {}
        client:ChatPrint("Legislative voting discussions have been started for all topics.")
        MODULE:SaveData()
    end
})

lia.command.add("legelectionaddtopic", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "LegAddTopic") end
})

lia.command.add("leglistcurrenttopics", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if not table.IsEmpty(MODULE.LegislativeBoxTopics) then
            netstream.Start(client, "ListCurrentTopics", MODULE.LegislativeBoxTopics)
        else
            client:notify("Table is empty!")
        end
    end
})

lia.command.add("legelectionaddsteamids", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "LegAddSteamID") end
})

lia.command.add("legelectionremovesteamids", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) netstream.Start(client, "LegRemoveSteamID") end
})

lia.command.add("leglistcurrentsteamids", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        if MODULE.LegislativeBoxSteamIDs then
            if not table.IsEmpty(MODULE.LegislativeBoxSteamIDs) then
                netstream.Start(client, "ListCurrentSteamIDs", MODULE.LegislativeBoxSteamIDs)
            else
                client:notify("Table is empty!")
            end
        else
            client:notify("Table doesn't exist!")
        end
    end
})

lia.command.add("legelectionend", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client)
        if not LegislativeVoting then return "There is no election running" end
        netstream.Start(client, "ChatPrintLegVotes", MODULE.LegislativeBoxVotes)
        LegislativeVoting = false
        MODULE.LegislativeBoxVotes = {
            Abstain = 0,
            Aye = 0,
            Nye = 0
        }

        MODULE.LegislativeBoxTopics = {}
        MODULE.LegislativeBoxSteamIDVoted = {}
        client:ChatPrint("Legislative voting discussions have been ended.")
        MODULE:SaveData()
    end
})

lia.command.add("legmenu", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client) netstream.Start(client, "LegislativeMenu") end
})
