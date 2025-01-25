ITEM.name = "Cyanide Pill"
ITEM.desc = "A cyanide pill is a small, lethal capsule containing cyanide, a highly toxic chemical compound. When ingested, it rapidly releases cyanide ions into the bloodstream, leading to severe disruption of cellular respiration and almost instant death. Handle with extreme caution."
ITEM.model = "models/spec45as/stalker/items/antirad.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 250
ITEM.category = "Consumables"
ITEM.functions.Use = {
    name = "Consume",
    tip = "Consume the pill.",
    icon = "icon16/pill.png",
    onCanRun = function(item) return not IsValid(item.entity) end,
    onRun = function(item)
        local client = item.player
        local character = client:getChar()
        if character then
            -- Bite phase
            lia.chat.send(client, "me", "bites down on a Cyanide Pill.")
            -- Slow down player's movement speed
            local originalWalkSpeed = client:GetWalkSpeed()
            client:SetWalkSpeed(originalWalkSpeed * 0.5) -- Walking Speed
            client:SetRunSpeed(originalWalkSpeed * 0.5) -- Sprint Speed
            -- Remove player's weapons
            client:StripWeapons()
            -- Coughing phase
            timer.Simple(5, function()
                if IsValid(client) then
                    lia.chat.send(client, "me", "starts coughing violently.")
                    client:EmitSound("ambient/voices/cough" .. math.random(1, 4) .. ".wav") -- Adjust the path and file name according to your sound file
                end
            end)

            -- Death phase
            timer.Simple(10, function()
                if IsValid(client) then
                    client:Kill()
                    lia.chat.send(client, "me", "collapses to the floor, lifeless.")
                end
            end)

            -- Banning phase
            timer.Simple(15, function()
                if IsValid(client) then
                    character:ban()
                    client:ChatPrint("You have consumed the cyanide pill, resulting in permanent death of your character.")
                end
            end)

            -- Reset player's movement speed after a delay
            timer.Simple(16, function()
                if IsValid(client) then
                    client:SetWalkSpeed(originalWalkSpeed)
                    client:SetRunSpeed(originalWalkSpeed)
                end
            end)
        end
        return true
    end
}

-- 1 x 1
if CLIENT then
    function ITEM:paintOver(item, w, h)
        -- Top
        surface.SetDrawColor(179, 0, 0)
        surface.DrawRect(w - 48, h - 48, 48, 3)
        -- Bottom
        surface.SetDrawColor(179, 0, 0)
        surface.DrawRect(w - 48, h - 3, 48, 3)
        -- Right
        surface.SetDrawColor(179, 0, 0)
        surface.DrawRect(w - 3, h - 48, 3, 48)
        -- Left
        surface.SetDrawColor(179, 0, 0)
        surface.DrawRect(w - 48, h - 48, 3, 48)
    end
end
