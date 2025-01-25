local MODULE = MODULE
PIM:AddLocalOption("Surrender", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if not SERVER then return end
        if client:isNoClipping() or (IsHandcuffed(client) or client:getNetVar("restricted")) then return end
        if not client.IsSurrendered then
            MODULE:Surrender(client)
        else
            MODULE:UnSurrender(client)
        end
    end,
    runServer = true
})

PIM:AddLocalOption("Salute", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if not SERVER then return end
        if client:isNoClipping() or (IsHandcuffed(client) or client:getNetVar("restricted")) then return end
        if not client:GetNWBool("animationStatus") then
            MODULE:ToggleAnimaton(client, true, "salute_swep", 0)
        else
            MODULE:ToggleAnimaton(client, false)
            timer.Simple(0.5, function() MODULE:ToggleAnimaton(client, true, "salute_swep", 0) end)
        end
    end,
    runServer = true
})

PIM:AddLocalOption("Cross Arms", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if not SERVER then return end
        if client:isNoClipping() or (IsHandcuffed(client) or client:getNetVar("restricted")) then return end
        if not client:GetNWBool("animationStatus") then
            MODULE:ToggleAnimaton(client, true, "cross_arms_swep", 0)
        else
            MODULE:ToggleAnimaton(client, false)
            timer.Simple(0.5, function() MODULE:ToggleAnimaton(client, true, "cross_arms_swep", 0) end)
        end
    end,
    runServer = true
})

PIM:AddLocalOption("At Ease", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if not SERVER then return end
        if client:isNoClipping() or (IsHandcuffed(client) or client:getNetVar("restricted")) then return end
        if not client:GetNWBool("animationStatus") then
            MODULE:ToggleAnimaton(client, true, "atease_swep", 0)
        else
            MODULE:ToggleAnimaton(client, false)
            timer.Simple(0.5, function() MODULE:ToggleAnimaton(client, true, "atease_swep", 0) end)
        end
    end,
    runServer = true
})

PIM:AddLocalOption("Attention", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if not SERVER then return end
        if client:isNoClipping() or (IsHandcuffed(client) or client:getNetVar("restricted")) then return end
        if not client:GetNWBool("animationStatus") then
            MODULE:ToggleAnimaton(client, true, "attention_swep", 0)
        else
            MODULE:ToggleAnimaton(client, false)
            timer.Simple(0.5, function() MODULE:ToggleAnimaton(client, true, "attention_swep", 0) end)
        end
    end,
    runServer = true
})

PIM:AddLocalOption("Timed Salute", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if not SERVER then return end
        if client:isNoClipping() or (IsHandcuffed(client) or client:getNetVar("restricted")) then return end
        if not client:GetNWBool("animationStatus") then
            MODULE:ToggleAnimaton(client, true, "salute_swep", 0)
            timer.Simple(3, function() MODULE:ToggleAnimaton(client, false) end)
        else
            MODULE:ToggleAnimaton(client, false)
            timer.Simple(0.5, function() MODULE:ToggleAnimaton(client, true, "salute_swep", 0) end)
        end
    end,
    runServer = true
})