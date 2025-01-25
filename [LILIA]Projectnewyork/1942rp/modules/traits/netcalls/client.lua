local MODULE = MODULE
netstream.Hook("ShowTraits", function(client)
    local traitText = ""
    for k, v in pairs(client:getChar():getData("traits", {})) do
        traitText = traitText .. MODULE.Traits[k].name .. ": " .. MODULE.Traits[k].desc .. "\n\n"
    end

    local traitMenu = vgui.Create("DFrame")
    traitMenu:SetSize(500, 700)
    traitMenu:Center()
    if me then
        traitMenu:SetTitle("Player Menu")
    else
        traitMenu:SetTitle(client:Name())
    end

    traitMenu:MakePopup()
    traitMenu.DS = vgui.Create("DScrollPanel", traitMenu)
    traitMenu.DS:SetPos(10, 50)
    traitMenu.DS:SetSize(500 - 10, 700 - 50 - 10)
    function traitMenu.DS:Paint(w, h)
    end

    traitMenu.B = vgui.Create("DLabel", traitMenu.DS)
    traitMenu.B:SetPos(0, 40)
    traitMenu.B:SetFont("liaSmallFont")
    traitMenu.B:SetText(traitText)
    traitMenu.B:SetAutoStretchVertical(true)
    traitMenu.B:SetWrap(true)
    traitMenu.B:SetSize(500 - 20, 10)
    traitMenu.B:SetTextColor(Color(255, 255, 255, 255))
end)
