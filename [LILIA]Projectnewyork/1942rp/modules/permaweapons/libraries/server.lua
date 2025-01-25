function MODULE:PostPlayerLoadout(client)
    if not client:getChar() then return end
    local steamID64 = client:SteamID64()
    local weps = lia.config.DonatorWeapons[steamID64]
    if weps then
        for _, wep in ipairs(weps) do
            client:Give(wep)
        end
    end
end
