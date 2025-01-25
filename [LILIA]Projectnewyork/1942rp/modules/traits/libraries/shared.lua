local MODULE = MODULE
function MODULE:Register(tbl)
    self.Traits[tbl.uid] = tbl
end

for k, v in pairs(lia.config.TraitsTable) do
    local Trait = {}
    Trait.uid = k
    Trait.name = k
    Trait.desc = v
    MODULE:Register(Trait)
end

function MODULE:hasTrait(client, trait)
    local char = client:getChar()
    if not char then return end
    local traitData = char:getData("traits")
    if traitData and traitData[trait] then return true end
    return false
end

lia.char.registerVar("traits", {
    field = "_traits",
    default = {},
    index = 9999,
    isLocal = true,
    onDisplay = function(panel, y)
        local container = panel:Add("DScrollPanel")
        container:SetPos(panel.lastX, y)
        container:SetSize(ScrW() * 0.25, ScrH() * 0.2)
        local y2 = 0
        local total = 0
        panel.payload.traits = {}
        for k, v in SortedPairsByMemberValue(MODULE.Traits, "category") do
            panel.payload.traits[k] = nil
            local bar = container:Add("liaAttribBar")
            bar:SetTooltip(v.desc)
            bar:setMax(1)
            bar:Dock(TOP)
            bar:DockMargin(2, 2, 2, 2)
            bar:setText(v.name)
            bar.onChanged = function(this, difference)
                if (total + difference) > 1 then return false end
                total = total + difference
                if panel.payload.traits[k] == nil then
                    panel.payload.traits[k] = 1
                else
                    panel.payload.traits[k] = nil
                end
            end

            y2 = y2 + bar:GetTall() + 4
        end
        return container
    end,
    onValidate = function(value, data, client)
        if value ~= nil then
            if type(value) == "table" then
                local count = 0
                for k, v in pairs(value) do
                    count = count + v
                end

                if count > 1 then return false, "unknownError" end
            else
                return false, "unknownError"
            end
        end
    end,
    onAdjust = function(client, data, value, newData)
        newData.data = newData.data or {}
        newData.data.traits = data.traits
    end,
    shouldDisplay = function(panel) return table.Count(MODULE.Traits) > 0 end
})

function MODULE:WalletLimit(client)
    if self:hasTrait(client, "The Banker") then return 100000 end
end
