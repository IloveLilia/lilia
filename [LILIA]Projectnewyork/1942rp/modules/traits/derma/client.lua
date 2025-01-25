local MODULE = MODULE
local PANEL = {}
function PANEL:Init()
    self.title = self:addLabel("Select Traits")
    self.traits = self:Add("DScrollPanel")
    self.traits:Dock(FILL)
    self.traits:SetPaintBackground(false)
end

function PANEL:onDisplay()
    local total = total or 0
    local traits = {}
    for k, v in SortedPairsByMemberValue(MODULE.Traits, "category") do
        local bar = self:Add("liaAttribBar")
        bar:setMax(1)
        bar:Dock(TOP)
        bar:DockMargin(2, 2, 2, 2)
        bar:setText(v.name)
        bar.onChanged = function(this, difference)
            if (total + difference) > 1 then return false end
            total = total + difference
            if traits[k] then
                traits[k] = nil
            else
                traits[k] = 1
            end

            self:setContext("traits", traits)
        end

        bar.bar.OnMousePressed = function(this)
            if bar.value == 0 then
                bar.pressing = 1
                bar:doChange()
            else
                bar.pressing = -1
                bar:doChange()
            end
        end

        bar.bar.OnMouseReleased = function() if bar.pressing then bar.pressing = nil end end
    end
end

vgui.Register("liaCharTraits", PANEL, "liaCharacterCreateStep")
