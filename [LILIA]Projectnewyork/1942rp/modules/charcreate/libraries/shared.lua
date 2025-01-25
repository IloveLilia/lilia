lia.char.registerVar("descgenerator", {
    field = "_descgenerator",
    default = "[]",
    isLocal = false,
    noDisplay = false,
    onValidate = function(data) return true end
})

lia.char.registerVar("model", {
    field = "_model",
    default = "models/error.mdl",
    onSet = function(character, value)
        local oldVar = character:getModel()
        local client = character:getPlayer()
        if IsValid(client) and client:getChar() == character then client:SetModel(value) end
        character.vars.model = value
        netstream.Start(nil, "charSet", "model", character.vars.model, character:getID())
        hook.Run("PlayerModelChanged", client, value)
        hook.Run("OnCharVarChanged", character, "model", oldVar, value)
    end,
    onGet = function(character, default) return character.vars.model or default end,
    index = 3,
    onDisplay = function(panel, y)
        local scroll = panel:Add("DScrollPanel")
        scroll:SetSize(panel:GetWide(), 260)
        scroll:SetPos(0, y)
        local layout = scroll:Add("DIconLayout")
        layout:Dock(FILL)
        layout:SetSpaceX(1)
        layout:SetSpaceY(1)
        local faction = lia.faction.indices[panel.faction]
        if faction then
            for k, v in SortedPairs(faction.models) do
                local icon = layout:Add("SpawnIcon")
                icon:SetSize(64, 128)
                icon:InvalidateLayout(true)
                icon.DoClick = function() panel.payload.model = k end
                icon.PaintOver = function(_, w, h)
                    if panel.payload.model == k then
                        local color = lia.config.Color
                        surface.SetDrawColor(color.r, color.g, color.b, 200)
                        for i = 1, 3 do
                            local i2 = i * 2
                            surface.DrawOutlinedRect(i, i, w - i2, h - i2)
                        end

                        surface.SetDrawColor(color.r, color.g, color.b, 75)
                        surface.SetMaterial(lia.util.getMaterial("vgui/gradient-d"))
                        surface.DrawTexturedRect(0, 0, w, h)
                    end
                end

                if isstring(v) then
                    icon:SetModel(v)
                else
                    icon:SetModel(v[1], v[2] or 0, v[3])
                end
            end
        end
        return scroll
    end,
    onValidate = function(_, data)
        local faction = lia.faction.indices[data.faction]
        if faction then
            if not data.model then
                return false, "needModel"
            else
                local modelFound = false
                for _, model in ipairs(faction.models) do
                    if model == data.model then
                        modelFound = true
                        break
                    end
                end

                if not modelFound then return false, "needModel" end
            end
        else
            return false, "needModel"
        end
        return true
    end,
    onAdjust = function(_, data, value, newData)
        local faction = lia.faction.indices[data.faction]
        if faction then
            local model = faction.models[value]
            if isstring(model) then
                newData.model = model
            elseif istable(model) then
                newData.model = model[1]
                newData.data = newData.data or {}
                newData.data.skin = model[2] or 0
                local groups = {}
                if isstring(model[3]) then
                    local i = 0
                    for value in model[3]:gmatch("%d") do
                        groups[i] = tonumber(value)
                        i = i + 1
                    end
                elseif istable(model[3]) then
                    for _, v in pairs(model[3]) do
                        groups[tonumber(k)] = tonumber(v)
                    end
                end

                newData.data.groups = groups
            end
        end
    end
})
