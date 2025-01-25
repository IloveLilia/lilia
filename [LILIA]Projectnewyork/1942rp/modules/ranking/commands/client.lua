lia.command.add("charsettitle", {
    privilege = "Characters - Set Title",
    adminOnly = true,
    syntax = "<string target> <string title>",
    onRun = function(client, arguments) end
})

lia.command.add("charsetrank", {
    privilege = "Characters - Set Rank",
    adminOnly = true,
    syntax = "<string target>",
    onRun = function(client, arguments) end
})

lia.command.add("toggletitle", {
    adminOnly = false,
    onRun = function(client, arguments) end
})

lia.command.add("togglerank", {
    adminOnly = false,
    onRun = function(client, arguments) end
})

lia.command.add("chartoggletitle", {
    syntax = "<string name>",
    privilege = "Characters - Toggle Title",
    adminOnly = true,
    onRun = function(client, arguments) end
})

lia.command.add("chartogglerank", {
    privilege = "Characters - Toggle Rank",
    syntax = "<string name>",
    adminOnly = true,
    onRun = function(client, arguments) end
})

lia.command.add("promote", {
    syntax = "<string name>",
    adminOnly = false,
    onRun = function(client, arguments) end
})

lia.command.add("cotransfer", {
    adminOnly = false,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})

lia.command.add("resettransfercooldown", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})

lia.command.add("resetpromotecooldown", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})

lia.command.add("rankingblacklist", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})

lia.command.add("unrankingblacklist", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})

lia.command.add("demote", {
    adminOnly = false,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})

lia.command.add("checkpromotions", {
    syntax = "<string name>",
    adminOnly = false,
    onRun = function(client, arguments) end
})

lia.command.add("checkdemotions", {
    syntax = "<string name>",
    adminOnly = false,
    onRun = function(client, arguments) end
})

lia.command.add("coenlist", {
    adminOnly = false,
    syntax = "<string name>",
    onRun = function(client, arguments) end
})
