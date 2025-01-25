local PLAYER = FindMetaTable("Player")
util.AddNetworkString("Banking::GetBankBalance")
util.AddNetworkString("Banking::ReceiveBankBalance")
util.AddNetworkString("Banking::OpenBankerUI")
net.Receive("Banking::GetBankBalance", function(len, client)
    local bankID = net.ReadUInt(32)
    lia.db.query("SELECT * FROM lia_bank_accounts WHERE account_number = " .. bankID, function(data)
        if table.IsEmpty(data) or data == nil then return end
        for account, data in ipairs(data) do
            local SenderSteamID = client:SteamID64()
            if SenderSteamID ~= data.steamid then return end
            local bankBalance = data.balance
            net.Start("Banking::ReceiveBankBalance")
            net.WriteUInt(bankBalance, 32)
            net.Send(client)
        end
    end)
end)
