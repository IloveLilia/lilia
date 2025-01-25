function SetPlayerModelAnglesOffset(ply, angles, offset)
    -- Invert the yaw angle and add the offset
    local invertedYaw = angles.yaw - 180 + offset
    -- Create the adjusted angles
    local adjustedAngles = Angle(angles.pitch, invertedYaw, angles.roll)
    ply:SetAngles(adjustedAngles)
end

function MODULE:PlayerBindPress(client, bind, pressed)
    if bind:lower():find("gm_showhelp") and pressed then
        if IsValid(lia.gui.menu) then
            lia.gui.menu:remove()
        elseif client:getChar() then
            vgui.Create("liaMenu")
        end
        return true
    end
end

function MODULE:ShouldDrawLocalPlayer()
    local menu = lia.gui.menu
    if IsValid(menu) and menu:IsVisible() then return false end
end

function MODULE:OnCharInfoSetup(self)
    if not IsValid(self.model) then return end
    local mdl = self.model
    local entity = mdl.Entity
    local client = LocalPlayer()
    if not IsValid(client) or not client:Alive() then return end
    local weapon = client:GetActiveWeapon()
    if not IsValid(weapon) then return end
    local weapModel = ClientsideModel(weapon:GetModel(), RENDERGROUP_BOTH)
    if not IsValid(weapModel) then return end
    weapModel:SetParent(entity)
    weapModel:AddEffects(EF_BONEMERGE)
    weapModel:SetSkin(weapon:GetSkin())
    weapModel:SetColor(weapon:GetColor())
    weapModel:SetNoDraw(true)
    if not IsValid(entity) then return end
    entity.weapon = weapModel
    local act = ACT_MP_STAND_IDLE
    local model = entity:GetModel():lower()
    local class = lia.anim.getModelClass(model)
    local tree = lia.anim[class]
    if not tree then return end
    local subClass = weapon.HoldType or weapon:GetHoldType()
    subClass = lia.anim.HoldTypeTranslator[subClass] or subClass
    if tree[subClass] and tree[subClass][act] then
        local branch = tree[subClass][act]
        local act2 = istable(branch) and branch[1] or branch
        if isstring(act2) then
            act2 = entity:LookupSequence(act2)
        else
            act2 = entity:SelectWeightedSequence(act2)
        end

        entity:ResetSequence(act2)
    end
end

function MODULE:CanPlayerViewInventory()
    return false
end

function MODULE:CanPlayerViewAttributes()
    return false
end

function MODULE:CreateMenuButtons(tabs)
    if hook.Run("CanPlayerViewInventory") ~= false then
        tabs["inv"] = function(panel)
            local inventory = LocalPlayer():getChar():getInv()
            if not inventory then return end
            local mainPanel = inventory:show(panel)
            local sortPanels = {}
            local totalSize = {
                x = 0,
                y = 0,
                p = 0
            }

            table.insert(sortPanels, mainPanel)
            totalSize.x = totalSize.x + mainPanel:GetWide() + 10
            totalSize.y = math.max(totalSize.y, mainPanel:GetTall())
            local px, py, pw, ph = mainPanel:GetBounds()
            local x, y = px + pw / 2 - totalSize.x / 2, py + ph / 2
            for _, panel in pairs(sortPanels) do
                panel:ShowCloseButton(true)
                panel:SetPos(x, y - panel:GetTall() / 2)
                x = x + panel:GetWide() + 10
            end

            hook.Add("PostRenderVGUI", mainPanel, function() hook.Run("PostDrawInventory", mainPanel) end)
        end
    end
end

function MODULE:BuildHelpMenu(tabs)
    tabs["commands"] = function(_, _)
        local body = ""
        for k, v in SortedPairs(lia.command.list) do
            if lia.command.hasAccess(LocalPlayer(), k, nil) then body = body .. "<h2>/" .. k .. "</h2><strong>Syntax:</strong> <em>" .. v.syntax .. "</em><br /><br />" end
        end
        return body
    end

    tabs["flags"] = function(_)
        local body = [[<table border="0" cellspacing="8px">]]
        for k, v in SortedPairs(lia.flag.list) do
            local icon
            if LocalPlayer():getChar():hasFlags(k) then
                icon = [[<img src="asset://garrysmod/materials/icon16/tick.png" />]]
            else
                icon = [[<img src="asset://garrysmod/materials/icon16/cross.png" />]]
            end

            body = body .. Format([[
                <tr>
                    <td>%s</td>
                    <td><b>%s</b></td>
                    <td>%s</td>
                </tr>
            ]], icon, k, v.desc)
        end
        return body .. "</table>"
    end

    tabs["modules"] = function(_)
        local body = ""
        for _, v in SortedPairsByMemberValue(lia.module.list, "name") do
            if v.MenuNoShow then continue end
            body = (body .. [[
                <p>
                    <span style="font-size: 22;"><b>%s</b><br /></span>
                    <span style="font-size: smaller;">
                    <b>%s</b>: %s<br />
                    <b>%s</b>: %s<br /> <!-- Added line break here -->
                    <b>%s</b>: %s<br />
                ]]):format(v.name or "Unknown", L"desc", v.desc or L"noDesc", "Discord", v.discord or "Unknown", L"author", lia.module.namecache[v.author] or v.author or "Unknown")
            if v.version then body = body .. "<br /><b>" .. L"version" .. "</b>: " .. v.version end
            body = body .. "</span></p>"
        end
        return body
    end

    if self.FAQEnabled then
        tabs["FAQ"] = function()
            local body = ""
            for title, text in SortedPairs(self.FAQQuestions) do
                body = body .. "<h2>" .. title .. "</h2>" .. text .. "<br /><br />"
            end
            return body
        end
    end

    if self.RulesEnabled then tabs["Rules"] = function() return self:GenerateRules() end end
    if self.TutorialEnabled then tabs["Tutorial"] = function() return self:GenerateTutorial() end end
end
