function MODULE:EntityTakeDamage(client, dmgInfo)
    if dmgInfo:GetDamageType() == DMG_FALL and client:IsPlayer() and not client:getChar():getData("leg_broken", false) and dmgInfo:GetDamage() >= lia.config.DamageThresholdOnFallBreak then
        client:ChatPrint("You broke your leg by falling")
        client:getChar():setData("leg_broken", true)
        client:SetWalkSpeed(lia.config.WalkSpeed * lia.config.BrokenLegSlowMultiplier)
        client:SetRunSpeed(lia.config.RunSpeed * lia.config.BrokenLegSlowMultiplier)
    end
end

function MODULE:CheckForBrokenLeg(client, hitgroup, dmgInfo)
    local chance = math.random(1, 100)
    if chance <= lia.config.ChanceToBreakLegByShooting and table.HasValue(lia.config.LegHitgroups, hitgroup) then
        client:ChatPrint("You broke your leg by being shot")
        client:getChar():setData("leg_broken", true)
        client:SetWalkSpeed(lia.config.WalkSpeed * lia.config.BrokenLegSlowMultiplier)
        client:SetRunSpeed(lia.config.RunSpeed * lia.config.BrokenLegSlowMultiplier)
    end
end

function MODULE:ScalePlayerDamage(client, hitgroup, dmgInfo)
    local BleedingChecker = math.random(1, 100)
    local attacker = dmgInfo:GetAttacker()
    if IsValid(attacker) and attacker:IsPlayer() then
        local activeWeapon = attacker:GetActiveWeapon()
        if IsValid(activeWeapon) then
            local baseBleedingChance = lia.config.BaseBleedingChance
            if baseBleedingChance > BleedingChecker and not client:GetNWBool("Bleeding", false) then self:InitalizeBleeding(client) end
            if not client:getChar():getData("leg_broken", false) then self:CheckForBrokenLeg(client, hitgroup, dmgInfo) end
        end
    else
        local baseBleedingChance = lia.config.BaseBleedingChance
        if baseBleedingChance > BleedingChecker and not client:GetNWBool("Bleeding", false) then self:InitalizeBleeding(client) end
        if not client:getChar():getData("leg_broken", false) then self:CheckForBrokenLeg(client, hitgroup, dmgInfo) end
    end
end

function MODULE:PlayerDeath(client)
    if not client:getChar() then return end
    self:ResetStats(client)
end

function MODULE:PlayerSpawn(client)
    if not client:getChar() then return end
    self:ResetStats(client)
end

function MODULE:ResetStats(client)
    client:SetWalkSpeed(lia.config.WalkSpeed)
    client:SetRunSpeed(lia.config.RunSpeed)
    client:getChar():setData("leg_broken", false)
    client:SetNWInt("blood", 100)
    client:SetNWBool("Bleeding", false)
    client:SetNWBool("BleedingBandaged", false)
    client:SetNWInt("LastMorphine")
    client:SetNWBool("DidntUseMorphineProperly")
    client:SetNWBool("UsedMorphineProperly")
    timer.Remove("BleedingTimer" .. client:SteamID64())
end

function MODULE:RemoveBleeding(client)
    client:SetNWBool("Bleeding", false)
    client:SetNWBool("BleedingBandaged", false)
    client:SetNWInt("LastMorphine")
    client:SetNWBool("DidntUseMorphineProperly")
    client:SetNWBool("UsedMorphineProperly")
    timer.Remove("BleedingTimer" .. client:SteamID64())
end

function MODULE:RemoveFracture(client)
    client:SetWalkSpeed(lia.config.WalkSpeed)
    client:SetRunSpeed(lia.config.RunSpeed)
    client:getChar():setData("leg_broken", false)
end

function MODULE:RemoveFracture(client)
    client:SetWalkSpeed(lia.config.WalkSpeed)
    client:SetRunSpeed(lia.config.RunSpeed)
    client:getChar():setData("leg_broken", false)
end

function MODULE:InitalizeBleeding(client)
    client:SetNWBool("Bleeding", true)
    timer.Create("BleedingTimer" .. client:SteamID64(), lia.config.BleedingTickTimer, 0, function()
        if client:Health() - lia.config.BleedingAmount <= 0 then
            client:Kill()
        else
            client:SetHealth(client:Health() - lia.config.BleedingAmount)
        end

        if client:GetNWInt("blood", 100) - lia.config.BleedingAmount <= 0 then
            client:Kill()
        else
            client:SetNWInt("blood", client:GetNWInt("blood", 100) - lia.config.BleedingAmount)
        end

        client:ChatPrint("You're bleeding. Use a bandage to stop the bleeding and a blood bag to restore you to a healthy condition!")
    end)
end
