local function openItemBankCL(itemBankID)
    local inventory = lia.inventory.instances[itemBankID]
    if inventory then
        local ply = LocalPlayer()
        local localInv = ply:getChar():getInv()
        local itemBankInv = inventory
        if not localInv or not itemBankInv then return false end
        local localInvPanel = localInv:show()
        local itemBankInvPanel = itemBankInv:show()
        localInvPanel:ShowCloseButton(true)
        itemBankInvPanel:ShowCloseButton(true)
        localInvPanel:CenterHorizontal(0.70)
        localInvPanel:CenterVertical()
        function localInvPanel:OnRemove()
            itemBankInvPanel:Remove()
        end

        itemBankInvPanel:SetTitle("Item Bank")
        itemBankInvPanel:CenterHorizontal(0.30)
        itemBankInvPanel:CenterVertical()
        function itemBankInvPanel:OnRemove()
            localInvPanel:Remove()
        end
    else
        return
    end
end

netstream.Hook("OpenItemBank", openItemBankCL)
local function BankingATMDerma(id)
    net.Start("Banking::GetBankBalance")
    net.WriteUInt(id, 32)
    net.SendToServer()
    local width, height = ScrW(), ScrH()
    local frame_background = Color(20, 20, 20)
    local frame_header_background = Color(40, 40, 40)
    local red_button_hovered = Color(189, 32, 0)
    local red_button = Color(138, 23, 0)
    local gray_button = Color(35, 35, 35)
    local color_white = Color(255, 255, 255)
    Banking.AccountActions = {
        ["DEPOSIT"] = function(id)
            Banking.PopUpBG = vgui.Create("DFrame")
            Banking.PopUpBG:SetSize(width, height)
            Banking.PopUpBG:ShowCloseButton(false)
            Banking.PopUpBG:SetDraggable(false)
            Banking.PopUpBG:SetBackgroundBlur(true)
            Banking.PopUpBG:SetTitle("")
            Banking.PopUpBG.Paint = function(self, w, h) lia.util.drawBlur(self) end
            Banking.PopupPanel = vgui.Create("DFrame")
            Banking.PopupPanel:SetTitle("")
            Banking.PopupPanel:SetSize(width * 0.2, height * 0.125)
            Banking.PopupPanel:Center()
            Banking.PopupPanel:SetDraggable(false)
            Banking.PopupPanel:SetBackgroundBlur(true)
            Banking.PopupPanel:MakePopup()
            Banking.PopupPanel.Paint = function(self, w, h)
                draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
                draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
                draw.DrawText("Deposit", "BankingTitleFont", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
            end

            Banking.PopupPanel.Text = Banking.PopupPanel:Add("DLabel")
            Banking.PopupPanel.Text:Dock(TOP)
            Banking.PopupPanel.Text:SetZPos(1)
            Banking.PopupPanel.Text:SetContentAlignment(5)
            Banking.PopupPanel.Text:SetText("How much would you like to deposit?")
            Banking.PopupPanel.Text:SetFont("BankingButtonText")
            Banking.PopupPanel.Text:DockMargin(0, 15, 0, 0)
            Banking.PopupPanel.Text:SizeToContents()
            Banking.PopupPanel.Entry = Banking.PopupPanel:Add("DTextEntry")
            Banking.PopupPanel.Entry:Dock(TOP)
            Banking.PopupPanel.Entry:SetZPos(2)
            Banking.PopupPanel.Entry:SetPlaceholderText("Amount")
            Banking.PopupPanel.Entry:SetText("")
            Banking.PopupPanel.Entry:DockMargin(0, 12, 0, 0)
            Banking.PopupPanel.Button = Banking.PopupPanel:Add("DButton")
            Banking.PopupPanel.Button:SetText("Deposit")
            Banking.PopupPanel.Button:Dock(BOTTOM)
            Banking.PopupPanel.Button:SetZPos(3)
            Banking.PopupPanel.Button:SetSize(Banking.PopupPanel:GetWide() * 0.95, 30)
            Banking.PopupPanel.Button:SetColor(color_white)
            Banking.PopupPanel.Button:SetFont("BankingButtonText")
            Banking.PopupPanel.Button.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
                else
                    draw.RoundedBox(0, 0, 0, w, h, red_button)
                end
            end

            function Banking.PopupPanel.Button:DoClick()
                local amount = tonumber(Banking.PopupPanel.Entry:GetText())
                if not amount or amount <= 0 then return end
                net.Start("Banking::PlayerBankDeposit")
                net.WriteUInt(amount, 32)
                net.WriteUInt(id, 32)
                net.SendToServer()
                Banking.PopupPanel:Close()
                Banking.PopUpBG:Close()
            end

            Banking.PopupPanel.btnClose:Hide()
            Banking.FrameClose = Banking.PopupPanel:Add("DButton")
            Banking.FrameClose:SetSize(50, 30)
            Banking.FrameClose:SetText("X")
            Banking.FrameClose:SetFont("BankingGenText")
            Banking.FrameClose:SetColor(color_white)
            function Banking.FrameClose.PerformLayout(this, w, h)
                this:SetPos(Banking.PopupPanel:GetWide() - w)
            end

            function Banking.FrameClose:Paint(w, h)
                if Banking.FrameClose:IsHovered() then
                    draw.RoundedBoxEx(6, 0, 0, w, h, red_button_hovered, false, true)
                else
                    draw.RoundedBoxEx(6, 0, 0, w, h, red_button, false, true)
                end
            end

            function Banking.FrameClose.DoClick()
                Banking.PopupPanel:Close()
                Banking.PopUpBG:Close()
            end
        end,
        ["WITHDRAW"] = function(id)
            Banking.PopUpBG = vgui.Create("DFrame")
            Banking.PopUpBG:SetSize(width, height)
            Banking.PopUpBG:ShowCloseButton(false)
            Banking.PopUpBG:SetDraggable(false)
            Banking.PopUpBG:SetBackgroundBlur(true)
            Banking.PopUpBG:SetTitle("")
            Banking.PopUpBG.Paint = function(self, w, h) lia.util.drawBlur(self) end
            Banking.PopupPanel = vgui.Create("DFrame")
            Banking.PopupPanel:SetTitle("")
            Banking.PopupPanel:SetSize(width * 0.2, height * 0.125)
            Banking.PopupPanel:Center()
            Banking.PopupPanel:SetDraggable(false)
            Banking.PopupPanel:MakePopup()
            Banking.PopupPanel.Paint = function(self, w, h)
                draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
                draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
                draw.DrawText("Withdraw", "BankingTitleFont", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
            end

            Banking.PopupPanel.Text = Banking.PopupPanel:Add("DLabel")
            Banking.PopupPanel.Text:Dock(TOP)
            Banking.PopupPanel.Text:SetZPos(1)
            Banking.PopupPanel.Text:SetContentAlignment(5)
            Banking.PopupPanel.Text:SetText("How much would you like to withdraw?")
            Banking.PopupPanel.Text:SetFont("BankingButtonText")
            Banking.PopupPanel.Text:DockMargin(0, 15, 0, 0)
            Banking.PopupPanel.Text:SizeToContents()
            Banking.PopupPanel.Entry = Banking.PopupPanel:Add("DTextEntry")
            Banking.PopupPanel.Entry:Dock(TOP)
            Banking.PopupPanel.Entry:SetZPos(2)
            Banking.PopupPanel.Entry:SetPlaceholderText("Amount")
            Banking.PopupPanel.Entry:SetText("")
            Banking.PopupPanel.Entry:DockMargin(0, 12, 0, 0)
            Banking.PopupPanel.Button = Banking.PopupPanel:Add("DButton")
            Banking.PopupPanel.Button:SetText("Withdraw")
            Banking.PopupPanel.Button:Dock(BOTTOM)
            Banking.PopupPanel.Button:SetZPos(3)
            Banking.PopupPanel.Button:SetSize(Banking.PopupPanel:GetWide() * 0.95, 30)
            Banking.PopupPanel.Button:SetColor(color_white)
            Banking.PopupPanel.Button:SetFont("BankingButtonText")
            Banking.PopupPanel.Button.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
                else
                    draw.RoundedBox(0, 0, 0, w, h, red_button)
                end
            end

            function Banking.PopupPanel.Button:DoClick()
                local amount = tonumber(Banking.PopupPanel.Entry:GetText())
                if not amount or amount <= 0 then return end
                net.Start("Banking::PlayerBankWithdraw")
                net.WriteUInt(amount, 32)
                net.WriteUInt(id, 32)
                net.SendToServer()
                Banking.PopupPanel:Close()
                Banking.PopUpBG:Close()
            end

            Banking.PopupPanel.btnClose:Hide()
            Banking.FrameClose = Banking.PopupPanel:Add("DButton")
            Banking.FrameClose:SetSize(50, 30)
            Banking.FrameClose:SetText("X")
            Banking.FrameClose:SetFont("BankingGenText")
            Banking.FrameClose:SetColor(color_white)
            function Banking.FrameClose.PerformLayout(this, w, h)
                this:SetPos(Banking.PopupPanel:GetWide() - w)
            end

            function Banking.FrameClose:Paint(w, h)
                if Banking.FrameClose:IsHovered() then
                    draw.RoundedBoxEx(6, 0, 0, w, h, red_button_hovered, false, true)
                else
                    draw.RoundedBoxEx(6, 0, 0, w, h, red_button, false, true)
                end
            end

            function Banking.FrameClose.DoClick()
                Banking.PopupPanel:Close()
                Banking.PopUpBG:Close()
            end
        end,
        ["BANKTRANSFER"] = function(id)
            Banking.PopUpBG = vgui.Create("DFrame")
            Banking.PopUpBG:SetSize(width, height)
            Banking.PopUpBG:ShowCloseButton(false)
            Banking.PopUpBG:SetDraggable(false)
            Banking.PopUpBG:SetBackgroundBlur(true)
            Banking.PopUpBG:SetTitle("")
            Banking.PopUpBG.Paint = function(self, w, h) lia.util.drawBlur(self) end
            Banking.PopupPanel = vgui.Create("DFrame")
            Banking.PopupPanel:SetTitle("")
            Banking.PopupPanel:SetSize(width * 0.2, height * 0.175)
            Banking.PopupPanel:Center()
            Banking.PopupPanel:SetDraggable(false)
            Banking.PopupPanel:MakePopup()
            Banking.PopupPanel.Paint = function(self, w, h)
                draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
                draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
                draw.DrawText("Transfer", "BankingTitleFont", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
            end

            Banking.PopupPanel.Text1 = Banking.PopupPanel:Add("DLabel")
            Banking.PopupPanel.Text1:Dock(TOP)
            Banking.PopupPanel.Text1:SetZPos(1)
            Banking.PopupPanel.Text1:SetContentAlignment(5)
            Banking.PopupPanel.Text1:SetText("Which account number would you like to transfer to?")
            Banking.PopupPanel.Text1:SetFont("BankingButtonText")
            Banking.PopupPanel.Text1:SizeToContents()
            Banking.PopupPanel.Text1:DockMargin(0, 15, 0, 0)
            Banking.PopupPanel.Entry1 = Banking.PopupPanel:Add("DTextEntry")
            Banking.PopupPanel.Entry1:Dock(TOP)
            Banking.PopupPanel.Entry1:SetZPos(2)
            Banking.PopupPanel.Entry1:SetPlaceholderText("Account Number")
            Banking.PopupPanel.Entry1:SetText("")
            Banking.PopupPanel.Entry1:DockMargin(0, 8, 0, 0)
            Banking.PopupPanel.Text2 = Banking.PopupPanel:Add("DLabel")
            Banking.PopupPanel.Text2:Dock(TOP)
            Banking.PopupPanel.Text2:SetZPos(3)
            Banking.PopupPanel.Text2:SetContentAlignment(5)
            Banking.PopupPanel.Text2:SetText("How much would you like to transfer?")
            Banking.PopupPanel.Text2:SetFont("BankingButtonText")
            Banking.PopupPanel.Text2:SizeToContents()
            Banking.PopupPanel.Text2:DockMargin(0, 8, 0, 0)
            Banking.PopupPanel.Entry2 = Banking.PopupPanel:Add("DTextEntry")
            Banking.PopupPanel.Entry2:Dock(TOP)
            Banking.PopupPanel.Entry2:SetZPos(4)
            Banking.PopupPanel.Entry2:SetPlaceholderText("Amount")
            Banking.PopupPanel.Entry2:SetText("")
            Banking.PopupPanel.Entry2:DockMargin(0, 8, 0, 0)
            Banking.PopupPanel.Button = Banking.PopupPanel:Add("DButton")
            Banking.PopupPanel.Button:SetText("Transfer")
            Banking.PopupPanel.Button:Dock(BOTTOM)
            Banking.PopupPanel.Button:SetZPos(5)
            Banking.PopupPanel.Button:SetSize(Banking.PopupPanel:GetWide() * 0.95, 30)
            Banking.PopupPanel.Button:SetColor(color_white)
            Banking.PopupPanel.Button:SetFont("BankingButtonText")
            Banking.PopupPanel.Button.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
                else
                    draw.RoundedBox(0, 0, 0, w, h, red_button)
                end
            end

            function Banking.PopupPanel.Button:DoClick()
                local to_account_number = tonumber(Banking.PopupPanel.Entry1:GetText())
                local amount = tonumber(Banking.PopupPanel.Entry2:GetText())
                if not amount or amount <= 0 then return end
                if not to_account_number or to_account_number <= 0 then return end
                net.Start("Banking::PlayerBankTransfer")
                net.WriteUInt(id, 32)
                net.WriteUInt(to_account_number, 32)
                net.WriteUInt(amount, 32)
                net.SendToServer()
                Banking.PopupPanel:Close()
                Banking.PopUpBG:Close()
            end

            Banking.PopupPanel.btnClose:Hide()
            Banking.FrameClose = Banking.PopupPanel:Add("DButton")
            Banking.FrameClose:SetSize(50, 30)
            Banking.FrameClose:SetText("X")
            Banking.FrameClose:SetFont("BankingButtonText")
            Banking.FrameClose:SetColor(color_white)
            function Banking.FrameClose.PerformLayout(this, w, h)
                this:SetPos(Banking.PopupPanel:GetWide() - w)
            end

            function Banking.FrameClose:Paint(w, h)
                if Banking.FrameClose:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
                else
                    draw.RoundedBox(0, 0, 0, w, h, red_button)
                end
            end

            function Banking.FrameClose.DoClick()
                Banking.PopupPanel:Close()
                Banking.PopUpBG:Close()
            end
        end,
    }

    Banking.AccountFrame = vgui.Create("DFrame")
    Banking.AccountFrame:SetSize(width * 0.20, height * 0.32)
    Banking.AccountFrame:SetDraggable(false)
    Banking.AccountFrame:Center()
    Banking.AccountFrame:MakePopup()
    Banking.AccountFrame:SetTitle("")
    Banking.AccountFrame.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
        draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
        draw.DrawText("Automatic Teller Machine", "BankingTitleFont", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
    end

    Banking.AccountFrame.btnClose:Hide()
    Banking.AccountFrame.FrameClose = Banking.AccountFrame:Add("DButton")
    Banking.AccountFrame.FrameClose:SetSize(50, 30)
    Banking.AccountFrame.FrameClose:SetText("X")
    Banking.AccountFrame.FrameClose:SetFont("BankingButtonText")
    Banking.AccountFrame.FrameClose:SetColor(color_white)
    function Banking.AccountFrame.FrameClose.PerformLayout(this, w, h)
        this:SetPos(Banking.AccountFrame:GetWide() - w)
    end

    function Banking.AccountFrame.FrameClose:Paint(w, h)
        if Banking.AccountFrame.FrameClose:IsHovered() then
            draw.RoundedBoxEx(6, 0, 0, w, h, red_button_hovered, false, true)
        else
            draw.RoundedBoxEx(6, 0, 0, w, h, red_button, false, true)
        end
    end

    function Banking.AccountFrame.FrameClose.DoClick()
        Banking.AccountFrame:Close()
    end

    Banking.AccountFrame:SetAlpha(0)
    timer.Simple(0.05, function()
        if not Banking.AccountFrame or not IsValid(Banking.AccountFrame) then return end
        local x, y = Banking.AccountFrame:GetPos()
        Banking.AccountFrame:SetPos(x + 50, y + 50)
        Banking.AccountFrame:MoveTo(x, y, 0.3, 0, -1)
        Banking.AccountFrame:AlphaTo(255, 0.3, 0.15)
    end)

    Banking.AccountFrame.AccountBalance = Banking.AccountFrame:Add("DLabel")
    Banking.AccountFrame.AccountBalance:Dock(TOP)
    Banking.AccountFrame.AccountBalance:DockMargin(0, 23, 0, 0)
    Banking.AccountFrame.AccountBalance:SetZPos(1)
    Banking.AccountFrame.AccountBalance:SetContentAlignment(5)
    Banking.AccountFrame.AccountBalance:SetText("Loading...")
    Banking.AccountFrame.AccountBalance:SetFont("BankBalance")
    net.Receive("Banking::ReceiveBankBalance", function(len, ply)
        local bankBalance = net.ReadUInt(32)
        Banking.AccountFrame.AccountBalance:SetText("Balance: $" .. string.Comma(bankBalance, ","))
    end)

    Banking.AccountFrame.AccountManagement = Banking.AccountFrame:Add("DLabel")
    Banking.AccountFrame.AccountManagement:Dock(TOP)
    Banking.AccountFrame.AccountManagement:DockMargin(0, 15, 0, 0)
    Banking.AccountFrame.AccountManagement:SetZPos(2)
    Banking.AccountFrame.AccountManagement:SetContentAlignment(5)
    Banking.AccountFrame.AccountManagement:SetText("Account Management (#" .. id .. ")")
    Banking.AccountFrame.AccountManagement:SetFont("BankingGenText")
    Banking.AccountFrame.ButtonDeposit = Banking.AccountFrame:Add("DButton")
    Banking.AccountFrame.ButtonDeposit:Dock(TOP)
    Banking.AccountFrame.ButtonDeposit:DockMargin(0, 15, 0, 0)
    Banking.AccountFrame.ButtonDeposit:SetZPos(3)
    Banking.AccountFrame.ButtonDeposit:SetText("Deposit")
    Banking.AccountFrame.ButtonDeposit:SetSize(Banking.AccountFrame:GetWide() * 0.95, 30)
    Banking.AccountFrame.ButtonDeposit:SetColor(color_white)
    Banking.AccountFrame.ButtonDeposit:SetFont("BankingButtonText")
    Banking.AccountFrame.ButtonDeposit.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
        else
            draw.RoundedBox(0, 0, 0, w, h, gray_button)
        end
    end

    function Banking.AccountFrame.ButtonDeposit:DoClick()
        Banking.AccountActions["DEPOSIT"](id)
    end

    Banking.AccountFrame.ButtonWithdraw = Banking.AccountFrame:Add("DButton")
    Banking.AccountFrame.ButtonWithdraw:Dock(TOP)
    Banking.AccountFrame.ButtonWithdraw:DockMargin(0, 12, 0, 0)
    Banking.AccountFrame.ButtonWithdraw:SetZPos(4)
    Banking.AccountFrame.ButtonWithdraw:SetText("Withdraw")
    Banking.AccountFrame.ButtonWithdraw:SetSize(Banking.AccountFrame:GetWide() * 0.95, 30)
    Banking.AccountFrame.ButtonWithdraw:SetColor(color_white)
    Banking.AccountFrame.ButtonWithdraw:SetFont("BankingButtonText")
    Banking.AccountFrame.ButtonWithdraw.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
        else
            draw.RoundedBox(0, 0, 0, w, h, gray_button)
        end
    end

    function Banking.AccountFrame.ButtonWithdraw:DoClick()
        Banking.AccountActions["WITHDRAW"](id)
    end

    Banking.AccountFrame.ButtonTransfer = Banking.AccountFrame:Add("DButton")
    Banking.AccountFrame.ButtonTransfer:Dock(TOP)
    Banking.AccountFrame.ButtonTransfer:DockMargin(0, 12, 0, 0)
    Banking.AccountFrame.ButtonTransfer:SetZPos(5)
    Banking.AccountFrame.ButtonTransfer:SetText("Transfer")
    Banking.AccountFrame.ButtonTransfer:SetSize(Banking.AccountFrame:GetWide() * 0.95, 30)
    Banking.AccountFrame.ButtonTransfer:SetColor(color_white)
    Banking.AccountFrame.ButtonTransfer:SetFont("BankingButtonText")
    Banking.AccountFrame.ButtonTransfer.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
        else
            draw.RoundedBox(0, 0, 0, w, h, gray_button)
        end
    end

    function Banking.AccountFrame.ButtonTransfer:DoClick()
        Banking.AccountActions["BANKTRANSFER"](id)
    end

    Banking.AccountFrame.ButtonItemBank = Banking.AccountFrame:Add("DButton")
    Banking.AccountFrame.ButtonItemBank:Dock(TOP)
    Banking.AccountFrame.ButtonItemBank:DockMargin(0, 12, 0, 0)
    Banking.AccountFrame.ButtonItemBank:SetZPos(6)
    Banking.AccountFrame.ButtonItemBank:SetText("Item Bank")
    Banking.AccountFrame.ButtonItemBank:SetSize(Banking.AccountFrame:GetWide() * 0.95, 30)
    Banking.AccountFrame.ButtonItemBank:SetColor(color_white)
    Banking.AccountFrame.ButtonItemBank:SetFont("BankingButtonText")
    Banking.AccountFrame.ButtonItemBank.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
        else
            draw.RoundedBox(0, 0, 0, w, h, gray_button)
        end
    end

    function Banking.AccountFrame.ButtonItemBank:DoClick()
        net.Start("Banking::PlayerOpenItemBank")
        net.WriteUInt(id, 32)
        net.SendToServer()
        Banking.AccountFrame:Close()
    end

    Banking.AccountFrame.ButtonViewLogs = Banking.AccountFrame:Add("DButton")
    Banking.AccountFrame.ButtonViewLogs:Dock(TOP)
    Banking.AccountFrame.ButtonViewLogs:DockMargin(0, 12, 0, 0)
    Banking.AccountFrame.ButtonViewLogs:SetZPos(7)
    Banking.AccountFrame.ButtonViewLogs:SetText("View Logs")
    Banking.AccountFrame.ButtonViewLogs:SetSize(Banking.AccountFrame:GetWide() * 0.95, 30)
    Banking.AccountFrame.ButtonViewLogs:SetColor(color_white)
    Banking.AccountFrame.ButtonViewLogs:SetFont("BankingButtonText")
    Banking.AccountFrame.ButtonViewLogs.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
        else
            draw.RoundedBox(0, 0, 0, w, h, gray_button)
        end
    end

    function Banking.AccountFrame.ButtonViewLogs:DoClick()
        net.Start("Banking::ViewLogs")
        net.WriteString(tostring(id))
        net.SendToServer()
        Banking.AccountFrame:Close()
    end
end

net.Receive("Banking::SendLogs", function()
    local bankLogs = net.ReadTable()
    local PANEL = vgui.Create("DFrame")
    PANEL:SetTitle("Transaction Logs")
    PANEL:SetSize(600, 400)
    PANEL:Center()
    local listView = vgui.Create("DListView", PANEL)
    listView:Dock(FILL)
    listView:SetMultiSelect(false)
    listView:AddColumn("Date/Time")
    listView:AddColumn("Log")
    for _, log in ipairs(bankLogs) do
        local line = listView:AddLine(log.timestamp, log.message)
        line:SetSortValue(1, log.timestamp)
    end

    listView:SortByColumn(1)
    PANEL:MakePopup()
end)

net.Receive("liaDrawBankLogs", function()
    local logs = net.ReadTable()
    local logFrame = vgui.Create("DFrame")
    logFrame:SetSize(600, 300)
    logFrame:SetTitle("Bank Log Viewer")
    logFrame:Center()
    logFrame:MakePopup()
    local logList = vgui.Create("DListView", logFrame)
    logList:Dock(FILL)
    logList:SetMultiSelect(false)
    logList:AddColumn("Account Number")
    logList:AddColumn("Balance")
    logList:AddColumn("Character ID")
    logList:AddColumn("Item Bank ID")
    logList:AddColumn("Steam ID")
    for _, logEntry in ipairs(logs) do
        logList:AddLine(logEntry.account_number, logEntry.balance, logEntry.charid, logEntry.itembankid, logEntry.steamid)
    end
end)

net.Receive("Banking::OpenBankerUI", function()
    local width, height = ScrW(), ScrH()
    local Frame = vgui.Create("DFrame")
    Frame:SetSize(width * 0.20, height * 0.18)
    Frame:SetDraggable(false)
    Frame:Center()
    Frame:MakePopup()
    Frame:SetTitle("")
    Frame.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, Color(20, 20, 20, 255), true, true, true, true)
        draw.RoundedBoxEx(6, 0, 0, w, 30, Color(40, 40, 40, 255), true, true, false, false)
        draw.DrawText("New York City Central Bank", "BankingTitleFont", w * 0.5, 8, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText("Hello! Welcome to the New York Central Bank.\nWould you like to open an account today?", "BankerGeneralFont", w * 0.5, 47, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end

    Frame.btnClose:Hide()
    local FrameClose = Frame:Add("DButton")
    FrameClose:SetSize(50, 30)
    FrameClose:SetText("X")
    FrameClose:SetFont("BankerGeneralFont")
    FrameClose:SetColor(color_white)
    function FrameClose.PerformLayout(this, w, h)
        this:SetPos(Frame:GetWide() - w)
    end

    function FrameClose:Paint(w, h)
        if FrameClose:IsHovered() then
            draw.RoundedBoxEx(6, 0, 0, w, h, Color(189, 32, 0), false, true)
        else
            draw.RoundedBoxEx(6, 0, 0, w, h, Color(138, 23, 0), false, true)
        end
    end

    function FrameClose.DoClick()
        Frame:Close()
    end

    Frame:SetAlpha(0)
    timer.Simple(0.05, function()
        if not Frame or not IsValid(Frame) then return end
        local x, y = Frame:GetPos()
        Frame:SetPos(x + 50, y + 50)
        Frame:MoveTo(x, y, 0.3, 0, -1)
        Frame:AlphaTo(255, 0.3, 0.15)
    end)

    local ply = LocalPlayer()
    Frame.ButtonYes = Frame:Add("DButton")
    if ply:getChar():getData("NumberofBankAccounts", 0) == 0 then
        Frame.ButtonYes:SetText("Yes, please! ($1,000)", 0)
    else
        Frame.ButtonYes:SetText("You are at the MAX amount of bank accounts!")
    end

    Frame.ButtonYes:SetPos(Frame:GetWide() * 0.025, 100)
    Frame.ButtonYes:SetSize(Frame:GetWide() * 0.95, 30)
    if ply:getChar():getData("NumberofBankAccounts") == 1 then
        Frame.ButtonYes:SetColor(Color(128, 128, 128))
    else
        Frame.ButtonYes:SetColor(Color(255, 255, 255))
    end

    Frame.ButtonYes:SetFont("BankerGeneralFont")
    Frame.ButtonYes.Paint = function(self, w, h)
        if self:IsHovered() then
            if ply:getChar():getData("NumberofBankAccounts") == 1 then
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(138, 23, 0))
            end
        else
            if ply:getChar():getData("NumberofBankAccounts") == 1 then
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35))
            end
        end
    end

    function Frame.ButtonYes:DoClick()
        if ply:getChar():getData("NumberofBankAccounts") == 1 then
            Frame:Close()
        else
            net.Start("Banking::BankerCreateAccount")
            net.SendToServer()
            Frame:Close()
        end
    end

    Frame.ButtonNo = Frame:Add("DButton")
    Frame.ButtonNo:SetText("No, I'm good.")
    Frame.ButtonNo:SetPos(Frame:GetWide() * 0.025, 145)
    Frame.ButtonNo:SetSize(Frame:GetWide() * 0.95, 30)
    Frame.ButtonNo:SetColor(Color(255, 255, 255))
    Frame.ButtonNo:SetFont("BankerGeneralFont")
    Frame.ButtonNo.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(138, 23, 0))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35))
        end
    end

    function Frame.ButtonNo:DoClick()
        Frame:Close()
    end
end)

net.Receive("Banking::TransmitBankGUI", function(len, ply)
    local accounts = net.ReadTable()
    local width, height = ScrW(), ScrH()
    local frame_background = Color(20, 20, 20)
    local frame_header_background = Color(40, 40, 40)
    local red_button_hovered = Color(189, 32, 0)
    local red_button = Color(138, 23, 0)
    local gray_button = Color(35, 35, 35)
    local color_white = Color(255, 255, 255)
    Banking.MainFrame = vgui.Create("DFrame")
    Banking.MainFrame:SetSize(width * 0.2, height * 0.35)
    Banking.MainFrame:SetDraggable(false)
    Banking.MainFrame:Center()
    Banking.MainFrame:MakePopup()
    Banking.MainFrame:SetTitle("")
    Banking.MainFrame.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, frame_background, true, true, true, true)
        draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
        draw.DrawText("Select Your Account", "BankingTitleFont", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
    end

    Banking.MainFrame.btnClose:Hide()
    Banking.MainFrame.FrameClose = Banking.MainFrame:Add("DButton")
    Banking.MainFrame.FrameClose:SetSize(50, 30)
    Banking.MainFrame.FrameClose:SetText("X")
    Banking.MainFrame.FrameClose:SetFont("BankingGenText")
    Banking.MainFrame.FrameClose:SetColor(color_white)
    function Banking.MainFrame.FrameClose.PerformLayout(this, w, h)
        this:SetPos(Banking.MainFrame:GetWide() - w)
    end

    function Banking.MainFrame.FrameClose:Paint(w, h)
        if Banking.MainFrame.FrameClose:IsHovered() then
            draw.RoundedBoxEx(6, 0, 0, w, h, red_button_hovered, false, true)
        else
            draw.RoundedBoxEx(6, 0, 0, w, h, red_button, false, true)
        end
    end

    function Banking.MainFrame.FrameClose.DoClick()
        Banking.MainFrame:Close()
    end

    Banking.MainFrame:SetAlpha(0)
    timer.Simple(0.05, function()
        if not Banking.MainFrame or not IsValid(Banking.MainFrame) then return end
        local x, y = Banking.MainFrame:GetPos()
        Banking.MainFrame:SetPos(x + 50, y + 50)
        Banking.MainFrame:MoveTo(x, y, 0.3, 0, -1)
        Banking.MainFrame:AlphaTo(255, 0.3, 0.15)
    end)

    Banking.MainFrame.TextOne = Banking.MainFrame:Add("DLabel")
    Banking.MainFrame.TextOne:Dock(TOP)
    Banking.MainFrame.TextOne:SetZPos(1)
    Banking.MainFrame.TextOne:SetContentAlignment(5)
    Banking.MainFrame.TextOne:SetFont("BankingGenText")
    Banking.MainFrame.TextOne:SetText("Please select which account you would like to access:")
    Banking.MainFrame.TextOne:SizeToContents()
    Banking.MainFrame.TextOne:DockMargin(0, 15, 0, 0)
    Banking.MainFrame.ScrollPanel = Banking.MainFrame:Add("DScrollPanel")
    Banking.MainFrame.ScrollPanel:Dock(FILL)
    if table.IsEmpty(accounts) then return end
    for k, account in ipairs(accounts) do
        Banking.MainFrame.Button = Banking.MainFrame.ScrollPanel:Add("DButton")
        Banking.MainFrame.Button:SetText("Account #" .. account.account_number)
        Banking.MainFrame.Button:Dock(TOP)
        Banking.MainFrame.Button:SetZPos(2)
        Banking.MainFrame.Button:DockMargin(0, 15, 0, 0)
        Banking.MainFrame.Button:SetSize(Banking.MainFrame:GetWide() * 0.95, 30)
        Banking.MainFrame.Button:SetColor(color_white)
        Banking.MainFrame.Button:SetFont("BankingButtonText")
        Banking.MainFrame.Button.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, red_button_hovered)
            else
                draw.RoundedBox(0, 0, 0, w, h, gray_button)
            end
        end

        function Banking.MainFrame.Button:DoClick()
            BankingATMDerma(account.account_number)
            Banking.MainFrame:Close()
        end
    end
end)

net.Receive("Banking::OpenBankGUI", function(len, ply)
    net.Start("Banking::SendBankGUI")
    net.SendToServer()
end)

function MODULE:LoadFonts()
    surface.CreateFont("BankingTitleFont", {
        font = "Roboto",
        size = 16,
        weight = 300,
    })

    surface.CreateFont("BankerGeneralFont", {
        font = "Roboto",
        size = 16,
        weight = 500,
    })

    surface.CreateFont("BankBalance", {
        font = "Roboto",
        size = 28,
        weight = 800,
    })

    surface.CreateFont("BankingGenText", {
        font = "Roboto",
        size = 16,
        weight = 500,
    })

    surface.CreateFont("BankingButtonText", {
        font = "Roboto",
        size = 14,
        weight = 500,
    })
end
