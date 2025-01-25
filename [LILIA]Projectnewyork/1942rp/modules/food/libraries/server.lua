local MODULE = MODULE
local HungerthinkTime = 0
local ThristthinkTime = 0
function MODULE:CharPreSave(character)
    local savedHunger = character.player:getHunger()
    local savedThrist = character.player:getThrist()
    character:setData("hunger", savedHunger)
    character:setData("thrist", savedThrist)
end

function MODULE:PlayerLoadedChar(client, character, lastChar)
    if character:getData("hunger", 100) then
        client:setNetVar("hunger", character:getData("hunger"))
    else
        client:setNetVar("hunger", 100)
    end

    if character:getData("thrist", 100) then
        client:setNetVar("thrist", character:getData("thrist"))
    else
        client:setNetVar("thrist", 100)
    end
end

function MODULE:PlayerSpawn(client)
    if not client:getChar() then return end
    if self.RefillHungerOnDeath then client:setNetVar("hunger", 100) end
    if self.RefillThristOnDeath then client:setNetVar("thrist", 100) end
end

function MODULE:PlayerPostThink(client)
    if not client:getChar() then return end
    if HungerthinkTime < CurTime() then
        --    client:ChatPrint("RAN HUNGER" .. " " .. client:getHunger())
        if client:getHunger() <= 0 then
            client:notify("You are starving.")
            client:EmitSound("vo/npc/male01/moan01.wav")
            if client:Alive() and client:Health() <= 0 then
                client:Kill()
            else
                client:SetHealth(math.Clamp(client:Health() - self.StarvingDamage, 0, client:GetMaxHealth()))
            end

            HungerthinkTime = CurTime() + self.StarvingTimer
        else
            client:addHunger(-1)
            HungerthinkTime = CurTime() + self.HungerTimer
        end
    end

    if ThristthinkTime < CurTime() then
        -- client:ChatPrint("RAN THIRST" .. " " .. client:getThrist())
        if client:getThrist() <= 0 then
            client:notify("You are dehydrated.")
            client:EmitSound("vo/npc/male01/moan01.wav")
            if client:Alive() and client:Health() <= 0 then
                client:Kill()
            else
                client:SetHealth(math.Clamp(client:Health() - self.DehydratationDamage, 0, client:GetMaxHealth()))
            end

            ThristthinkTime = CurTime() + self.DehydratationTimer
        else
            client:addThrist(-1)
            ThristthinkTime = CurTime() + self.ThristTimer
        end
    end
end
