local PANEL = {}
local gradient = lia.util.getMaterial("vgui/gradient-u")
function PANEL:Init()
    local char = LocalPlayer():getChar()
    self.initialValues = {
        ThirdPerson = GetConVar("tp_enabled"):GetInt(),
        ThirdPersonVerticalView = GetConVar("tp_vertical"):GetInt(),
        ThirdPersonHorizontalView = GetConVar("tp_horizontal"):GetInt(),
        ThirdPersonViewDistance = GetConVar("tp_distance"):GetInt(),
    }
--[[
    self.model = self:Add("liaModelPanel")
    self.model:SetWide(ScrW() * 0.25)
    self.model:Dock(LEFT)
    self.model:DockMargin(400, 0, 0, 0)
    self.model:DockMargin(350, 0, 0, 0)
    self.model:SetFOV(50)
    self.model:SetTall(self:GetTall())
    self.model.enableHook = true
    self.model.copyLocalSequence = true
    self.model:SetModel(LocalPlayer():GetModel())
    self.model.Entity:SetSkin(LocalPlayer():GetSkin())
    for k, v in ipairs(LocalPlayer():GetBodyGroups()) do
        self.model.Entity:SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
    end

    local ent = self.model.Entity
    if ent and IsValid(ent) then
        local mats = LocalPlayer():GetMaterials()
        for k, v in pairs(mats) do
            ent:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
        end
    end
]]
    self.CharOverView = false
    self.noAnchor = CurTime() + 0.4
    self.overviewFraction = 0
    self.currentAlpha = 0
    self.currentBlur = 0
    self.anchorMode = true
    self.rotationOffset = Angle(0, 180, 0)
    self.projectedTexturePosition = Vector(0, 0, 6)
    self.projectedTextureRotation = Angle(-45, 60, 0)
    --[[
    ThirdPerson = GetConVar("tp_enabled")
    ThirdPersonVerticalView = GetConVar("tp_vertical")
    ThirdPersonHorizontalView = GetConVar("tp_horizontal")
    ThirdPersonViewDistance = GetConVar("tp_distance")
    if ThirdPerson:GetInt() ~= 1 then
        wasThirdPerson = false
        RunConsoleCommand("tp_enabled", "1")
    else
        wasThirdPerson = true
    end

    if ClassicThirdPerson:GetInt() == 1 then
        wasClassic = true
        RunConsoleCommand("tp_classic", "0")
    else
        wasClassic = false
    end

    ThirdPersonVerticalView:SetInt(0)
    ThirdPersonHorizontalView:SetInt(0)
    ThirdPersonViewDistance:SetInt(50)]]
    lia.gui.menu = self
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.25, 0)
    self:SetPopupStayAtBack(true)
    self.tabs = self:Add("DHorizontalScroller")
    self.tabs:SetWide(0)
    self.tabs:SetTall(86)
    self.panel = self:Add("EditablePanel")
    self.panel:SetSize(ScrW() * 0.6, ScrH() * 0.65)
    self.panel:Center()
    self.panel:SetPos(self.panel.x, self.panel.y + 72)
    self.panel:SetAlpha(0)
    self.title = self:Add("DLabel")
    self.title:SetPos(self.panel.x, self.panel.y - 80)
    self.title:SetTextColor(color_white)
    self.title:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    self.title:SetFont("liaTitleFont")
    self.title:SetText("")
    self.title:SetAlpha(0)
    self.title:SetSize(self.panel:GetWide(), 72)
    local tabs = {}
    hook.Run("CreateMenuButtons", tabs)
    self.tabList = {}
    for name, callback in SortedPairs(tabs) do
        if type(callback) == "string" then
            local body = callback
            if body:sub(1, 4) == "http" then
                callback = function(panel)
                    local html = panel:Add("DHTML")
                    html:Dock(FILL)
                    html:OpenURL(body)
                end
            else
                callback = function(panel)
                    local html = panel:Add("DHTML")
                    html:Dock(FILL)
                    html:SetHTML(body)
                end
            end
        end

        local tab = self:addTab(L(name), callback, name)
        self.tabList[name] = tab
    end

    self.noAnchor = CurTime() + .4
    self.anchorMode = true
    self:MakePopup()
    self.info = vgui.Create("liaCharInfo", self)
    self.info:setup()
    self.info:SetAlpha(0)
    self.info:AlphaTo(255, 0.5)
end

function PANEL:OnKeyCodePressed(key)
    self.noAnchor = CurTime() + .5
    if key == KEY_F1 then self:remove() end
end

function PANEL:Update()
    self:Remove()
    vgui.Create("liaMenu")
end

function PANEL:Think()
    local key = input.IsKeyDown(KEY_F1)
    if key and (self.noAnchor or CurTime() + .4) < CurTime() and self.anchorMode == true then
        self.anchorMode = false
        surface.PlaySound("buttons/lightswitch2.wav")
    end

    if not self.anchorMode then
        if IsValid(self.info) then return end
        if not key then self:remove() end
    end
end

function PANEL:Paint(w, h)
    lia.util.drawBlur(self)
end

function PANEL:addTab(name, callback, uniqueID)
    name = L(name)
    local function paintTab(tab, w, h)
        if self.activeTab == tab then
            surface.SetDrawColor(ColorAlpha(lia.config.Color, 200))
            surface.DrawRect(0, h - 8, w, 8)
        elseif tab.Hovered then
            surface.SetDrawColor(0, 0, 0, 50)
            surface.DrawRect(0, h - 8, w, 8)
        end
    end

    surface.SetFont("liaMenuButtonLightFont")
    local w = surface.GetTextSize(name)
    local tab = self.tabs:Add("DButton")
    tab:SetSize(0, self.tabs:GetTall())
    tab:SetText(name)
    tab:SetPos(self.tabs:GetWide(), 0)
    tab:SetTextColor(Color(250, 250, 250))
    tab:SetFont("liaMenuButtonLightFont")
    tab:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    tab:SizeToContentsX()
    tab:SetWide(w + 32)
    tab.Paint = paintTab
    tab.DoClick = function(this)
        if IsValid(lia.gui.info) then lia.gui.info:Remove() end
        self.panel:Clear()
        self.title:SetText(this:GetText())
        self.title:SizeToContentsY()
        self.title:AlphaTo(255, 0.5)
        self.title:MoveAbove(self.panel, 8)
        self.panel:AlphaTo(255, 0.5, 0.1)
        --[[
        self.button:Remove()
        self.button2:Remove()
        self.button3:Remove()]]
        self.activeTab = this
        lastMenuTab = uniqueID
        if callback then callback(self.panel, this) end
    end

    self.tabs:AddPanel(tab)
    self.tabs:SetWide(math.min(self.tabs:GetWide() + tab:GetWide(), ScrW()))
    self.tabs:SetPos((ScrW() * 0.5) - (self.tabs:GetWide() * 0.5), 0)
    return tab
end

function PANEL:GetOverviewInfo(origin, angles, fov)
    local originAngles = Angle(0, angles.yaw, angles.roll)
    local target = LocalPlayer():GetObserverTarget()
    local fraction = self.overviewFraction
    local bDrawPlayer = ((fraction > 0.2) or (not self.bOverviewOut and (fraction > 0.2))) and not IsValid(target)
    local forward = originAngles:Forward() * 58 - originAngles:Right() * 16
    forward.z = 0
    local newOrigin
    if IsValid(target) then
        newOrigin = target:GetPos() + forward
    else
        newOrigin = origin - LocalPlayer():OBBCenter() * 0.6 + forward
    end

    local newAngles = originAngles + self.rotationOffset
    newAngles.pitch = 5
    newAngles.roll = 0
    return LerpVector(fraction, origin, newOrigin), LerpAngle(fraction, angles, newAngles), Lerp(fraction, fov, 90), bDrawPlayer
end

function PANEL:SetCharacterOverview(bValue, length)
    bValue = tobool(bValue)
    length = length or animationTime
    if bValue then
        if not IsValid(self.projectedTexture) then self.projectedTexture = ProjectedTexture() end
        local faction = lia.faction.indices[LocalPlayer():Team()]
        local color = faction and faction.color or color_white
        self.projectedTexture:SetEnableShadows(false)
        self.projectedTexture:SetNearZ(12)
        self.projectedTexture:SetFarZ(64)
        self.projectedTexture:SetFOV(90)
        self.projectedTexture:SetColor(color)
        self.projectedTexture:SetTexture("effects/flashlight/soft")
        self.bOverviewOut = false
        self.CharOverView = true
    else
        self.CharOverView = false
        if IsValid(panel.projectedTexture) then panel.projectedTexture:Remove() end
        self.bOverviewOut = true
    end
end

function PANEL:setActiveTab(key)
    if IsValid(self.tabList[key]) then self.tabList[key]:DoClick() end
end

function PANEL:OnRemove()
    self:RestoreConVars()
end

function PANEL:RestoreConVars()
    RunConsoleCommand("tp_enabled", tostring(self.initialValues.ThirdPerson))
    RunConsoleCommand("tp_vertical", tostring(self.initialValues.ThirdPersonVerticalView))
    RunConsoleCommand("tp_horizontal", tostring(self.initialValues.ThirdPersonHorizontalView))
    RunConsoleCommand("tp_distance", tostring(self.initialValues.ThirdPersonViewDistance))
end

function PANEL:remove()
    CloseDermaMenus()
    if not self.closing then
        self:AlphaTo(0, 0.25, 0, function()
            self:RestoreConVars()
            self:Remove()
        end)

        self.closing = true
    end
end

vgui.Register("liaMenu", PANEL, "EditablePanel")
if IsValid(lia.gui.menu) then vgui.Create("liaMenu") end