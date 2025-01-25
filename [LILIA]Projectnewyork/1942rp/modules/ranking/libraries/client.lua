function MODULE:OpenPlayerModelUI(modelTable)
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Change Playermodel")
    frame:SetSize(450, 300)
    frame:Center()
    function frame:OnClose()
        frame:Remove()
    end

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    local wrapper = vgui.Create("DIconLayout", scroll)
    wrapper:Dock(FILL)
    local edit = vgui.Create("DTextEntry", frame)
    edit:Dock(BOTTOM)
    edit:SetText(LocalPlayer():GetModel())
    edit:SetEditable(false)
    local button = vgui.Create("DButton", frame)
    button:SetText("Change")
    button:Dock(TOP)
    function button:DoClick()
        local txt = edit:GetValue()
        netstream.Start("setModelRanked", txt)
        frame:Remove()
    end

    for _, model in ipairs(modelTable) do
        local icon = wrapper:Add("SpawnIcon")
        icon:SetModel(model)
        icon:SetSize(64, 64)
        icon:SetTooltip(model)
        icon.playermodel = model
        icon.model_path = model
        icon.DoClick = function(self) edit:SetValue(self.model_path) end
    end

    frame:MakePopup()
end

function MODULE:OpenRankSelectionUI(target)
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Pick a Rank")
    frame:SetSize(300, 200)
    frame:Center()
    frame:MakePopup()
    local dropdown = vgui.Create("DComboBox", frame)
    dropdown:Dock(FILL)
    local rankData = {}
    for rank, data in pairs(lia.config.RankTable[target:getChar():getClass()]) do
        dropdown:AddChoice(data.Rank, rank)
        rankData[rank] = data
    end

    local confirmButton = vgui.Create("DButton", frame)
    confirmButton:SetText("Confirm")
    confirmButton:Dock(BOTTOM)
    function confirmButton:DoClick()
        local selectedRankName = dropdown:GetSelected()
        if selectedRankName then
            for rank, data in pairs(lia.config.RankTable[target:getChar():getClass()]) do
                if data.Rank == selectedRankName then
                    netstream.Start("SetRankInformation", target, data)
                    frame:Close()
                end
            end
        end
    end
end

function MODULE:DrawCharInfo(client, character, info)
    if not client:IsPlayerInRankedFaction() then return end
    local rankID = client:getNetVar("rankID", "")
    local rank = client:getNetVar("rank", "")
    local title = client:getNetVar("title", "")
    local RankToggled = client:getNetVar("RankToggled", true)
    local TitleToggled = client:getNetVar("TitleToggled", true)
    local rankTable = lia.config.RankTable[client:getChar():getClass()][rankID]
    local color = rankTable and rankTable.RGB or Color(255, 255, 255)
    if title ~= "" and TitleToggled then info[#info + 1] = {title, color} end
    if rank ~= "" and RankToggled then info[#info + 1] = {rank, color} end
end

function MODULE:AdminStickMenuAdd(AdminMenu, target)
    local characterMenu = AdminMenu:AddSubMenu("Ranking")
    local titleOption = characterMenu:AddOption("Set Title", function()
        Derma_StringRequest("Set Character Title", "Enter the new title for " .. target:Nick() .. ":", "", function(text)
            RunConsoleCommand("say", "/charsettitle " .. target:SteamID() .. " " .. text)
        end, nil, "Set Title", "Cancel")
    end)

    titleOption:SetIcon("icon16/textfield_key.png")
    local rankOption = characterMenu:AddOption("Set Rank", function()
        RunConsoleCommand("say", "/charsetrank " .. target:SteamID())
    end)

    rankOption:SetIcon("icon16/award_star_gold_1.png")
    local resetPromoOption = characterMenu:AddOption("Reset Promotion Cooldown", function()
        RunConsoleCommand("say", "/resetpromotecooldown " .. target:SteamID())
    end)

    resetPromoOption:SetIcon("icon16/clock_red.png")
    local resetTransferOption = characterMenu:AddOption("Reset Transfer Cooldown", function()
        RunConsoleCommand("say", "/resettransfercooldown " .. target:SteamID())
    end)

    resetTransferOption:SetIcon("icon16/clock.png")
end