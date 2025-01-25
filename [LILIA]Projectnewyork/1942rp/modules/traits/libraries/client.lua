function MODULE:ConfigureCharacterCreationSteps(panel)
    panel:addStep(vgui.Create("liaCharTraits"), 100)
end
--[[function MODULE:CreateMenuButtons(tabs)
    if table.Count(self.Traits) > 0 then
        tabs["Traits"] = function(panel)
            panel.traits = panel:Add("DScrollPanel")
            panel.traits:Dock(FILL)
            panel.traits:DockMargin(0, 10, 0, 0)
            if not IsValid(panel.traits) then return end
            local client = LocalPlayer()
            for k, v in SortedPairsByMemberValue(self.Traits, "name") do
                local hasTrait = self:hasTrait(client, k)
                local bar = panel.traits:Add("liaAttribBar")
                bar:Dock(TOP)
                bar:DockMargin(0, 0, 0, 3)
                bar:setValue(hasTrait and 1 or 0)
                bar:setMax(1)
                bar:setReadOnly()
                bar:setText(L(v.name))
            end
        end
    end
end]]
