local MODULE = MODULE
netstream.Hook("ShowLanguages", function(client)
    local langText = ""
    for k, v in pairs(client:getChar():getData("languages", {})) do
        langText = langText .. MODULE.Languages[k].name .. ": " .. MODULE.Languages[k].desc .. "\n\n"
    end

    local langMenu = vgui.Create("DFrame")
    langMenu:SetSize(500, 700)
    langMenu:Center()
    if me then
        langMenu:SetTitle("Player Menu")
    else
        langMenu:SetTitle(client:Name())
    end

    langMenu:MakePopup()
    langMenu.DS = vgui.Create("DScrollPanel", langMenu)
    langMenu.DS:SetPos(10, 50)
    langMenu.DS:SetSize(500 - 10, 700 - 50 - 10)
    function langMenu.DS:Paint(w, h)
    end

    langMenu.B = vgui.Create("DLabel", langMenu.DS)
    langMenu.B:SetPos(0, 40)
    langMenu.B:SetFont("liaSmallFont")
    langMenu.B:SetText(langText)
    langMenu.B:SetAutoStretchVertical(true)
    langMenu.B:SetWrap(true)
    langMenu.B:SetSize(500 - 20, 10)
    langMenu.B:SetTextColor(Color(255, 255, 255, 255))
end)
