local MODULE = MODULE
local PANEL = {}
function PANEL:Init()
    local client = LocalPlayer()
    local char = client:getChar()
    local boost = char:getBoosts()
    if IsValid(lia.gui.info) then lia.gui.info:Remove() end
    lia.gui.info = self
    local panelWidth = ScrW() * 0.25
    local panelHeight = ScrH() * 0.8
    local textFontSize = 20
    local textFont = "liaSmallFont"
    local textColor = color_white
    local shadowColor = Color(30, 30, 30, 150)
    self:SetSize(panelWidth, panelHeight)
    self:SetPos(ScrW() - panelWidth - 50, 90)
    self.info = vgui.Create("DFrame", self)
    self.info:SetTitle("")
    self.info:SetSize(panelWidth, panelHeight)
    self.info:ShowCloseButton(false)
    self.info:SetDraggable(false)
    self.info.Paint = function() end
    self.infoBox = self.info:Add("DPanel")
    self.infoBox:Dock(FILL)
    self.infoBox.Paint = function(_, w, h) end
    self:CreateTextEntryWithBackgroundAndLabel("name", textFont, textFontSize, textColor, shadowColor, "Name", 1)
    self:CreateTextEntryWithBackgroundAndLabel("desc", textFont, textFontSize * 3, textColor, shadowColor, "Description", 20)
    self:CreateTextEntryWithBackgroundAndLabel("money", textFont, textFontSize, textColor, shadowColor, "Money", 1)
    self:CreateTextEntryWithBackgroundAndLabel("faction", textFont, textFontSize, textColor, shadowColor, "Faction", 1)
    self:CreateTextEntryWithBackgroundAndLabel("branch", textFont, textFontSize, textColor, shadowColor, "Branch", 1)
    self:CreateTextEntryWithBackgroundAndLabel("title", textFont, textFontSize, textColor, shadowColor, "Title", 1)
    self:CreateTextEntryWithBackgroundAndLabel("rank", textFont, textFontSize, textColor, shadowColor, "Rank", 20)
    --[[
    self.attribs = self:Add("DScrollPanel")
    self.attribs:Dock(FILL)
    self.attribs:DockMargin(13, 350, 0, 0)
    for k, v in SortedPairsByMemberValue(lia.attribs.list, "name") do
        local attribBoost = 0
        if boost[k] then
            for _, bValue in pairs(boost[k]) do
                attribBoost = attribBoost + bValue
            end
        end

        local bar = self.attribs:Add("liaAttribBarNew")
        bar:Dock(TOP)
        bar:DockMargin(0, 0, 0, 5)
        local attribValue = char:getAttrib(k, 0)
        if attribBoost then
            bar:setValue(attribValue - attribBoost or 0)
        else
            bar:setValue(attribValue)
        end

        local maximum = v.maxValue or lia.config.MaxAttributes
        bar:setMax(maximum)
        bar:setReadOnly()
        bar:setText(Format("%s [%.1f/%.1f] (%.1f", L(v.name), attribValue, maximum, attribValue / maximum * 100) .. "%)")
        if attribBoost then bar:setBoost(attribBoost) end
    end]]
    self.langsTable = {}
    self.traitsTable = {}
    for k, v in SortedPairsByMemberValue(LanguagesCore.Languages, "category") do
        local hasLang = LanguagesCore:hasLanguage(client, k)
        if not hasLang then continue end
        local langName = string.gsub(v.name, "Language", "")
        table.insert(self.langsTable, langName)
    end

    for k, v in SortedPairsByMemberValue(TraitsCore.Traits, "category") do
        local hasTrait = TraitsCore:hasTrait(client, k)
        if not hasTrait then continue end
        table.insert(self.traitsTable, v.name)
    end

    local inventory = char:getInv()
    if not inventory then return end
    local mainPanel = inventory:show(self)
    local sortPanels = {}
    local totalSize = {
        x = 0,
        y = 0,
        p = 0
    }

    table.insert(sortPanels, mainPanel)
    totalSize.x = totalSize.x + mainPanel:GetWide() - 12
    totalSize.y = math.max(totalSize.y, mainPanel:GetTall())
    local px, py, pw, ph = mainPanel:GetBounds()
    local x, y = px + pw / 2 - totalSize.x / 2 - 50, py + ph / 2 - 215
    for _, panel in pairs(sortPanels) do
        panel:ShowCloseButton(true)
        panel:SetPos(x + 715, y - panel:GetTall() / 2 + 460)
        y = y + panel:GetTall() + 10
    end

    local entryContainer = self.infoBox:Add("DPanel")
    entryContainer:Dock(TOP)
    entryContainer:SetTall(textFontSize + 5)
    entryContainer:DockMargin(8, 1, 8, 1)
    entryContainer.Paint = function(_, w, h) end
    local panel1 = entryContainer:Add("DPanel")
    panel1:Dock(LEFT)
    panel1:SetWide(100)
    panel1.Paint = function(_, w, h)
        surface.SetDrawColor(shadowColor)
        surface.DrawRect(0, 0, w, h)
    end

    local categorylabel = panel1:Add("DLabel")
    categorylabel:SetFont(textFont)
    categorylabel:SetWide(75)
    categorylabel:SetTall(25)
    categorylabel:Dock(LEFT)
    categorylabel:SetText("Traits")
    categorylabel:SetTextColor(textColor)
    categorylabel:DockMargin(20, 0, 0, 0)
    categorylabel:SetContentAlignment(5)
    local entryContainer2 = self.infoBox:Add("DPanel")
    entryContainer2:Dock(TOP)
    entryContainer2:SetTall(textFontSize + 5)
    entryContainer2:DockMargin(8, 1, 8, 1)
    entryContainer2.Paint = function(_, w, h) end
    local panel2 = entryContainer2:Add("DPanel")
    panel2:Dock(LEFT)
    panel2:SetWide(100)
    panel2.Paint = function(_, w, h)
        surface.SetDrawColor(shadowColor)
        surface.DrawRect(0, 0, w, h)
    end

    local categorylabel2 = panel2:Add("DLabel")
    categorylabel2:SetFont(textFont)
    categorylabel2:SetWide(75)
    categorylabel2:SetTall(25)
    categorylabel2:Dock(LEFT)
    categorylabel2:DockMargin(20, 0, 0, 0)
    categorylabel2:SetText("Langs")
    categorylabel2:SetTextColor(textColor)
    categorylabel2:SetContentAlignment(5)
    self["Languages"] = entryContainer2:Add("DTextEntry")
    self["Languages"]:SetFont(textFont)
    self["Languages"]:SetPos(100, 0)
    self["Languages"]:SetWide(140)
    self["Languages"]:SetTall(50)
    self["Languages"]:SetText(self.langsTable[1] or "")
    self["Languages"]:SetTextColor(textColor)
    self["Languages"]:SetEditable(false)
    self["Languages"]:SetMultiline(true)
    self["Languages"]:SetContentAlignment(5)
    self["Languages1"] = entryContainer2:Add("DTextEntry")
    self["Languages1"]:SetFont(textFont)
    self["Languages1"]:SetPos(315, 0)
    self["Languages1"]:SetTall(50)
    self["Languages1"]:SetWide(140)
    self["Languages1"]:SetText(self.langsTable[2] or "")
    self["Languages1"]:SetTextColor(textColor)
    self["Languages1"]:SetEditable(false)
    self["Languages1"]:SetMultiline(true)
    self["Languages1"]:SetContentAlignment(5)
    self["Traits"] = entryContainer:Add("DTextEntry")
    self["Traits"]:SetFont(textFont)
    self["Traits"]:SetPos(100, 0)
    self["Traits"]:SetWide(140)
    self["Traits"]:SetTall(50)
    self["Traits"]:SetText(self.traitsTable[1] or "")
    self["Traits"]:SetTextColor(textColor)
    self["Traits"]:SetEditable(false)
    self["Traits"]:SetMultiline(true)
    self["Traits"]:SetContentAlignment(5)
    self["Traits1"] = entryContainer:Add("DTextEntry")
    self["Traits1"]:SetFont(textFont)
    self["Traits1"]:SetPos(315, 0)
    self["Traits1"]:SetTall(50)
    self["Traits1"]:SetWide(140)
    self["Traits1"]:SetText(self.traitsTable[2] or "")
    self["Traits1"]:SetTextColor(textColor)
    self["Traits1"]:SetEditable(false)
    self["Traits1"]:SetMultiline(true)
    self["Traits1"]:SetContentAlignment(5)
    for k, v in SortedPairsByMemberValue(lia.attribs.list, "name") do
        local attribValue = char:getAttrib(k, 0)
        local maximum = v.maxValue or lia.config.MaxAttributes
        self:CreateFillableBarWithBackgroundAndLabel(v.name, textFont, textFontSize, Color(255, 255, 255), shadowColor, attribValue .. "/" .. maximum, 0, maximum, 1, attribValue)
    end

    self:CreateFillableBarWithBackgroundAndLabel("Health", textFont, textFontSize, textColor, shadowColor, client:Health() .. "/100", 0, 100, 20, client:Health())
    self:CreateFillableBarWithBackgroundAndLabel("Stamina", textFont, textFontSize, textColor, shadowColor, char:getStamina() .. "/100", 0, 100, 1, char:getStamina())
    self:CreateFillableBarWithBackgroundAndLabel("Hunger", textFont, textFontSize, textColor, shadowColor, "50/100", 0, 100, 1, 50)
    self:CreateFillableBarWithBackgroundAndLabel("Thirst", textFont, textFontSize, textColor, shadowColor, "25/100", 0, 100, 1, 25)
    local currentWeapon = client:GetActiveWeapon()
    if IsValid(currentWeapon) and currentWeapon:GetClass() ~= "lia_hands" and currentWeapon:GetClass() ~= "lia_keys" then
        local clip = currentWeapon:Clip1()
        local count = LocalPlayer():GetAmmoCount(currentWeapon:GetPrimaryAmmoType())
        self:CreateFillableBarWithBackgroundAndLabel("Ammo", textFont, textFontSize, textColor, shadowColor, clip == -1 and count or clip .. "/" .. count, clip, count, 1, clip)
    else
        self:CreateFillableBarWithBackgroundAndLabel("Ammo", textFont, textFontSize, textColor, shadowColor, "No Weapon Equipped", 100, 100, 1, 100)
    end

    hook.Add("PostRenderVGUI", mainPanel, function() hook.Run("PostDrawInventory", mainPanel) end)
    self:setup()
end

function PANEL:CreateTextEntryWithBackgroundAndLabel(name, font, size, textColor, shadowColor, labelText, dockMarginBot, dockMarginTop)
    local isDesc = name == "desc"
    local entryContainer = self.infoBox:Add("DPanel")
    entryContainer:Dock(TOP)
    entryContainer:SetTall(size + 5)
    entryContainer:DockMargin(8, dockMarginTop or 1, 8, dockMarginBot or 1)
    entryContainer.Paint = function(_, w, h)
        surface.SetDrawColor(shadowColor)
        surface.DrawRect(0, 0, w, h)
    end

    local label = entryContainer:Add("DLabel")
    label:SetFont(font)
    label:SetWide(85)
    label:SetTall(25)
    label:SetTextColor(textColor)
    label:SetText(labelText)
    label:Dock(LEFT)
    label:DockMargin(0, 0, 15, 0) -- Adjust the left margin to move the label to the left
    label:SetContentAlignment(6)
    self[name] = entryContainer:Add("DTextEntry")
    self[name]:SetFont(font)
    self[name]:SetTall(size)
    self[name]:Dock(FILL)
    self[name]:SetTextColor(textColor)
    self[name]:SetEditable(isDesc and true or false)
    self[name]:SetMultiline(isDesc and true or false)
end

function PANEL:CreateFillableBarWithBackgroundAndLabel(name, font, size, textColor, shadowColor, labelText, minVal, maxVal, dockMarginTop, value)
    local entryContainer = self.infoBox:Add("DPanel")
    entryContainer:Dock(TOP)
    entryContainer:SetTall(25)
    entryContainer:DockMargin(8, dockMarginTop or 1, 8, 1)
    entryContainer.Paint = function(_, w, h)
        surface.SetDrawColor(shadowColor)
        surface.DrawRect(0, 0, w, h)
    end

    local label = entryContainer:Add("DLabel")
    label:SetFont(font)
    label:SetWide(100)
    label:SetTall(10)
    label:Dock(LEFT)
    label:SetTextColor(textColor)
    label:SetText(name)
    label:SetContentAlignment(5)
    local bar = entryContainer:Add("DPanel")
    bar:Dock(FILL)
    bar.Paint = function(self, w, h)
        local percentage = math.Clamp((tonumber(value) - tonumber(minVal)) / (tonumber(maxVal) - tonumber(minVal)), 0, 1)
        local filledWidth = percentage * w
        local filledColor = Color(45, 45, 45, 255)
        surface.SetDrawColor(filledColor)
        surface.DrawRect(0, 0, filledWidth, h)
        draw.SimpleText(labelText, font, w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self[name] = bar
end

function PANEL:setup()
    local client = LocalPlayer()
    local char = client:getChar()
    local rank = client:getNetVar("rank", "None")
    local title = client:getNetVar("title", "None")
    local branch = client:getNetVar("branch", "None")
    if self.name then self.name:SetText(char:getName()) end
    if self.desc then self.desc:SetText(char:getDesc()) end
    if self.money then self.money:SetText(char:getMoney() .. " Reichmarks") end
    if self.faction then self.faction:SetText(L(team.GetName(client:Team()))) end
    if self.title then self.title:SetText(client:IsPlayerInRankedFaction() and title or "None") end
    if self.rank then self.rank:SetText(client:IsPlayerInRankedFaction() and rank or "None") end
    if self.branch then self.branch:SetText(client:IsPlayerInRankedFaction() and branch or "None") end
    if self.langs then self.langs:SetText(table.concat(self.langsTable, " | ")) end
    if self.traits then self.traits:SetText(table.concat(self.traitsTable, " | ")) end
    if self.hpBar then self.hpBar:SetText(tostring(client:Health() .. "/100")) end
    if self.staminaBar then self.staminaBar:SetText(tostring(char:getStamina()) .. "/100") end
    if self.hungerBar then self.hungerBar:SetText(client:getHunger() .. "/100") end
    if self.thirstBar then self.thirstBar:SetText(client:getThrist() .. "/100") end
    local currentWeapon = client:GetActiveWeapon()
    if self.ammoCount then
        if IsValid(currentWeapon) and currentWeapon:GetClass() ~= "lia_hands" and currentWeapon:GetClass() ~= "lia_keys" then
            local ammoType = currentWeapon:GetPrimaryAmmoType()
            local ammoCount = client:GetAmmoCount(ammoType)
            local maxAmmo = currentWeapon:GetMaxClip1()
            if maxAmmo == -1 then maxAmmo = 0 end
            self.ammoCount:SetText(ammoCount .. " / " .. maxAmmo)
        else
            self.ammoCount:SetText("Weapon Not Equipped")
        end
    end
end

vgui.Register("liaCharInfo", PANEL, "EditablePanel")
PANEL = {}
function PANEL:Init()
    self:SetTall(20)
    self.add = self:Add("DImageButton")
    self.add:SetSize(16, 16)
    self.add:Dock(RIGHT)
    self.add:DockMargin(2, 2, 2, 2)
    self.add:SetImage("icon16/add.png")
    self.add.OnMousePressed = function()
        self.pressing = 1
        self:doChange()
        self.add:SetAlpha(150)
    end

    self.add.OnMouseReleased = function()
        if self.pressing then
            self.pressing = nil
            self.add:SetAlpha(255)
        end
    end

    self.add.OnCursorExited = self.add.OnMouseReleased
    self.sub = self:Add("DImageButton")
    self.sub:SetSize(16, 16)
    self.sub:Dock(LEFT)
    self.sub:DockMargin(2, 2, 2, 2)
    self.sub:SetImage("icon16/delete.png")
    self.sub.OnMousePressed = function()
        self.pressing = -1
        self:doChange()
        self.sub:SetAlpha(150)
    end

    self.sub.OnMouseReleased = function()
        if self.pressing then
            self.pressing = nil
            self.sub:SetAlpha(255)
        end
    end

    self.sub.OnCursorExited = self.sub.OnMouseReleased
    self.t = 0
    self.value = 0
    self.deltaValue = self.value
    self.max = 10
    self.bar = self:Add("DPanel")
    self.bar:Dock(FILL)
    self.bar:DockMargin(2, 2, 2, 2)
    self.bar.Paint = function(_, w, h)
        self.t = Lerp(FrameTime() * 10, self.t, 1)
        local value = (self.value / self.max) * self.t
        local boostedValue = self.boostValue or 0
        local barWidth = w * value
        if value > 0 then
            local color = lia.config.Color
            surface.SetDrawColor(color)
            surface.DrawRect(0, 0, barWidth, h)
        end

        if boostedValue ~= 0 then
            local boostW = math.Clamp(math.abs(boostedValue / self.max), 0, 1) * w * self.t + 1
            if boostedValue < 0 then
                surface.SetDrawColor(200, 80, 80, 200)
                surface.DrawRect(barWidth - boostW, 0, boostW, h)
            else
                surface.SetDrawColor(80, 200, 80, 200)
                surface.DrawRect(barWidth, 0, boostW, h)
            end
        end
    end

    self.label = self.bar:Add("DLabel")
    self.label:Dock(FILL)
    self.label:SetExpensiveShadow(1, Color(0, 0, 60))
    self.label:SetContentAlignment(5)
end

function PANEL:Think()
    if self.pressing and ((self.nextPress or 0) < CurTime()) then self:doChange() end
    self.deltaValue = math.Approach(self.deltaValue, self.value, FrameTime() * 15)
end

function PANEL:doChange()
    if (self.value == 0 and self.pressing == -1) or (self.value == self.max and self.pressing == 1) then return end
    self.nextPress = CurTime() + 0.2
    if self:onChanged(self.pressing) ~= false then self.value = math.Clamp(self.value + self.pressing, 0, self.max) end
end

function PANEL:onChanged(_)
end

function PANEL:getValue()
    return self.value
end

function PANEL:setValue(value)
    self.value = value
end

function PANEL:setBoost(value)
    self.boostValue = value
end

function PANEL:setMax(max)
    self.max = max
end

function PANEL:setText(text)
    self.label:SetText(text)
end

function PANEL:setReadOnly()
    self.sub:Remove()
    self.add:Remove()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, w - 15, h)
end

vgui.Register("liaAttribBarNew", PANEL, "DPanel")
