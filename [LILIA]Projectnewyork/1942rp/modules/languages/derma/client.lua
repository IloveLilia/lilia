local MODULE = MODULE
local PANEL = {}
function PANEL:Init()
    self.title = self:addLabel("Select Languages")
    self.languages = self:Add("DScrollPanel")
    self.languages:Dock(FILL)
    self.languages:SetPaintBackground(false)
end

function PANEL:onDisplay()
    local total = total or 0
    local languages = {}
    for k, v in SortedPairsByMemberValue(MODULE.Languages, "category") do
        local bar = self:Add("liaAttribBar")
        bar:setMax(1)
        bar:Dock(TOP)
        bar:DockMargin(2, 2, 2, 2)
        bar:setText(v.name)
        bar.onChanged = function(this, difference)
            if (total + difference) > 1 then return false end
            total = total + difference
            if languages[k] then
                languages[k] = nil
            else
                languages[k] = 1
            end

            self:setContext("languages", languages)
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

vgui.Register("liaCharLanguages", PANEL, "liaCharacterCreateStep")
