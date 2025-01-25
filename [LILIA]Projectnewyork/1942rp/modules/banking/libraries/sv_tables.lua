function MODULE:LoadData()
    local query = [[
        CREATE TABLE IF NOT EXISTS `lia_bank_logs` (
            `id` INTEGER PRIMARY KEY ]] .. (self.UseMySQL and "AUTO_INCREMENT" or "AUTOINCREMENT") .. [[,
            `account_number` INTEGER NOT NULL,
            `steamid` VARCHAR(255) NOT NULL,
            `action` INTEGER NOT NULL,
            `info` VARCHAR(255) NOT NULL
        );
    ]]
    lia.db.query(query)
    if sql.TableExists("lia_bank_logs") then
        MsgC(Color(255, 0, 0), "[BANKING] lia_bank_logs Loaded Successfully!")
    else
        MsgC(Color(255, 0, 0), "[BANKING] lia_bank_logs Failed to Load!")
    end

    local query2 = [[
        CREATE TABLE IF NOT EXISTS `lia_bank_accounts` (
            `account_number` INTEGER PRIMARY KEY ]] .. (self.UseMySQL and "AUTO_INCREMENT" or "AUTOINCREMENT") .. [[,
            `steamid` VARCHAR(255) NOT NULL,
            `balance` INTEGER NOT NULL,
            `charid` INTEGER NOT NULL,
            `itembankid` INTEGER NOT NULL
        );
    ]]
    lia.db.query(query2)
    if sql.TableExists("lia_bank_accounts") then
        MsgC(Color(255, 0, 0), "[BANKING] lia_bank_accounts Loaded Successfully!")
    else
        MsgC(Color(255, 0, 0), "[BANKING] lia_bank_accounts Failed to Load!")
    end
end

util.AddNetworkString("Banking::OpenBankGUI")
util.AddNetworkString("Banking::SendBankGUI")
util.AddNetworkString("Banking::TransmitBankGUI")
net.Receive("Banking::SendBankGUI", function(len, ply)
    if not IsValid(ply) then return end
    local charID = ply:getChar():getID()
    lia.db.query("SELECT * FROM lia_bank_accounts WHERE charid = " .. charID, function(data)
        data = data or {}
        if table.IsEmpty(data) then
            ply:notify("You do not have a bank account currently. Visit the Banker NPC to open one!")
            ply:getChar():setData("NumberofBankAccounts", 0)
            return
        end

        net.Start("Banking::TransmitBankGUI")
        net.WriteTable(data)
        net.Send(ply)
    end)
end)
