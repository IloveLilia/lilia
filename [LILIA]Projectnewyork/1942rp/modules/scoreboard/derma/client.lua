local MODULE = MODULE
local PANEL = {}
local StaffCount = 0
local StaffOnDutyCount = 0
local paintFunctions = {}
paintFunctions[0] = function(_, w, h)
    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawRect(0, 0, w, h)
end

paintFunctions[1] = function(_, _, _) end
function PANEL:Init()
    if IsValid(lia.gui.score) then lia.gui.score:Remove() end
    lia.gui.score = self
    self:SetSize(ScrW() * MODULE.sbWidth, ScrH() * MODULE.sbHeight)
    self:Center()
    self.slots = {}
    self.staff1 = self:Add("DLabel") -- Staff online label
    self.staff1:SetText("Staff Online: 0")
    self.staff1:SetFont("liaMediumFont")
    self.staff1:SetContentAlignment(5)
    self.staff1:SetTextColor(color_white)
    self.staff1:SetExpensiveShadow(1, color_black)
    self.staff1:Dock(BOTTOM)
    self.staff1:SizeToContentsY()
    self.staff1.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.scroll = self:Add("DScrollPanel") -- Scroll panel setup
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(1, 0, 1, 0)
    self.scroll.VBar:SetWide(0)
    self.layout = self.scroll:Add("DListLayout")
    self.layout:Dock(TOP)
    self.teams = {} -- Iterate over factions
    for k, v in ipairs(lia.faction.indices) do
        if lia.faction.getPlayerCount(k) > 0 then
            local factionList = {}
            local factionHasSubclasses = table.HasValue(MODULE.SubClassFactionWhitelist, k)
            local color = team.GetColor(k)
            local r, g, b = color.r, color.g, color.b
            if factionHasSubclasses then
                local mainList = self.layout:Add("DListLayout")
                mainList:Dock(TOP)
                mainList:SetTall(28)
                mainList.classLists = {}
                mainList.Think = function(this)
                    for _, v2 in ipairs(lia.faction.getPlayers(k)) do
                        if hook.Run("ShouldShowPlayerOnScoreboard", v2) == false then continue end
                        if not IsValid(v2.liaScoreSlot) or v2.liaScoreSlot:GetParent() ~= this then
                            local classID = v2:getChar():getClass()
                            if classID == 0 then
                                if IsValid(v2.liaScoreSlot) then
                                    v2.liaScoreSlot:SetParent(this)
                                else
                                    self:addPlayer(v2, this)
                                end
                            else
                                local classList = factionList.mainList.classLists[classID]
                                if not IsValid(classList) then
                                    classList = mainList:Add("DListLayout")
                                    classList:Dock(TOP)
                                    classList:SetTall(28)
                                    classList.Paint = function(_, w, h)
                                        surface.SetDrawColor(0, 0, 0, 100)
                                        surface.DrawRect(0, 0, w, h)
                                    end

                                    local class = lia.class.get(classID)
                                    if not class then return end
                                    local fixedMargin = 25
                                    local className = class.name
                                    local officerText = "Officers: " .. self:CountOfficers(self:GetClassFaction(classID), classID)
                                    surface.SetFont("liaMediumFont")
                                    local header2 = classList:Add("DLabel")
                                    header2:Dock(TOP)
                                    header2:SetFont("liaMediumFont")
                                    header2:SetText("")
                                    header2:SetTextColor(color_white)
                                    header2:SetTall(28)
                                    header2.Paint = function(self, w, h)
                                        surface.SetDrawColor(255, 255, 255, 20)
                                        surface.DrawRect(0, 0, w, h)
                                        local shadowOffset = 1
                                        local textVerticalOffset = 6
                                        surface.SetFont(self:GetFont())
                                        surface.SetTextColor(color_black)
                                        surface.SetTextPos(3 + shadowOffset, h / 2 - surface.GetTextSize("ABC") / 2 + shadowOffset + textVerticalOffset)
                                        surface.DrawText(className)
                                        surface.SetTextColor(color_white)
                                        surface.SetTextPos(3, h / 2 - surface.GetTextSize("ABC") / 2 + textVerticalOffset)
                                        surface.DrawText(className)
                                        local officerTextWidth = surface.GetTextSize(officerText)
                                        local xPos = w - officerTextWidth - fixedMargin
                                        surface.SetTextColor(color_black)
                                        surface.SetTextPos(xPos + shadowOffset, h / 2 - surface.GetTextSize("ABC") / 2 + shadowOffset + textVerticalOffset)
                                        surface.DrawText(officerText)
                                        surface.SetTextColor(color_white)
                                        surface.SetTextPos(xPos, h / 2 - surface.GetTextSize("ABC") / 2 + textVerticalOffset)
                                        surface.DrawText(officerText)
                                    end

                                    factionList.mainList.classLists[classID] = classList
                                end

                                if IsValid(v2.liaScoreSlot) then
                                    v2.liaScoreSlot:SetParent(classList)
                                else
                                    self:addPlayer(v2, classList)
                                end
                            end
                        end
                    end
                end

                local header = mainList:Add("DPanel")
                header:Dock(TOP)
                header:SetTall(56)
                header.Paint = function(_, w, h)
                    surface.SetDrawColor(r, g, b, 20)
                    surface.DrawRect(0, 0, w, h)
                end

                local iconPath = MODULE.FactionIcons[v.index] or MODULE.DefaultIcon
                local icon = header:Add("DImage")
                icon:Dock(LEFT)
                icon:SetWide(56)
                icon:SetMaterial(Material(iconPath))
                local labelText = header:Add("DLabel")
                labelText:Dock(FILL)
                labelText:SetText(L(v.name))
                labelText:SetContentAlignment(5)
                labelText:SetTextInset(3, 0)
                labelText:SetFont("liaBigFont")
                labelText:SetTextColor(color_white)
                labelText:SetExpensiveShadow(1, color_black)
                factionList.mainList = mainList
            else
                local list = self.layout:Add("DListLayout")
                list:Dock(TOP)
                list:SetTall(56)
                list.Think = function(this)
                    for _, v2 in ipairs(lia.faction.getPlayers(k)) do
                        if hook.Run("ShouldShowPlayerOnScoreboard", v2) == false then continue end
                        if not IsValid(v2.liaScoreSlot) or v2.liaScoreSlot:GetParent() ~= this then
                            if IsValid(v2.liaScoreSlot) then
                                v2.liaScoreSlot:SetParent(this)
                            else
                                self:addPlayer(v2, this)
                            end
                        end
                    end
                end

                local header = list:Add("DPanel")
                header:Dock(TOP)
                header:SetTall(56)
                header.Paint = function(_, w, h)
                    surface.SetDrawColor(r, g, b, 20)
                    surface.DrawRect(0, 0, w, h)
                end

                local iconPath = MODULE.FactionIcons[v.index] or MODULE.DefaultIcon
                local icon = header:Add("DImage")
                icon:Dock(LEFT)
                icon:SetWide(56)
                icon:SetMaterial(Material(iconPath))
                local labelText = header:Add("DLabel")
                labelText:Dock(FILL)
                labelText:SetText(L(v.name))
                labelText:SetContentAlignment(5)
                labelText:SetTextInset(3, 0)
                labelText:SetFont("liaBigFont")
                labelText:SetTextColor(color_white)
                labelText:SetExpensiveShadow(1, color_black)
                factionList[k] = {
                    list = list,
                    classLists = {}
                }
            end

            self.teams[k] = factionList
        end
    end
end

function PANEL:UpdateStaff()
    StaffCount = 0
    StaffOnDutyCount = 0
    for _, target in pairs(player.GetAll()) do
        if target:isStaff() then StaffCount = StaffCount + 1 end
        if target:isStaffOnDuty() then StaffOnDutyCount = StaffOnDutyCount + 1 end
    end

    self.staff1:SetText("Players Online: " .. #player.GetAll() .. " | Staff On Duty: " .. StaffOnDutyCount .. " | Staff Online: " .. StaffCount)
end

function PANEL:Think()
    if (self.nextUpdate or 0) < CurTime() then
        local visible, amount
        for k, v in ipairs(self.teams) do
            if IsValid(v.list) then
                visible, amount = v.list:IsVisible(), lia.faction.getPlayerCount(k)
                if k == FACTION_STAFF then
                    v.list:SetVisible(MODULE.ShowStaff and LocalPlayer():isStaffOnDuty())
                else
                    v.list:SetVisible(visible and amount > 0)
                end

                for _, playerEntity in ipairs(lia.faction.getPlayers(k)) do
                    local playerPanel = playerEntity.liaScoreSlot
                    if not IsValid(playerPanel) then
                        local classID = playerEntity:getChar():getClass()
                        local classList = v.classLists[classID]
                        if IsValid(classList) then
                            self:addPlayer(playerEntity, classList)
                        else
                            self:addPlayer(playerEntity, v.list)
                        end
                    end
                end
            end
        end

        self:UpdateStaff()
        self.nextUpdate = CurTime() + 0.5
    end
end

function PANEL:addPlayer(client, parent)
    if not client:getChar() or not IsValid(parent) then return end
    local slot = parent:Add("DPanel")
    slot:Dock(TOP)
    slot:SetTall(72)
    slot:DockMargin(0, 0, 0, 1)
    slot.character = client:getChar()
    client.liaScoreSlot = slot
    slot.model = slot:Add("liaSpawnIcon")
    slot.model:SetModel(client:GetModel(), client:GetSkin())
    slot.model:SetSize(64, 64)
    slot.model.DoClick = function()
        local menu = DermaMenu()
        local options = {}
        hook.Run("ShowPlayerOptions", client, options)
        if table.Count(options) > 0 then
            for k, v in SortedPairs(options) do
                menu:AddOption(L(k), v[2]):SetImage(v[1])
            end
        end

        menu:Open()
        RegisterDermaMenuForClose(menu)
    end

    slot.model:SetTooltip(L("sbOptions", client:Name()))
    timer.Simple(0, function()
        if not IsValid(slot) then return end
        local entity = slot.model.Entity
        if IsValid(entity) then
            for _, v in ipairs(client:GetBodyGroups()) do
                entity:SetBodygroup(v.id, client:GetBodygroup(v.id))
            end

            for k, _ in ipairs(client:GetMaterials()) do
                entity:SetSubMaterial(k - 1, client:GetSubMaterial(k - 1))
            end
        end
    end)

    slot.name = slot:Add("DLabel")
    slot.name:Dock(TOP)
    slot.name:DockMargin(65, 0, 48, 0)
    slot.name:SetTall(18)
    slot.name:SetFont("liaGenericFont")
    slot.name:SetTextColor(color_white)
    slot.name:SetExpensiveShadow(1, color_black)
    slot.ping = slot:Add("DLabel")
    slot.ping:SetPos(self:GetWide() - 48, 0)
    slot.ping:SetSize(48, 64)
    slot.ping:SetText("0")
    slot.ping.Think = function(this) if IsValid(client) then this:SetText(client:Ping()) end end
    slot.ping:SetFont("liaGenericFont")
    slot.ping:SetContentAlignment(6)
    slot.ping:SetTextColor(color_white)
    slot.ping:SetTextInset(16, 0)
    slot.ping:SetExpensiveShadow(1, color_black)
    slot.desc = slot:Add("DLabel")
    slot.desc:Dock(FILL)
    slot.desc:DockMargin(65, 0, 48, 0)
    slot.desc:SetWrap(true)
    slot.desc:SetContentAlignment(7)
    slot.desc:SetTextColor(color_white)
    slot.desc:SetExpensiveShadow(1, Color(0, 0, 0, 100))
    slot.desc:SetFont("liaSmallFont")
    local oldTeam = client:Team()
    function slot:update()
        if not IsValid(client) or not client:getChar() or not self.character or self.character ~= client:getChar() or oldTeam ~= client:Team() then
            self:Remove()
            local i = 0
            for _, v in ipairs(parent:GetChildren()) do
                if IsValid(v.model) and v ~= self then
                    i = i + 1
                    v.Paint = paintFunctions[i % 2]
                end
            end
            return
        end

        local overrideName = hook.Run("ShouldAllowScoreboardOverride", client, "name") and hook.Run("GetDisplayedName", client) or client:getChar():getName()
        local name = overrideName or client:Name()
        name = name:gsub("#", "\226\128\139#")
        local model = client:GetModel()
        local skin = client:GetSkin()
        local desc = hook.Run("ShouldAllowScoreboardOverride", client, "desc") and hook.Run("GetDisplayedDescription", client, false) or client:getChar():getDesc()
        desc = desc:gsub("#", "\226\128\139#")
        self.model:setHidden(hook.Run("ShouldAllowScoreboardOverride", client, "model"))
        if self.lastName ~= name then
            self.name:SetText(name)
            self.lastName = name
        end

        local entity = self.model.Entity
        if not IsValid(entity) then return end
        if self.lastDesc ~= desc then
            self.desc:SetText(desc)
            self.lastDesc = desc
        end

        if self.lastModel ~= model or self.lastSkin ~= skin then
            self.model:SetModel(client:GetModel(), client:GetSkin())
            if CAMI.PlayerHasAccess(LocalPlayer(), "Staff Permissions - Can Access Scoreboard Info Out Of Staff") or (CAMI.PlayerHasAccess(LocalPlayer(), "Staff Permissions - Can Access Scoreboard Admin Options") and LocalPlayer():isStaffOnDuty()) then
                self.model:SetTooltip(L("sbOptions", client:Name()))
            else
                self.model:SetTooltip("You do not have access to see this information")
            end

            self.lastModel = model
            self.lastSkin = skin
        end

        timer.Simple(0, function()
            if not IsValid(entity) or not IsValid(client) then return end
            for _, v in ipairs(client:GetBodyGroups()) do
                entity:SetBodygroup(v.id, client:GetBodygroup(v.id))
            end
        end)
    end

    self.slots[#self.slots + 1] = slot
    parent:SetVisible(true)
    parent:SizeToChildren(false, true)
    parent:InvalidateLayout(true)
    local i = 0
    for _, v in ipairs(parent:GetChildren()) do
        if IsValid(v.model) then
            i = i + 1
            v.Paint = paintFunctions[i % 2]
        end
    end

    slot:update()
    return slot
end

function PANEL:OnRemove()
    CloseDermaMenus()
end

function PANEL:GetClassFaction(classID)
    local class = lia.class.list[classID]
    if class and class.faction then return class.faction end
end

function PANEL:CountOfficers(factionID, classID)
    local count = 0
    local faction = lia.faction.indices[factionID]
    if faction then
        local class = lia.class.get(classID)
        if class then
            for _, client in ipairs(lia.faction.getPlayers(factionID)) do
                local playerClassID = client:getChar():getClass()
                if playerClassID == classID then
                    local rankTable = lia.config.RankTable[client:getChar():getClass()]
                    local rankData = client:GetPlayerRankData()
                    if rankTable and rankData and rankData.IsOfficer then count = count + 1 end
                end
            end
        end
    end
    return count
end

function PANEL:Paint(w, h)
    lia.util.drawBlur(self, 10)
    surface.SetDrawColor(30, 30, 30, 100)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(0, 0, 0, 150)
    surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("liaScoreboard", PANEL, "EditablePanel")
