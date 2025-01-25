if not PIM then return end
PIM:AddOption("Force See ID", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and target:IsPlayer() and target:getChar() end,
    onRun = function(client, target)
        if not SERVER then return end
        netstream.Start(client, "OpenID", target)
        client:getChar():recognize(target:getChar())
    end
})

PIM:AddOption("Show ID", {
    runServer = true,
    shouldShow = function(client, target) return target:IsPlayer() and target:getChar() end,
    onRun = function(client, target)
        if not SERVER then return end
        netstream.Start(target, "OpenID", client)
        target:getChar():recognize(client:getChar())
    end
})

PIM:AddOption("Request ID", {
    runServer = true,
    shouldShow = function(client, target) return IsHandcuffed(target) and not target.IDRequested and not client.IDRequested end,
    onRun = function(client, target)
        if not SERVER then return end
        net.Start("RequestID")
        net.Send(target)
        client:notify("Request to View ID sent.")
        target.IDRequested = client
        client.IDRequested = target
    end
})

PIM:AddLocalOption("See ID", {
    shouldShow = function(client) return client:getChar() end,
    onRun = function(client)
        if not SERVER then return end
        netstream.Start(client, "OpenID", client)
    end,
    runServer = true
})
