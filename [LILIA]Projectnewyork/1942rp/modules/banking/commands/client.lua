lia.command.add("deletebankaccount", {
    syntax = "[Bank Account #]",
    superAdminOnly = true,
    onRun = function(client, arguments) end
})

lia.command.add("banklogs", {
    superAdminOnly = true,
    syntax = "<string name>",
    privilege = "Verify Bank Logs",
    onRun = function(client, arguments) end
})
