﻿function MODULE:isCharRecognized(character, id)
    local client = character:getPlayer()
    local recognized = character:getData("rgn", "")
    local other = lia.char.loaded[id]
    local otherclient = other:getPlayer()
    if not IsValid(otherclient) then return false end
    if character.id == id then return true end
    local faction = lia.faction.indices[other:getFaction()]
    if faction and faction.isGloballyRecognized then return true end
    if character:getFaction() == other:getFaction() and faction.MemberToMemberAutoRecognition then return true end
    if client:isStaffOnDuty() or otherclient:isStaffOnDuty() then return true end
    if recognized ~= "" and recognized:find("," .. id .. ",") then return true end
    return false
end

function MODULE:isCharFakeRecognized(character, id)
    local other = lia.char.loaded[id]
    local CharNameList = character:getRecognizedAs()
    local clientName = CharNameList[other:getID()]
    return self.FakeNamesEnabled and self:isFakeNameExistant(clientName, CharNameList)
end

function MODULE:isFakeNameExistant(name, nameList)
    for _, n in pairs(nameList) do
        if n == name then return true end
    end
    return false
end

lia.char.registerVar("RecognizedAs", {
    field = "recognized_as",
    default = {},
    noDisplay = true
})
