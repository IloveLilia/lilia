util.AddNetworkString("Banking::BankerCreateAccount")
net.Receive("Banking::BankerCreateAccount", function(len, client)
    local char = client:getChar()
    local charID = char:getID()
    local charBal = char:getMoney()
    local steamID = client:SteamID64()
    lia.db.query("SELECT * FROM lia_bank_accounts WHERE charid = " .. charID, function(data)
        data = data or {}
        if data ~= nil and #data >= 3 then
            client:notify("You already have the max amount of bank accounts.")
            char:setData("NumberofBankAccounts", 3)
            return
        end

        if table.IsEmpty(data) or data == nil then
            if charBal < 1000 then
                client:notify("You do not have enough to open a bank account at this time.")
                return
            else
                char:takeMoney(1000)
                client:notify("You have paid $1,000 to open your first account. Please visit an ATM!")
                local query = "INSERT INTO lia_bank_accounts (steamid, balance, charid, itembankid) VALUES (" .. steamID .. ", 0, " .. charID .. ", 0)"
                lia.db.query(query)
                char:setData("NumberofBankAccounts", 1)
                lia.log.add(client, "accountCreation")
            end
        end
    end)
end)

local PLAYER = FindMetaTable("Player")
function DeleteBankAccount(admin, bankID)
    lia.db.query("SELECT * FROM lia_bank_accounts WHERE account_number = " .. bankID, function(data)
        if table.IsEmpty(data) or data == nil then
            admin:notify("There are no accounts in the database for this player.")
            return
        end

        lia.db.query("DELETE FROM lia_bank_accounts WHERE account_number = " .. bankID)
        admin:notify("You have deleted the player's bank account.")
    end)
end
