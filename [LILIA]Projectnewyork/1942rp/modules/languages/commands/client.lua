lia.command.add("languagegive", {
    privilege = "Management - Language Give",
    adminOnly = true,
    syntax = "<string target> <string Language>",
    onRun = function(client, arguments) end
})

lia.command.add("languagetake", {
    privilege = "Management - Language Take",
    adminOnly = true,
    syntax = "<string target> <string Language>",
    onRun = function(client, arguments) end
})

lia.command.add("languagecheck", {
    privilege = "Management - Language Check",
    adminOnly = true,
    syntax = "<string target> <string Language>",
    onRun = function(client, arguments) end
})

lia.command.add("languages", {
    onRun = function(client, arguments) end
})

lia.command.add("languagesadmin", {
    adminOnly = true,
    privilege = "View Languages",
    syntax = "<string target>",
    onRun = function(client, arguments) end
})
