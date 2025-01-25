netstream.Hook("OpenID", function(from)
    if not from then from = LocalPlayer() end
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 430)
    frame:MakePopup()
    frame:Center()
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    local character = from:getChar()
    function frame:OnKeyCodePressed(key)
        if key == KEY_F1 then self:Close() end
    end

    function frame:Paint(w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Color(60, 60, 60, 80), true, true)
    end

    local cover = frame:Add("DPanel")
    cover:SetSize(frame:GetWide() / 2, frame:GetTall() - 30)
    cover:CenterHorizontal()
    cover.mat = Material("passport.png", "smooth")
    function cover:Paint(w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local complete = frame:Add("DPanel")
    complete:SetSize(frame:GetWide(), frame:GetTall() - 30)
    complete:CenterHorizontal()
    complete:SetAlpha(0)
    complete.mat = Material("documents/infos.jpg", "smooth")
    function complete:Paint(w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    function complete:ShowModel()
        self.mdl = self:Add("DModelPanel")
        self.mdl:SetSize(230, 240)
        self.mdl:SetPos((frame:GetWide() / 2) / 2 - self.mdl:GetWide() / 2, 23)
        self.mdl:SetModel(from:GetModel())
        self.mdl:SetFOV(20)
        self.mdl:SetAlpha(0)
        self.mdl:AlphaTo(255, 0.2)
        local head = self.mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")
        if head and head >= 0 then self.mdl:SetLookAt(self.mdl.Entity:GetBonePosition(head)) end
        function self.mdl:LayoutEntity(ent)
            ent:SetAngles(Angle(0, 45, 0))
            ent:ResetSequence(2)
        end
    end

    local name = complete:Add("DLabel")
    name:SetText(from:Nick())
    name:SetFont("liaMediumFont")
    name:SetColor(Color(60, 60, 60))
    name:SizeToContents()
    name:SetPos((complete:GetWide() / 2) / 2 - name:GetWide() / 2, complete:GetTall() - 100)
    local inf = complete:Add("DPanel")
    inf:SetSize(frame:GetWide() / 2 - 10, complete:GetTall() - 30)
    inf:SetPos(10, 10) -- Move the panel to the left with some margin
    inf.Paint = nil
    inf.list = inf:Add("DListLayout")
    inf.list:Dock(FILL)
    inf.list:SetPos(10, 10) -- Add a margin within the panel
    local descgenerator = character:getDescgenerator()
    if isstring(descgenerator) then descgenerator = util.JSONToTable(descgenerator) end
    local gender = "Male"
    local mdl = character:getModel()
    if string.lower(mdl):find("female", 1, true) then gender = "Female" end
    local data = {
        {
            key = "Name",
            value = character:getName()
        },
        {
            key = "Age",
            value = descgenerator["age"] or "N/A"
        },
        {
            key = "Ethnicity",
            value = descgenerator["ethnicity"] or "N/A"
        },
        {
            key = "Gender",
            value = gender
        },
        {
            key = "Blood Type",
            value = descgenerator["bloodtype"] or "N/A"
        },
        {
            key = "Hair Color",
            value = descgenerator["haircolor"] or "N/A"
        },
        {
            key = "Eye Color",
            value = descgenerator["eyecolor"] or "N/A"
        },
        {
            key = "Height",
            value = descgenerator["height"]
        },
        {
            key = "Weight",
            value = (descgenerator["weight"] or 0) .. " lbs"
        },
        {
            key = "Number",
            value = character:getID()
        },
        {
            key = "ID",
            value = "SS000" .. character:getID()
        },
    }

    for _, item in pairs(data) do
        local i = inf.list:Add("DPanel")
        i:SetTall(23)
        i.Paint = nil
        i.key = i:Add("DLabel")
        i.key:SetText(item.key)
        i.key:SetFont("liaSmallFont")
        i.key:SetColor(Color(60, 60, 60))
        i.key:SizeToContents()
        i.val = i:Add("DLabel")
        i.val:SetText(item.value)
        i.val:SetFont("liaSmallFont")
        i.val:SetColor(Color(60, 60, 60))
        i.val:SizeToContents()
        i.val:SetPos(inf.list:GetWide() - i.val:GetWide() - 30)
    end

    local cont = frame:Add("DButton")
    cont:SetSize(frame:GetWide(), 30)
    cont:SetPos(0, frame:GetTall() - cont:GetTall())
    cont:SetText("Continue")
    cont:SetFont("liaSmallFont")
    cont:SetColor(color_white)
    cont.finish = false
    function cont:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBoxEx(4, 0, 0, w, h, Color(46, 152, 204), false, false, true, true)
        else
            draw.RoundedBoxEx(4, 0, 0, w, h, Color(60, 60, 60, 80), false, false, true, true)
        end
    end

    function cont:DoClick()
        cover:MoveTo(frame:GetWide() - cover:GetWide(), 0, 0.2, 0.2, -1, function()
            cover:AlphaTo(0, 0.2)
            complete:AlphaTo(255, 0.2, 0, function()
                complete:ShowModel()
                self:SetText("Finish")
                self.finish = true
                self.DoClick = function(this) frame:AlphaTo(0, 0.2, 0, function() if frame and IsValid(frame) then frame:Remove() end end) end
            end)
        end)
    end
end)