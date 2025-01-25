local MODULE = MODULE
lia.command.add("deletebankaccount", {
    syntax = "[Bank Account #]",
    superAdminOnly = true,
    onRun = function(client, arguments)
        local bankID = arguments[1]
        DeleteBankAccount(client, bankID)
    end
})

lia.command.add("banklogs", {
    superAdminOnly = true,
    syntax = "<string name>",
    privilege = "Verify Bank Logs",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if target then
            MODULE:RequestBankLogs(client, target:getChar():getID())
        else
            MODULE:RequestBankLogs(client)
        end
    end
})
