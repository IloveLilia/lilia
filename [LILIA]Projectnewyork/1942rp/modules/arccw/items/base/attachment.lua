﻿ITEM.name = "Attachment"
ITEM.desc = "An attachment."
ITEM.category = "Attachments"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.att = ""
if CLIENT then
    function ITEM:paintOver(item, w, h)
        if item:getData("equip") then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
        end
    end
end

function ITEM:removeAttachment(client)
    if ArcCW:PlayerTakeAtt(client, self.att, 1) then
        self:setData("equip", nil)
        ArcCW:PlayerSendAttInv(client)
        return true
    end
    return false
end

function ITEM:addAttachment(client)
    ArcCW:PlayerGiveAtt(client, self.att, 1)
    ArcCW:PlayerSendAttInv(client)
end

local function unEquip(item)
    if item:getData("equip") then if not item:removeAttachment(item.player) then item:setData("equip", nil) end end
end

ITEM:hook("transfer", unEquip)
ITEM:hook("drop", unEquip)
ITEM.functions.EquipUn = {
    name = "Unequip",
    tip = "equipTip",
    icon = "icon16/cross.png",
    onRun = function(item)
        if item:removeAttachment(item.player) then
            item.player:notify("Attachment unequipped.")
        else
            item.player:notify("Attachment couldn't be unequipped.")
        end
        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) and item:getData("equip") == true end
}

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    onRun = function(item)
        item:setData("equip", true)
        item:addAttachment(item.player)
        item.player:notify("Attachment equipped.")
        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) and item:getData("equip") ~= true end
}

function ITEM:OnCanBeTransfered(oldInventory, newInventory)
    if newInventory and self:getData("equip") then return false end
    return true
end

function ITEM:onLoadout()
    if self:getData("equip") then self:addAttachment(self.player) end
end

function ITEM:onRemoved()
    if IsValid(receiver) and receiver:IsPlayer() and self:getData("equip") and not self:removeAttachment(receiver) then self:setData("equip", nil) end
end
