lia.command.add("preselectionnew", {
    privilege = "Management - Create Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})

lia.command.add("preselectionend", {
    privilege = "Management - End Elections",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})

lia.command.add("preselectionpausetoggle", {
    privilege = "Management - Toggle Elections Pause",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})

lia.command.add("preselectionresults", {
    syntax = "",
    onRun = function(client, arguments) end
})

lia.command.add("preselectionresultsadmin", {
    privilege = "Management - Verify Election Results - Admin Version",
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments) end
})
