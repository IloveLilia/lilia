lia.command.add("charsettitle", {
    privilege = "Characters - Set Title",
    adminOnly = true,
    syntax = "<string target> <string title>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:getChar() then
            table.remove(arguments, 1)
            local rank = table.concat(arguments, " ")
            target:getChar():setData("title", rank)
            target:setNetVar("title", rank, player.GetAll())
            client:notifyLocalized("You have set " .. target:Nick() .. "'s title to " .. rank)
            target:notifyLocalized("Your title has been set to " .. rank .. " by " .. client:Nick())
        else
            client:notifyLocalized("Invalid target!")
        end
    end
})

lia.command.add("charsetrank", {
    privilege = "Characters - Set Rank",
    adminOnly = true,
    syntax = "<string target>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:getChar() and target:IsPlayerInRankedFaction() then
            netstream.Start(client, "OpenRankSelectionUI", target)
        else
            client:notify("This character isn't on a ranked faction!")
        end
    end
})

lia.command.add("toggletitle", {
    adminOnly = false,
    onRun = function(client, arguments)
        local character = client:getChar()
        local HasTitleToggled = character:getData("TitleToggled", true)
        character:setData("TitleToggled", not HasTitleToggled)
    end
})

lia.command.add("togglerank", {
    adminOnly = false,
    onRun = function(client, arguments)
        local character = client:getChar()
        local HasRankToggled = character:getData("RankToggled", true)
        character:setData("RankToggled", not HasRankToggled)
    end
})

lia.command.add("chartoggletitle", {
    syntax = "<string name>",
    privilege = "Characters - Toggle Title",
    adminOnly = true,
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        local character = target:getChar()
        local HasTitleToggled = character:getData("TitleToggled", true)
        character:setData("TitleToggled", not HasTitleToggled)
        client:notify("You have toggled " .. target:GetName() .. " title display !")
    end
})

lia.command.add("chartogglerank", {
    privilege = "Characters - Toggle Rank",
    syntax = "<string name>",
    adminOnly = true,
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        local character = target:getChar()
        local HasRankToggled = character:getData("RankToggled", true)
        character:setData("RankToggled", not HasRankToggled)
        client:notify("You have toggled " .. target:GetName() .. " rank display !")
    end
})

lia.command.add("promote", {
    syntax = "<string name>",
    adminOnly = false,
    onRun = function(client, arguments)
        if client:isRankingBlacklisted() then client:ChatPrint("You can't do this!") end
        local target = client:GetTracedEntity()
        if IsValid(target) and target:IsPlayer() and target:getChar() then
            Promote(client, target)
        else
            client:ChatPrint("Invalid target. Please aim at a suitable player.")
        end
    end
})

lia.command.add("cotransfer", {
    adminOnly = false,
    syntax = "<string name>",
    onRun = function(client, arguments)
        if client:isRankingBlacklisted() then client:ChatPrint("You can't do this!") end
        local target = client:GetTracedEntity()
        if client:CanTransfer(target) and IsValid(target) and target:IsPlayer() and target:getChar() then
            if client.TransferRequested or target.TransferRequested then
                client:ChatPrint("A transfer request is already pending.")
                return
            end

            if client:GetPos():DistToSqr(target:GetPos()) > 250 * 250 then
                client:ChatPrint("You are too far away from the target player.")
                return
            end

            if os.time() < target:getChar():getData("lastCoTransfer", 0) then
                client:ChatPrint("This Character Has Transfer Cooldown!")
                return
            end

            net.Start("RequestTransfer")
            net.Send(target)
            client.TransferRequested = target
            target.TransferRequested = client
        else
            client:ChatPrint("Invalid target. Please aim at a suitable player.")
        end
    end
})

lia.command.add("resettransfercooldown", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:IsPlayer() and target:getChar() then
            target:getChar():setData("lastCoTransfer", 0)
            client:ChatPrint("This Character Had His Transfer Cooldown Resetted!")
        end
    end
})

lia.command.add("resetpromotecooldown", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:IsPlayer() and target:getChar() then
            target:getChar():setData("promotionCooldownReset", true)
            client:ChatPrint("This Character Had His Promotion Cooldown Resetted!")
        end
    end
})

lia.command.add("rankingblacklist", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:IsPlayer() and target:getChar() and not target:getLiliaData("rankingBlacklisted", false) then target:setLiliaData("rankingBlacklisted", true) end
    end
})

lia.command.add("unrankingblacklist", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:IsPlayer() and target:getChar() and target:getLiliaData("rankingBlacklisted", false) then target:setLiliaData("rankingBlacklisted", false) end
    end
})

lia.command.add("demote", {
    adminOnly = false,
    syntax = "<string name>",
    onRun = function(client, arguments)
        if client:isRankingBlacklisted() then client:ChatPrint("You can't do this!") end
        local target = client:GetTracedEntity()
        if IsValid(target) and target:IsPlayer() and target:getChar() then
            Demote(client, target)
        else
            client:ChatPrint("Invalid target. Please aim at a suitable player.")
        end
    end
})

lia.command.add("checkpromotions", {
    syntax = "<string name>",
    adminOnly = false,
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        local RankInfo = client:GetPlayerRankData()
        if not target then target = client end
        if CAMI.PlayerHasAccess(client, "Characters - Check Promotions") or (client:IsPlayerInRankedFaction() and RankInfo.CanCheckPromotions) then
            PrintPromotions(client, target)
        else
            client:ChatPrint("No permission to check demotions!")
        end
    end
})

lia.command.add("checkdemotions", {
    syntax = "<string name>",
    adminOnly = false,
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        local RankInfo = client:GetPlayerRankData()
        if not target then target = client end
        if CAMI.PlayerHasAccess(client, "Management - Check Demotions") or (client:IsPlayerInRankedFaction() and RankInfo.CanCheckDemotions) then
            PrintDemotions(client, target)
        else
            client:ChatPrint("No permission to check demotions!")
        end
    end
})

lia.command.add("coenlist", {
    adminOnly = false,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = client:GetTracedEntity()
        if IsValid(target) and target:IsPlayer() and target:getChar() then
            if client.EnlistRequested or target.EnlistRequested then
                client:ChatPrint("A enlist request is already pending.")
                return
            end

            if client:GetPos():DistToSqr(target:GetPos()) > 250 * 250 then
                client:ChatPrint("You are too far away from the target player.")
                return
            end

            net.Start("RequestEnlist")
            net.Send(target)
            client.EnlistRequested = target
            target.EnlistRequested = client
        else
            client:ChatPrint("Invalid target. Please aim at a suitable player.")
        end
    end
})
