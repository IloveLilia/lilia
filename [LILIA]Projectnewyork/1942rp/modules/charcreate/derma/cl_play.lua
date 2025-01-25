local MODULE = MODULE
function MODULE:Play(panel, gr)
    local curChar = 1
    local chars = {}
    for k, v in pairs(lia.characters) do
        table.insert(chars, lia.char.loaded[v])
    end

    local charPos, charAng = strPosAngConv(MODULE.cMdlPos)
    local function createOrUpdateCharacterModel()
        if IsValid(panel.cmdl) then
            if IsValid(panel.bodyEntity) then panel.bodyEntity:Remove() end
            panel.cmdl:SetModel(chars[curChar]:getModel())
        else
            panel.cmdl = ClientsideModel(chars[curChar]:getModel())
            panel.cmdl:SetPos(charPos)
            panel.cmdl:SetAngles(charAng)
        end

        panel.bodyEntity = ClientsideModel(MALE_BODY, RENDERGROUP_BOTH)
        panel.bodyEntity.BonemergeDoNotClear = true
        panel.bodyEntity:SetParent(panel.cmdl)
        panel.bodyEntity:AddEffects(EF_BONEMERGE)
        -- Set idle animation for cmdl
        local idleSequence = panel.cmdl:LookupSequence("idle")
        if idleSequence > 0 then
            panel.cmdl:SetSequence(idleSequence)
        else
            -- Fallback for models that don't have an "idle" sequence
            local fallbackIdle = panel.cmdl:LookupSequence("idle_all_01")
            if fallbackIdle > 0 then panel.cmdl:SetSequence(fallbackIdle) end
        end

        -- Set idle animation for bodyEntity
        local bodyIdleSequence = panel.bodyEntity:LookupSequence("idle")
        if bodyIdleSequence > 0 then
            panel.bodyEntity:SetSequence(bodyIdleSequence)
        else
            -- Fallback for models that don't have an "idle" sequence
            local fallbackBodyIdle = panel.bodyEntity:LookupSequence("idle_all_01")
            if fallbackBodyIdle > 0 then panel.bodyEntity:SetSequence(fallbackBodyIdle) end
        end
    end
    if #chars > 0 then createOrUpdateCharacterModel() end
    local time = MODULE.DevMode and 0 or 3
    local head = panel.cmdl:LookupBone("ValveBiped.Bip01_Head1")
    local headPos
    if head and head > 0 then
        headPos = panel.cmdl:GetBonePosition(head)
    else
        headPos = Vector(0, 0, 0)
    end

    local finalPos = headPos + Vector(60, 0, 0)
    local finalAng = panel.cmdl:GetAngles() + Angle(0, 180, 0)
    local anim = Derma_Anim("CameraMover", panel, function(pnl, anim, dt, data)
        local lVec = LerpVector(dt ^ 2, self.view.pos, finalPos)
        local lAng = LerpAngle(dt ^ 2, self.view.ang, finalAng)
        MODULE.view.pos = lVec
        MODULE.view.ang = lAng
    end)

    anim:Start(time)
    panel.camMover = anim
    panel.light = true
    local function update()
        curChar = math.Clamp(curChar, 1, #chars)
        createOrUpdateCharacterModel()
        gr.leftArrow:ShouldShow()
        gr.rightArrow:ShouldShow()
        for k, v in pairs(panel.names:GetChildren()) do
            v:SetAlpha(0)
            v:AlphaTo(255, 0.5)
        end

        panel:InvalidateLayout()
    end

    timer.Simple(math.sqrt(time) / 2, function()
        if not panel or not IsValid(panel) then return end
        panel.names = group()
        gr.charName = panel:Add("DLabel")
        gr.charName:SetText("")
        gr.charName:SetFont("WB_Enormous")
        gr.charName:SetColor(color_white)
        gr.charName:SetTall(60)
        function gr.charName:Paint(w, h)
            surface.SetDrawColor(color_white)
            surface.DrawLine(0, h - 1, w - 1, h - 1)
        end

        function gr.charName:PerformLayout()
            gr.charName:SetText((chars[curChar]:getData("banned", false) and " [BANNED] " or "") .. chars[curChar]:getName())
            gr.charName:SizeToContentsX(10)
            gr.charName:SetPos(0, 80)
            gr.charName:CenterHorizontal()
        end

        gr.charName:SetAlpha(0)
        gr.charName:AlphaTo(255, 0.5)
        gr.nextChar = panel:Add("DLabel")
        gr.nextChar:SetText("")
        gr.nextChar:SetFont("WB_Large")
        gr.nextChar:SetColor(Color(200, 200, 200))
        function gr.nextChar:PerformLayout()
            self:SizeToContents()
            local cn = gr.charName
            self:SetPos(cn:GetX() + cn:GetWide() + 30, cn:GetY() + cn:GetTall() - self:GetTall())
        end

        function gr.nextChar:Think()
            local nc = chars[curChar + 1]
            if nc then
                self:SetText(nc:getName())
                panel:InvalidateLayout()
            else
                self:SetText("")
            end
        end

        gr.lastChar = panel:Add("DLabel")
        gr.lastChar:SetText("")
        gr.lastChar:SetFont("WB_Large")
        gr.lastChar:SetColor(Color(200, 200, 200))
        function gr.lastChar:PerformLayout()
            self:SizeToContents()
            local cn = gr.charName
            self:SetPos(cn:GetX() - self:GetWide() - 30, cn:GetY() + cn:GetTall() - self:GetTall())
        end

        function gr.lastChar:Think()
            local nc = chars[curChar - 1]
            if nc then
                self:SetText(nc:getName())
                panel:InvalidateLayout()
            else
                self:SetText("")
            end
        end

        panel.names.nextChar = gr.nextChar
        panel.names.lastChar = gr.lastChar
        panel.names.charName = gr.charName
        gr.leftArrow = panel:Add("DButton")
        gr.leftArrow:SetText("<")
        gr.leftArrow:SetFont("WB_Enormous")
        gr.leftArrow:SetColor(Color(200, 200, 200))
        gr.leftArrow:SizeToContents()
        gr.leftArrow:CenterHorizontal(0.25)
        gr.leftArrow:CenterVertical()
        gr.leftArrow.Paint = nil
        function gr.leftArrow:ShouldShow()
            local nc = chars[curChar - 1]
            if nc then
                self:Show()
            else
                self:Hide()
            end
        end

        function gr.leftArrow:DoClick()
            curChar = curChar - 1
            update()
        end

        gr.rightArrow = panel:Add("DButton")
        gr.rightArrow:SetText(">")
        gr.rightArrow:SetFont("WB_Enormous")
        gr.rightArrow:SetColor(Color(200, 200, 200))
        gr.rightArrow:SizeToContents()
        gr.rightArrow:CenterHorizontal(0.75)
        gr.rightArrow:CenterVertical()
        gr.rightArrow.Paint = nil
        function gr.rightArrow:ShouldShow()
            local nc = chars[curChar + 1]
            if nc then
                self:Show()
            else
                self:Hide()
            end
        end

        function gr.rightArrow:DoClick()
            curChar = curChar + 1
            update()
        end

        gr.leftArrow:ShouldShow()
        gr.rightArrow:ShouldShow()
        gr.choose = panel:menuButton("Choose Character", panel)
        gr.choose:SetPos(0, panel:GetTall() - gr.choose:GetTall() - 50)
        gr.choose:CenterHorizontal()
        function gr.choose:DoClick()
            local char = lia.char.loaded[chars[curChar].id]
            if char:getData("banned", false) then
                lia.util.notify("This Character Is Banned!")
            else
                MODULE:ChooseCharacter(panel, chars[curChar].id)
                panel.bodyEntity:Remove()
            end
        end
    end)
end