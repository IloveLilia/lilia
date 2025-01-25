PIM:AddOption("Request Search", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and not target.SearchRequested and not client.SearchRequested end,
    onRun = function(client, target)
        if not SERVER then return end
        net.Start("RequestSearch")
        net.Send(target)
        client:notify("Request to search sent.")
        target.SearchRequested = client
        client.SearchRequested = target
    end
})

PIM:AddOption("Gag", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and not IsGagged(target) end,
    onRun = function(client, target)
        if not SERVER then return end
        target:setNetVar("gagged", true)
    end
})

PIM:AddOption("Un-Gag", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and IsGagged(target) end,
    onRun = function(client, target)
        if not SERVER then return end
        target:setNetVar("gagged", false)
    end
})

PIM:AddOption("Blindfold", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and not IsBlinded(target) end,
    onRun = function(client, target)
        if not SERVER then return end
        target:setNetVar("blinded", true)
    end
})

PIM:AddOption("Removed Blindfold", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and IsBlinded(target) end,
    onRun = function(client, target)
        if not SERVER then return end
        target:setNetVar("blinded", false)
    end
})
