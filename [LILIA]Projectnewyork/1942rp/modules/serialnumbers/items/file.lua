ITEM.name = "File"
ITEM.desc = "A file to scratch the serial number off a gun."
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl"
ITEM.functions.Use = {
    name = "Use",
    icon = "icon16/tick.png",
    onRun = function(item)
        MODULE:InitiateSerialScratch()
        item:remove()
    end,
    onCanRun = function() return true end
}
