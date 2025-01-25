lia.command.add(
        "advertisement",
        {
            adminOnly = false,
            privilege = "Default User Commands",
            syntax = "<string factions> <string text>",
            onRun = function(client, arguments)
                if not arguments[1] then return "Invalid argument (#1)" end
                local message = table.concat(arguments, " ", 1)
                if not client.advertdelay then client.advertdelay = 0 end
                if CurTime() < client.advertdelay then
                    client:notify("This command is in cooldown!")
                    return
                else
                        if client:getChar():hasMoney(10) then
                            client.advertdelay = CurTime() + 20
                            client:getChar():takeMoney(10)
                            client:notify("10 " .. lia.currency.plural .. " have been deducted from your wallet for advertising.")
                            net.Start("advert_client")
                            net.WriteString(client:Nick())
                            net.WriteString(message)
                            net.Broadcast()
                        else
                            client:notify("You lack sufficient funds to make an advertisement.")
                            return
                        end
                end
            end
        }
    )