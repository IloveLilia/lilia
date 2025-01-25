lia.command.add("chareditpapers", {
    adminOnly = false,
    syntax = "",
    onRun = function(ply, args) netstream.Start(ply, "missingCharacteristics", "Edit your information", true) end
})
