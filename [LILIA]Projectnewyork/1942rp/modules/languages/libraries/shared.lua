local MODULE = MODULE
function MODULE:Register(tbl)
    self.Languages[tbl.uid] = tbl
end

for k, v in pairs(MODULE.LanguageTable) do
    local vlower = string.lower(v)
    local Language = {}
    Language.uid = k
    Language.name = v .. " Language"
    Language.desc = "You can speak " .. v .. ".\nCommand: " .. "/" .. k
    Language.category = "Language"
    MODULE:Register(Language)
    lia.chat.register(k, {
        onCanSay = function(speaker, text)
            local language = MODULE:hasLanguage(speaker, k)
            if language then
                return true
            else
                speaker:notify("You do not know that language.")
                return false
            end
        end,
        onChatAdd = function(speaker, text, anonymous)
            local speako = anonymous and "Someone" or hook.Run("GetDisplayedName", speaker, "ic") or (IsValid(speaker) and speaker:Name() or "Console")
            local texCol = ChatboxCore.ChatColor
            if LocalPlayer():GetEyeTrace().Entity == speaker then texCol = ChatboxCore.ChatListenColor end
            texCol = Color(texCol.r, texCol.g, texCol.b)
            local nameCol = Color(texCol.r + 30, texCol.g + 30, texCol.b + 30)
            if LocalPlayer() == speaker then
                local tempCol = ChatboxCore.ChatListenColor
                texCol = Color(tempCol.r + 20, tempCol.b + 20, tempCol.g + 20)
                nameCol = Color(tempCol.r + 40, tempCol.b + 60, tempCol.g + 40)
            end

            if MODULE:hasLanguage(LocalPlayer(), k) then
                chat.AddText(nameCol, speako, texCol, " says in " .. v .. ", \"" .. text .. "\"")
            else
                chat.AddText(nameCol, speako, texCol, " says something in " .. v .. ".")
            end
        end,
        onCanHear = ChatboxCore.ChatRange,
        prefix = {"/" .. k, "/" .. vlower}
    })

    lia.chat.register(k .. "w", {
        onCanSay = function(speaker, text)
            local language = MODULE:hasLanguage(speaker, k)
            if language then
                return true
            else
                speaker:notify("You do not know that language.")
                return false
            end
        end,
        onChatAdd = function(speaker, text, anonymous)
            local speako = anonymous and "Someone" or hook.Run("GetDisplayedName", speaker, "ic") or (IsValid(speaker) and speaker:Name() or "Console")
            local texCol = ChatboxCore.ChatColor
            if LocalPlayer():GetEyeTrace().Entity == speaker then texCol = ChatboxCore.ChatListenColor end
            texCol = Color(texCol.r - 35, texCol.g - 35, texCol.b - 35)
            local nameCol = Color(texCol.r + 30, texCol.g + 30, texCol.b + 30)
            if LocalPlayer() == speaker then
                local tempCol = ChatboxCore.ChatListenColor
                texCol = Color(tempCol.r - 15, tempCol.b - 15, tempCol.g - 15)
                nameCol = Color(tempCol.r + 40, tempCol.b + 60, tempCol.g + 40)
            end

            if MODULE:hasLanguage(LocalPlayer(), k) then
                chat.AddText(nameCol, speako, texCol, " whispers in " .. v .. ", \"" .. text .. "\"")
            else
                chat.AddText(nameCol, speako, texCol, " whispers something in " .. v .. ".")
            end
        end,
        onCanHear = ChatboxCore.ChatRange * 0.25,
        prefix = {"/" .. k .. "w", "/" .. vlower .. "w"}
    })

    lia.chat.register(k .. "y", {
        onCanSay = function(speaker, text)
            local language = MODULE:hasLanguage(speaker, k)
            if language then
                return true
            else
                speaker:notify("You do not know that language.")
                return false
            end
        end,
        onChatAdd = function(speaker, text, anonymous)
            local speako = anonymous and "Someone" or hook.Run("GetDisplayedName", speaker, "ic") or (IsValid(speaker) and speaker:Name() or "Console")
            local texCol = ChatboxCore.ChatColor
            if LocalPlayer():GetEyeTrace().Entity == speaker then texCol = ChatboxCore.ChatListenColor end
            texCol = Color(texCol.r + 35, texCol.g + 35, texCol.b + 35)
            local nameCol = Color(texCol.r + 30, texCol.g + 30, texCol.b + 30)
            if LocalPlayer() == speaker then
                local tempCol = ChatboxCore.ChatListenColor
                texCol = Color(tempCol.r + 55, tempCol.b + 55, tempCol.g + 55)
                nameCol = Color(tempCol.r + 40, tempCol.b + 60, tempCol.g + 40)
            end

            if MODULE:hasLanguage(LocalPlayer(), k) then
                chat.AddText(nameCol, speako, texCol, " yells in " .. v .. ", \"" .. text .. "\"")
            else
                chat.AddText(nameCol, speako, texCol, " yells something in " .. v .. ".")
            end
        end,
        onCanHear = ChatboxCore.ChatRange * 2,
        prefix = {"/" .. k .. "y", "/" .. vlower .. "y"}
    })
end

function MODULE:hasLanguage(client, language)
    local char = client:getChar()
    if not char then return end
    local languageData = char:getData("languages")
    if languageData and languageData[language] then return true end
    return false
end

lia.char.registerVar("languages", {
    field = "_languages",
    default = {},
    index = 9998,
    isLocal = true,
    onDisplay = function(panel, y)
        local container = panel:Add("DScrollPanel")
        container:SetPos(panel.lastX, y)
        container:SetSize(ScrW() * 0.25, ScrH() * 0.2)
        local y2 = 0
        local total = 0
        panel.payload.languages = {}
        for k, v in SortedPairsByMemberValue(MODULE.Languages, "category") do
            if v.ignore then continue end
            panel.payload.languages[k] = nil
            local bar = container:Add("liaAttribBar")
            bar:SetTooltip(v.desc)
            bar:setMax(1)
            bar:Dock(TOP)
            bar:DockMargin(2, 2, 2, 2)
            bar:setText(L(v.name))
            bar.onChanged = function(this, difference)
                if (total + difference) > 1 then return false end
                total = total + difference
                if panel.payload.languages[k] == nil then
                    panel.payload.languages[k] = 1
                else
                    panel.payload.languages[k] = nil
                end
            end

            y2 = y2 + bar:GetTall() + 4
        end
        return container
    end,
    onValidate = function(value, data, client)
        if value ~= nil then
            if type(value) == "table" then
                local count = 0
                for k, v in pairs(value) do
                    count = count + v
                end

                if count > 1 then return false, "unknownError" end
            else
                return false, "unknownError"
            end
        end
    end,
    onAdjust = function(client, data, value, newData)
        newData.data = newData.data or {}
        newData.data.languages = data.languages
    end,
    shouldDisplay = function(panel) return false end
})
