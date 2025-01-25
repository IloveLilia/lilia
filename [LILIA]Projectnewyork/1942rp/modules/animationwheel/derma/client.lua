local MODULE = MODULE
local function ReturnGestures()
    local gestures = {}
    local client = LocalPlayer()
    if not IsValid(client) then return gestures end
    local playerTeam = client:Team()
    local globalAnimations = MODULE.GlobalAnimationsWhitelist
    local teamAnimations = MODULE.FactionAnimationsWhitelist[playerTeam] or {}
    local allAnimations = {}
    for _, anim in ipairs(globalAnimations) do
        allAnimations[anim] = true
    end

    for _, anim in ipairs(teamAnimations) do
        allAnimations[anim] = true
    end

    for k, v in pairs(client:GetSequenceList()) do
        local act = client:GetSequenceActivity(k)
        if act ~= -1 and allAnimations[v] then
            table.insert(gestures, {
                name = v,
                gesturePath = v
            })
        end
    end
    return gestures
end

local PANEL = {}
function PANEL:Init()
    local gestures = ReturnGestures()
    self:SetSize(ScrW(), ScrH())
    self.gestButtons = {}
    local numSquares = #gestures
    local interval = 360 / numSquares
    local centerX, centerY = self:GetWide() * 0.485, self:GetTall() * 0.45
    local radius = 240
    for degrees = 1, 360, interval do
        local x, y = PointOnCircle(degrees, radius, centerX, centerY)
        local gestButton = self:Add("DButton")
        gestButton:SetFont("MenuFontNoClamp")
        gestButton:SetText("...")
        gestButton:SetPos(x, y)
        self.gestButtons[#self.gestButtons + 1] = gestButton
        gestButton.Paint = function(s, w, h) FramePaint(s, w, h) end
        gestButton.DoClick = function(btn) self:Remove() end
    end

    for k, v in ipairs(gestures) do
        local btn = self.gestButtons[k]
        if btn then
            local name = v.name or "Unknown"
            local gesturePath = v.gesturePath or ""
            btn:SetText(name)
            btn:SetTextColor(Color(255, 255, 255))
            btn.DoClick = function()
                if gesturePath ~= "" then
                    net.Start("AskForGestureAnimation")
                    net.WriteString(gesturePath)
                    net.SendToServer()
                    self:Remove()
                else
                    print("Error: gesturePath is nil or empty for gesture:", name)
                end
            end

            btn:SetWide(ScreenScale(128 / 3))
            btn:SetHeight(ScreenScale(64 / 3))
        end
    end

    self.closeButton = self:Add("DButton")
    self.closeButton:Dock(BOTTOM)
    self.closeButton:SetFont("MenuFontNoClamp")
    self.closeButton:SetText("Close")
    self.closeButton:SetTextColor(Color(255, 255, 255))
    self.closeButton:SetHeight(ScreenScale(64 / 3))
    self.closeButton.Paint = function(s, w, h) FramePaint(s, w, h) end
    self.closeButton.DoClick = function(btn) self:Remove() end
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(Color(63, 58, 115, 100))
    surface.DrawRect(0, 0, width, height)
    Derma_DrawBackgroundBlur(self, 0)
end

function PANEL:FramePaint(s, w, h)
    surface.SetDrawColor(Color(0, 0, 0, 50))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(100, 100, 100, 150))
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:PointOnCircle(ang, radius, offX, offY)
    ang = math.rad(ang)
    local x = math.cos(ang) * radius + offX
    local y = math.sin(ang) * radius + offY
    return x, y
end

vgui.Register("GestureWheel", PANEL)
