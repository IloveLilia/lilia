function MODULE:InitializedModules()
    if SERVER then self:RunServerVars() end
    self:RunVars()
end

function MODULE:InitializedItems()
    timer.Simple(5, function() self:InitAttachmentItems() end)
end

function MODULE:InitAttachmentItems()
    for att, attTable in pairs(ArcCW.AttachmentTable) do
        self:AddAttachment(att, attTable)
    end
end

function MODULE:ItemTransfered(context)
    local client = context.client
    local item = context.item
    if item.base ~= "base_attachment" then return end
    item:removeAttachment(client)
end

function MODULE:AddAttachment(att, attTable)
    local uniqueID = "att_" .. att
    local item = lia.item.register(uniqueID, "base_attachment", false, nil, true)
    item.name = attTable.PrintName
    item.desc = attTable.Description
    item.model = "models/Items/BoxSRounds.mdl"
    item.category = "Attachments"
    item.width = 1
    item.height = 1
    item.att = att
end

function MODULE:RunVars()
    RunConsoleCommand("arccw_npc_atts", 0)
    hook.Remove("PlayerSpawn", "ArcCW_SpawnAttInv")
    hook.Remove("PlayerCanPickupWeapon", "ArcCW_PlayerCanPickupWeapon")
end
