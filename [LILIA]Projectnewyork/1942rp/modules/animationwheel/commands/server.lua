lia.command.add("printgestures", {
    adminOnly = false,
    onRun = function()
        local entity = client:GetTracedEntity()
        ReturnModelGestures(entity)
    end
})

lia.command.add("animationwheel", {
    adminOnly = false,
    onRun = function(client)
        net.Start("OpenGestureWheel")
        net.Send(client)
    end
})