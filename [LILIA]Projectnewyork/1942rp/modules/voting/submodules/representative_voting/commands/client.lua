lia.command.add("repelectionresults", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client) end
})

lia.command.add("repelectionaddcandidate", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})

lia.command.add("replistcurrentcandidates", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})

lia.command.add("repelectionend", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client) end
})

lia.command.add("repmenu", {
    superAdminOnly = true,
    privilege = "Manage Elections",
    onRun = function(client) end
})

lia.command.add("repelectionnew", {
    privilege = "Manage Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})
