local SerialNumberSearch
local PANEL = {}
function PANEL:Init()
    self:MakePopup()
    self:SetSize(350, 300)
    self:SetTitle("Serial Number Search")
    self:Center()
    sList = vgui.Create("DListView", self)
    sList:Dock(FILL)
    sList:AddColumn("Name")
    self.SearchPanel = vgui.Create("DPanel", self)
    self.SearchPanel:Dock(BOTTOM)
    self.SearchPanel:SetTall(25)
    self.SearchPanel.Paint = function() end
    self.SearchPanel.TextEntry = vgui.Create("DTextEntry", self.SearchPanel)
    self.SearchPanel.TextEntry:Dock(FILL)
    self.SearchPanel.TextEntry.AllowInput = function(_, char) if not string.find("0123456789", tostring(char)) then return true end end
    self.SearchPanel.SearchButton = vgui.Create("DButton", self.SearchPanel)
    self.SearchPanel.SearchButton:Dock(RIGHT)
    self.SearchPanel.SearchButton:SetText("Search")
    self.SearchPanel.SearchButton.DoClick = function()
        sList:Clear()
        local SerialNumber = self.SearchPanel.TextEntry:GetInt()
        if isnumber(SerialNumber) then
            net.Start("OwnerRequest")
            net.WriteUInt(SerialNumber, 32)
            net.SendToServer()
        end
    end

    self.InfoText = vgui.Create("DLabel", self)
    self.InfoText:SetText("Enter a Serial number below to search owners")
    self.InfoText:Dock(BOTTOM)
end

function PANEL:ReceiveData(data)
    sList:Clear()
    for i = 1, #data do
        sList:AddLine(data[i])
    end
end

function PANEL:Think()
    if input.IsKeyDown(KEY_ESCAPE) then
        RunConsoleCommand("cancelselect")
        self:Close()
    end
end

function PANEL:OnRemove()
    if SerialNumberSearch then SerialNumberSearch = nil end
end

vgui.Register("Computer", PANEL, "DFrame")
