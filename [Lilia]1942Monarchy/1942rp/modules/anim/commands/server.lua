--------------------------------------------------------------------------------------------------------
local MODULE = MODULE
--------------------------------------------------------------------------------------------------------
lia.command.add(
    "surrender",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "surrender_animation_swep", 0)
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "surrender_animation_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "salute",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "salute_swep", 0)
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "salute_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "crossarms",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "cross_arms_swep", 0)
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "cross_arms_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "atease",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "atease_swep", 0)
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "atease_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "attention",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "attention_swep", 0)
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "attention_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "timedsalute",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "salute_swep", 0)
                timer.Simple(
                    3,
                    function()
                        MODULE:ToggleAnimaton(client, false)
                    end
                )
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "salute_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "surrender",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            if not client:GetNWBool("animationStatus") then
                MODULE:ToggleAnimaton(client, true, "surrender_swep", 0)
                timer.Simple(
                    3,
                    function()
                        MODULE:ToggleAnimaton(client, false)
                    end
                )
            else
                MODULE:ToggleAnimaton(client, false)
                timer.Simple(
                    0.5,
                    function()
                        MODULE:ToggleAnimaton(client, true, "surrender_swep", 0)
                    end
                )
            end
        end
    }
)

--------------------------------------------------------------------------------------------------------
lia.command.add(
    "anim",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char or client:GetMoveType() == MOVETYPE_NOCLIP or (IsHandcuffed(client) or client:getNetVar("ziptied")) then return end
            net.Start("OpenCommandUI")
            net.Send(client)
        end
    }
)
--------------------------------------------------------------------------------------------------------