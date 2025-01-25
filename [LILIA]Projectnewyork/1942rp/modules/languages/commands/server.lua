local MODULE = MODULE
lia.command.add("languagegive", {
    privilege = "Management - Language Give",
    adminOnly = true,
    syntax = "<string target> <string Language>",
    onRun = function(client, arguments)
        if not arguments[2] then
            client:notify("No Language specified.")
            return false
        end

        local target = lia.command.findPlayer(client, arguments[1]) or client
        if target then
            local char = target:getChar()
            if not char then return end
            for k, v in pairs(MODULE.Languages) do
                if string.find(string.lower(v.name), string.lower(arguments[2])) then
                    local langData = char:getData("languages", {})
                    langData[v.uid] = 1
                    char:setData("languages", langData, false, player.GetAll())
                    client:notify(" You have given " .. target:GetName() .. " access to the " .. v.name .. " Language.")
                    break
                end
            end
        end
    end
})

lia.command.add("languagetake", {
    privilege = "Management - Language Take",
    adminOnly = true,
    syntax = "<string target> <string Language>",
    onRun = function(client, arguments)
        if not arguments[2] then
            client:notify("No Language specified.")
            return false
        end

        local target = lia.command.findPlayer(client, arguments[1]) or client
        if target then
            local char = target:getChar()
            if not char then return end
            for k, v in pairs(MODULE.Languages) do
                if string.find(string.lower(v.name), string.lower(arguments[2])) then
                    local langData = char:getData("languages", {})
                    langData[v.uid] = nil
                    char:setData("languages", langData, false, player.GetAll())
                    client:notify("You have removed the " .. v.name .. " Language from " .. target:GetName() .. ".")
                    break
                end
            end
        end
    end
})

lia.command.add("languagecheck", {
    privilege = "Management - Language Check",
    adminOnly = true,
    syntax = "<string target> <string Language>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1]) or client
        if not arguments[2] then
            client:notify("No Language specified.")
            return false
        end

        if target then
            local char = target:getChar()
            if not char then return end
            local langData = char:getData("languages")
            for k, v in pairs(MODULE.Languages) do
                if string.find(string.lower(v.name), string.lower(arguments[2])) then
                    if langData[v.uid] then
                        client:notify(target:GetName() .. " has access to the " .. v.name .. " Language.")
                    else
                        client:notify(target:GetName() .. " does not have access to the " .. v.name .. " Language.")
                    end

                    break
                end
            end
        end
    end
})

lia.command.add("languages", {
    onRun = function(client, arguments) netstream.Start(client, "ShowLanguages", client) end
})

lia.command.add("languagesadmin", {
    adminOnly = true,
    privilege = "View Languages",
    syntax = "<string target>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1]) or client
        if target then
            netstream.Start(client, "ShowLanguages", target)
        else
            client:notify("Invalid target.")
        end
    end
})
