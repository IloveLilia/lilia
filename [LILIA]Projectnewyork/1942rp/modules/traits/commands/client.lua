lia.command.add("traitgive", {
    privilege = "Management - Trait Give",
    adminOnly = true,
    syntax = "<string target> <string Trait>",
    onRun = function(client, arguments) end
})

lia.command.add("traittake", {
    privilege = "Management - Trait Take",
    adminOnly = true,
    syntax = "<string target> <string Trait>",
    onRun = function(client, arguments) end
})

lia.command.add("traitcheck", {
    privilege = "Management - Trait Check",
    adminOnly = true,
    syntax = "<string target> <string Trait>",
    onRun = function(client, arguments) end
})

lia.command.add("traits", {
    privilege = "Default User Commands",
    onRun = function(client, arguments) end
})

lia.command.add("traitsadmin", {
    adminOnly = true,
    privilege = "View traits",
    syntax = "<string target>",
    onRun = function(client, arguments) end
})
