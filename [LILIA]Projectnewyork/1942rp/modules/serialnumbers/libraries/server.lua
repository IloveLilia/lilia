SerialNumbersTable = {}
function MODULE:OnItemAdded(client, item)
    if item.base == "base_weapons" and not item:getData("serialNumberDefined", false) then self:SerialNumberGenerate(client, item) end
end

function MODULE:SerialNumberGenerate(client, item)
    local SerialNumber = math.random(11111111, 99999999)
    local ownerChar = client:getChar()
    local charName = ownerChar:getName()
    if not table.HasValue(SerialNumbersTable, SerialNumber) then
        table.insert(SerialNumbersTable, SerialNumber)
        item:setData("gunSerialNumber", SerialNumber)
        item:setData("serialNumberOwner", charName)
        item:setData("serialNumberDefined", true)
    end
end
