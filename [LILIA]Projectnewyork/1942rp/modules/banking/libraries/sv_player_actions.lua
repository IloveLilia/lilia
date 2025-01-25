local MODULE = MODULE
util.AddNetworkString("Banking::PlayerBankDeposit")
util.AddNetworkString("Banking::SendLogs")
util.AddNetworkString("Banking::ViewLogs")
net.Receive("Banking::PlayerBankDeposit", function(len, client)
    local amount = net.ReadUInt(32)
    local bankID = net.ReadUInt(32)
    local char = client:getChar()
    client.AntiSpam = client.AntiSpam or CurTime()
    local timeRemaining = client.AntiSpam - CurTime()
    if client.AntiSpam > CurTime() then
        client:notify("You must wait 10 seconds to deposit money into your bank account. You must wait " .. math.ceil(timeRemaining) .. " more second(s).")
        return
    end

    client.AntiSpam = CurTime() + 10
    if char:hasMoney(amount) then
        lia.db.query("SELECT * FROM lia_bank_accounts WHERE account_number = " .. bankID, function(data)
            if table.IsEmpty(data) or data == nil then
                client:notify("There are no bank accounts with that account number. Please try again.")
                return
            end

            for _, accountData in ipairs(data) do
                local SenderSteamID = client:SteamID64()
                if SenderSteamID ~= accountData.steamid then
                    client:notify("This bank account does not belong to you.")
                    return
                end

                local prevBalance = accountData.balance
                local newBalance = prevBalance + amount
                -- Check if the new balance exceeds the maximum limit
                if newBalance > MODULE.MoneyLimit then
                    local excessAmount = newBalance - MODULE.MoneyLimit
                    newBalance = MODULE.MoneyLimit
                    client:getChar():giveMoney(excessAmount) -- Return the excess amount to the player
                    client:notify("Only $" .. (amount - excessAmount) .. " was deposited into your bank account. $" .. excessAmount .. " was returned to you as it exceeds the bank limit of " .. MODULE.MoneyLimit .. ".")
                else
                    client:notify("$" .. amount .. " was deposited into your bank account.")
                end

                -- Update the bank account balance in the database
                lia.db.query("UPDATE lia_bank_accounts SET balance = " .. newBalance .. " WHERE account_number = " .. bankID)
                net.Start("Banking::ReceiveBankBalance")
                net.WriteUInt(newBalance, 32)
                net.Send(client)
                lia.log.add(client, "deposit", amount)
                recordTransaction(bankID, amount, "deposit", nil, client:Name())
                char:takeMoney(amount - (newBalance - prevBalance))
                return
            end
        end)
    else
        client:notify("You do not have enough money to cover this deposit.")
    end
end)

util.AddNetworkString("liaDrawBankLogs")
function MODULE:RequestBankLogs(client, charID)
    if charID then
        lia.db.query("SELECT * FROM lia_bank_accounts WHERE charid = " .. charID, function(data)
            net.Start("liaDrawBankLogs")
            net.WriteTable(data)
            net.Send(client)
        end)
    else
        lia.db.query("SELECT * FROM lia_bank_accounts", function(data)
            net.Start("liaDrawBankLogs")
            net.WriteTable(data)
            net.Send(client)
        end)
    end
end

util.AddNetworkString("Banking::PlayerBankWithdraw")
net.Receive("Banking::PlayerBankWithdraw", function(len, client)
    local amount = net.ReadUInt(32)
    local bankID = net.ReadUInt(32)
    local char = client:getChar()
    client.AntiSpam = client.AntiSpam or CurTime()
    local timeRemaining = client.AntiSpam - CurTime()
    if client.AntiSpam > CurTime() then
        client:notify("You must wait 10 seconds to withdraw money from your bank account. You must wait " .. math.ceil(timeRemaining) .. " more second(s).")
        return
    end

    client.AntiSpam = CurTime() + 10
    lia.db.query("SELECT * from lia_bank_accounts WHERE account_number = " .. bankID, function(data)
        if table.IsEmpty(data) or data == nil then return end
        for account, data in ipairs(data) do
            local SenderSteamID = client:SteamID64()
            if SenderSteamID ~= data.steamid then return end
            local bal = data.balance
            local newBalance = bal - amount
            print(bal, amount)
            if tonumber(bal) >= tonumber(amount) then
                lia.db.query("UPDATE lia_bank_accounts SET balance = " .. newBalance .. " WHERE account_number = " .. bankID)
                char:giveMoney(amount)
                client:notify("$" .. amount .. " was withdrawn from your bank account.")
                net.Start("Banking::ReceiveBankBalance")
                net.WriteUInt(newBalance, 32)
                net.Send(client)
                lia.log.add(client, "withdrawal", amount)
                recordTransaction(bankID, amount, "withdrawal", nil, client:Name())
            else
                client:notify("You do not have the money available in your bank account to withdraw this amount. Try a lower amount.")
            end
        end
    end)
end)

util.AddNetworkString("Banking::PlayerBankTransfer")
net.Receive("Banking::PlayerBankTransfer", function(len, client)
    local bankID = net.ReadUInt(32)
    local account_number = net.ReadUInt(32)
    local amount = net.ReadUInt(32)
    local char = client:getChar()
    -- Anti-spam check
    client.AntiSpam = client.AntiSpam or CurTime()
    local timeRemaining = client.AntiSpam - CurTime()
    if client.AntiSpam > CurTime() then
        client:notify("You must wait 10 seconds before attempting another transfer. You must wait " .. math.ceil(timeRemaining) .. " more second(s).")
        return
    end

    client.AntiSpam = CurTime() + 10
    -- Fetch sender's bank account data
    lia.db.query("SELECT * FROM lia_bank_accounts WHERE account_number = " .. bankID, function(senderData)
        if table.IsEmpty(senderData) or senderData == nil then return end
        local sender = senderData[1]
        local senderSteamID = client:SteamID64()
        if senderSteamID ~= sender.steamid then
            client:notify("You are not authorized to access this account.")
            return
        end

        local currentSenderBalance = sender.balance
        local newSenderBalance = currentSenderBalance - amount
        if newSenderBalance < 0 then
            client:notify("You do not have enough money in your bank account to make this transfer. Try a lower amount.")
            return
        end

        -- Fetch receiver's bank account data
        lia.db.query("SELECT * FROM lia_bank_accounts WHERE account_number = " .. account_number, function(receiverData)
            if table.IsEmpty(receiverData) or receiverData == nil then
                client:notify("There are no accounts with that account number. Please try again.")
                return
            end

            local receiver = receiverData[1]
            local receiverSteamID = receiver.steamid
            if senderSteamID == receiverSteamID then
                client:notify("You can't send a transfer to an account you own.")
                return
            end

            local maxBankLimit = MODULE.MoneyLimit or 0
            local limitOverrideSender = hook.Run("WalletLimit", client)
            local limitOverrideReceiver = hook.Run("WalletLimit", receiverSteamID)
            if limitOverrideSender then maxBankLimit = limitOverrideSender end
            if limitOverrideReceiver then maxBankLimit = limitOverrideReceiver end
            -- Check sender's new balance against the bank limit
            if maxBankLimit > 0 and newSenderBalance > maxBankLimit then
                client:notify("Your bank account limit has been exceeded. Please try a lower amount.")
                return
            end

            -- Calculate the receiver's new balance
            local newReceiverBalance = receiver.balance + amount
            if maxBankLimit > 0 and newReceiverBalance > maxBankLimit then
                local excessAmount = newReceiverBalance - maxBankLimit
                newReceiverBalance = maxBankLimit
                -- Adjust the sender's balance by the amount of excess
                newSenderBalance = newSenderBalance + excessAmount
                client:notify("The recipient's bank account limit has been exceeded. Only $" .. (amount - excessAmount) .. " was transferred. $" .. excessAmount .. " was returned to you.")
            end

            -- Update the bank account balances in the database
            lia.db.query("UPDATE lia_bank_accounts SET balance = " .. newSenderBalance .. " WHERE account_number = " .. bankID)
            lia.db.query("UPDATE lia_bank_accounts SET balance = " .. newReceiverBalance .. " WHERE account_number = " .. account_number)
            client:notify("You have transferred $" .. amount .. " to account #" .. account_number .. " successfully.")
            -- Notify the client with the updated balance
            net.Start("Banking::ReceiveBankBalance")
            net.WriteUInt(newSenderBalance, 32)
            net.Send(client)
            -- Log the transaction
            lia.log.add(client, "transfer", amount, account_number)
            recordTransaction(bankID, amount, "transfer", account_number, client:Name())
        end)
    end)
end)

util.AddNetworkString("Banking::PlayerOpenItemBank")
net.Receive("Banking::PlayerOpenItemBank", function(len, client)
    local BankAccountNumber = net.ReadUInt(32)
    client.itemBankVIP = false
    lia.db.query("SELECT * FROM lia_bank_accounts WHERE account_number = " .. BankAccountNumber, function(data)
        if table.IsEmpty(data) then return end
        if client:isVIP() then client.itemBankVIP = true end
        for account, data in ipairs(data) do
            local BankInv = client:getChar():getData("bankID" .. BankAccountNumber)
            if BankInv == nil then
                if not client:isVIP() then
                    lia.inventory.instance("grid", {
                        w = MODULE.ItemBankWidth,
                        h = MODULE.ItemBankHeight
                    }):next(function(inventory)
                        if not inventory.receivers then
                            inventory.receivers = {}
                            table.insert(inventory.receivers, client)
                        end

                        if inventory.receivers[client] then return true end
                        local function allowclientAccess(inv, action, context)
                            if context.client == client then return true end
                        end

                        inventory:addAccessRule(allowclientAccess, 1)
                        inventory:sync(client)
                        local inventoryID = inventory:getID()
                        client:getChar():setData("bankID" .. BankAccountNumber, inventoryID)
                        lia.db.query("UPDATE lia_bank_accounts SET itembankid = " .. inventoryID .. " WHERE account_number = " .. BankAccountNumber)
                        netstream.Start(client, "OpenItemBank", inventoryID)
                    end)
                else
                    lia.inventory.instance("grid", {
                        w = MODULE.ItemBankVIPWidth,
                        h = MODULE.ItemBankVIPHeight
                    }):next(function(inventory)
                        if not inventory.receivers then
                            inventory.receivers = {}
                            table.insert(inventory.receivers, client)
                        end

                        if inventory.receivers[client] then return true end
                        local function allowclientAccess(inv, action, context)
                            if context.client == client then return true end
                        end

                        inventory:addAccessRule(allowclientAccess, 1)
                        inventory:sync(client)
                        local inventoryID = inventory:getID()
                        client:getChar():setData("bankID" .. BankAccountNumber, inventoryID)
                        lia.db.query("UPDATE lia_bank_accounts SET itembankid = " .. inventoryID .. " WHERE account_number = " .. BankAccountNumber)
                        netstream.Start(client, "OpenItemBank", inventoryID)
                        lia.log.add(client, "openbank")
                    end)
                end
            else -- Inventory has been created already and exists.
                lia.inventory.loadByID(BankInv):next(function(inventory)
                    if inventory then
                        inventory:setSize(client.itemBankVIP and MODULE.ItemBankVIPWidth or MODULE.ItemBankHeight, client.itemBankVIP and MODULE.ItemBankVIPHeight or MODULE.ItemBankHeight)
                        if not inventory.receivers then
                            inventory.receivers = {}
                            table.insert(inventory.receivers, client)
                        end

                        if inventory.receivers[client] then return true end
                        local function allowclientAccess(inv, action, context)
                            if context.client == client then return true end
                        end

                        inventory:addAccessRule(allowclientAccess, 1)
                        inventory:sync(client)
                        inventory.isExternalInventory = true
                        netstream.Start(client, "OpenItemBank", BankInv)
                        lia.log.add(client, "openbank")
                    end
                end)
            end
        end
    end)
end)

function recordTransaction(accountNumber, amount, transactionType, targetAccountNumber, name)
    local fileName = "lilia/" .. engine.ActiveGamemode() .. "/banklogs/" .. accountNumber .. ".txt"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = ""
    if transactionType == "deposit" then
        logMessage = string.format("%s has deposited $%d.", name, amount)
    elseif transactionType == "withdrawal" then
        logMessage = string.format("%s has withdrawn $%d.", name, amount)
    elseif transactionType == "transfer" then
        logMessage = string.format("%s has transferred $%d to account #%s.", name, amount, targetAccountNumber)
    end

    local transactionInfo = string.format("[%s] %s\n", timestamp, logMessage)
    file.Append(fileName, transactionInfo)
end

function MODULE:InitializedModules()
    file.CreateDir("lilia/" .. engine.ActiveGamemode() .. "/banklogs")
end

net.Receive("Banking::ViewLogs", function(len, client)
    local accountNumber = net.ReadString()
    local fileName = "lilia/" .. engine.ActiveGamemode() .. "/banklogs/" .. accountNumber .. ".txt"
    local logs = {}
    if file.Exists(fileName, "DATA") then
        local fileContent = file.Read(fileName, "DATA")
        for line in fileContent:gmatch("[^\r\n]+") do
            local timestamp, message = line:match("%[(.-)%]%s(.+)")
            if timestamp and message then
                table.insert(logs, {
                    timestamp = timestamp,
                    message = message
                })
            end
        end
    end

    net.Start("Banking::SendLogs")
    net.WriteTable(logs)
    net.Send(client)
end)

local PROHIBITED_ACTIONS = {
    ["Equip"] = true,
    ["EquipUn"] = true,
}

function MODULE:CanPlayerInteractItem(client, action, itemObject, data)
    local inventory = lia.inventory.instances[itemObject.invID]
    if inventory and inventory.isExternalInventory == true and PROHIBITED_ACTIONS[action] then return false, "forbiddenActionStorage" end
end

lia.log.addType("accountCreation", function(client) return string.format("%s has created a new bank account.", client:Name()) end, "Banking", Color(52, 152, 219), "Banking")
lia.log.addType("openbank", function(client) return string.format("%s has opened the bank storage.", client:Name()) end, "Banking", Color(52, 152, 219), "Banking")
lia.log.addType("accountDeletion", function(client) return string.format("%s has deleted their account.", client:Name()) end, "Banking", Color(52, 152, 219), "Banking")
lia.log.addType("deposit", function(client, amount)
    amount = amount or 0
    return string.format("[%s] [%s] %s has deposited $%d.", client:SteamID(), client:getChar():getID(), client:Name(), amount)
end, "Banking", Color(52, 152, 219), "Banking")

lia.log.addType("withdrawal", function(client, amount)
    amount = amount or 0
    return string.format("[%s] [%s] %s has withdrawn $%d.", client:SteamID(), client:getChar():getID(), client:Name(), amount)
end, "Banking", Color(52, 152, 219), "Banking")

lia.log.addType("transfer", function(client, amount, targetAccountNumber)
    amount = amount or 0
    return string.format("%s has transferred $%d to account #%s.", client:Name(), amount, targetAccountNumber)
end, "Banking", Color(52, 152, 219), "Banking")
