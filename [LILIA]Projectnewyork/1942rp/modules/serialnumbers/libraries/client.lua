local weaponsFrame
function MODULE:InitiateSerialScratch()
    local weapons = {}
    for id, item in pairs(LocalPlayer():getItems()) do
        if item.isWeapon then table.insert(weapons, item) end
    end

    if weaponsFrame then weaponsFrame:Remove() end
    weaponsFrame = vgui.Create("DFrame")
    weaponsFrame:MakePopup()
    weaponsFrame:SetSize(350, 300)
    weaponsFrame:SetDrawOnTop(true)
    weaponsFrame:DoModal()
    weaponsFrame:SetDraggable(false)
    weaponsFrame:ShowCloseButton(true)
    weaponsFrame:Center()
    weaponsFrame:SetTitle("Choose a weapon")
    weaponsFrame.ListView = vgui.Create("DListView", weaponsFrame)
    weaponsFrame.ListView:Dock(FILL)
    weaponsFrame.ListView:AddColumn("Weapon")
    weaponsFrame.ListView:AddColumn("ID")
    for k, v in pairs(weapons) do
        weaponsFrame.ListView:AddLine(v.name, v.id)
    end

    weaponsFrame.ListView.OnRowSelected = function(_, _, row)
        net.Start("FinishSerialScratch")
        net.WriteUInt(tonumber(row:GetValue(2)), 32)
        net.WriteBool(true)
        net.SendToServer()
        weaponsFrame:Close()
    end

    weaponsFrame.ListView:SortByColumn(1)
    weaponsFrame.CancelButton = vgui.Create("DButton", weaponsFrame)
    weaponsFrame.CancelButton:Dock(BOTTOM)
    weaponsFrame.CancelButton:SetText("Cancel")
    weaponsFrame.CancelButton:SetTall(30)
    weaponsFrame.CancelButton:DockMargin(5, 5, 5, 5)
    weaponsFrame.CancelButton.DoClick = function()
        net.Start("FinishSerialScratch")
        net.WriteBool(false)
        net.SendToServer()
        weaponsFrame:Close()
    end

    weaponsFrame.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45)) end
end
