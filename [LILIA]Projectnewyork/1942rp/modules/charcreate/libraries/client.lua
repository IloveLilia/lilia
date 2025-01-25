local MODULE = MODULE
function MODULE:PlaySound(click)
    local sound = self.hoverSound
    local pitch = 100
    if click then
        sound = self.clickSound
        pitch = 100
    end

    LocalPlayer():EmitSound(sound, 50, pitch, 0.2, CHAN_AUTO)
end

function MODULE:ChooseCharacter(panel, charID)
    local dark = vgui.Create("DPanel")
    dark:SetSize(ScrW(), ScrH())
    dark:Center()
    dark:MakePopup()
    function dark:Paint(w, h)
        surface.SetDrawColor(Color(0, 0, 0))
        surface.DrawRect(0, 0, w, h)
    end

    dark:SetAlpha(0)
    dark:AlphaTo(255, 1.5, 0, function()
        panel:Remove()
        dark:SetKeyboardInputEnabled(false)
        dark:SetMouseInputEnabled(false)
        if LocalPlayer():getChar() == nil or LocalPlayer():getChar():getID() ~= charID then MainMenu:chooseCharacter(charID) end
        dark:AlphaTo(0, 1, 1, function() dark:Remove() end)
    end)
end

function MODULE:SetSequence(cmdl)
    for k, v in pairs(cmdl:GetSequenceList()) do
        if v:find("idle") then
            cmdl:ResetSequence(k)
            break
        end
    end
end

function MODULE:generateDesc(payload)
    local data = payload.data.info
    local desc = [[A male %s stands before you at around %s and weighing around %s pounds. They have %s hair and %s coloured eyes.]]
    desc = desc:format(data.ethnicity, data.height, data.weight, data.haircolor, data.eyecolor)
    return desc
end

function MODULE:LoadFonts()
    surface.CreateFont("introFont", {
        font = "Roboto",
        size = 60,
        weight = 400,
    })
end

net.Receive("openCharMenu", function()
    if IsValid(lia.gui.menu) then lia.gui.menu:Remove() end
    vgui.Create("liaCharacter")
end)
