--------------------------------------------------------------------------------------------------------
net.Receive(
    "OpenCommandUI",
    function()
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 300)
        frame:SetTitle("Animations")
        frame:SetVisible(true)
        frame:Center()
        local commands = {"surrender", "salute", "crossarms", "atease", "attention", "timedsalute"}
        for _, command in pairs(commands) do
            local button = vgui.Create("DButton", frame)
            button:SetText(command)
            button:Dock(TOP)
            button:DockMargin(5, 5, 5, 5)
            button.DoClick = function()
                net.Start("RunCommand")
                net.WriteString(command)
                net.SendToServer()
                frame:Close()
            end
        end

        frame:MakePopup()
    end
)
--------------------------------------------------------------------------------------------------------