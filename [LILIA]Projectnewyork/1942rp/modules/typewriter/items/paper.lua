ITEM.name = "Document"
ITEM.desc = "A piece of thick paper, quite fancy. Looks official."
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1
function ITEM:getName()
    return self:getData("documentName", self.name)
end

function ITEM:getDesc()
    return Format("%s %s %s", self.desc, self:getData("documentBody") and "This document has something written on it." or "This document is blank.", LocalPlayer():IsAdmin() and ("This document was created by " .. self:getData("creator", "N/A")) or "")
end

ITEM.functions.view = {
    name = "View",
    onClick = function(item)
        local document = vgui.Create("liaDocument")
        document:SetDocument(item)
    end,
    onRun = function(item) return false end,
    onCanRun = function(item) return item:getData("documentBody") and true or false end,
}
