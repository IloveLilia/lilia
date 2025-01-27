﻿ITEM.name = "Fancy Drug Base"
ITEM.desc = " "
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.duration = 1200
ITEM.functions._use = {
    name = "Use",
    icon = "icon16/pill.png",
    onRun = function(item)
        local client = item.player
        local char = client:getChar()
        if char and client:Alive() then
            if item.attribBoosts then
                for k, v in pairs(item.attribBoosts) do
                    char:addBoost(item.uniqueID, k, v)
                end
            end

            if item.drugInfo then
                local drugs = client.drug or {}
                drugs[item.id] = item.drugInfo
                client.drug = drugs
            end

            if item.hploss then client:TakeDamage(item.hploss, client, client) end
            if item.speed then
                client:SetWalkSpeed(lia.config.WalkSpeed * item.speed)
                client:SetRunSpeed(lia.config.RunSpeed * item.speed)
            end

            local charID = char:getID()
            local name = item.name
            timer.Create("DrugEffect_" .. item.uniqueID .. "_" .. client:EntIndex(), item.duration, 1, function()
                if client and IsValid(client) then
                    local curChar = client:getChar()
                    if curChar and curChar:getID() == charID then
                        client:notify(Format("%s has worn off.", name))
                        if item.attribBoosts then
                            for k, v in pairs(item.attribBoosts) do
                                char:removeBoost(item.uniqueID, k)
                            end
                        end

                        if item.drugInfo then
                            local drugs = client.drug or {}
                            drugs[item.id] = nil
                            client.drug = drugs
                        end

                        if item.speed then
                            client:SetWalkSpeed(lia.config.WalkSpeed)
                            client:SetRunSpeed(lia.config.RunSpeed)
                        end
                    end
                end
            end)
        end
    end,
    onCanRun = function(item) return not IsValid(item.entity) end
}
