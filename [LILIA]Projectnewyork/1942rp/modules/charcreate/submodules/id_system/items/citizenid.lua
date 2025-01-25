ITEM.name = "Identification Document"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.uniqueID = "citizenid"
ITEM.functions.show = {
    icon = "icon16/user.png",
    name = "Show",
    onRun = function(item)
        local ply = item.player
        local target = ply:GetTracedEntity()
        if ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime() then
            ply:notify("You can't see documents that quickly...")
            return false
        end

        ply.NextDocumentCheck = SysTime() + 5
        netstream.Start(target, "OpenID", ply)
        return false
    end,
    onCanRun = function(item)
        local trEnt = item.player:GetEyeTrace().Entity
        return IsValid(trEnt) and trEnt:IsPlayer()
    end
}

ITEM.functions.showself = {
    icon = "icon16/user.png",
    name = "View",
    onRun = function(item)
        local ply = item.player
        if ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime() then
            ply:notify("You can't see documents that quickly...")
            return false
        end

        ply.NextDocumentCheck = SysTime() + 5
        netstream.Start(client, "OpenID", ply)
        return false
    end,
}

ITEM.functions.Drop = nil
