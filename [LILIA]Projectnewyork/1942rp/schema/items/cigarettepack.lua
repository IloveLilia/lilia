ITEM.name = "Cigarette Pack"
ITEM.desc = "A pack of cigarettes."
ITEM.model = "models/mosi/fallout4/props/junk/cigarettepack.mdl"
ITEM.price = 50
ITEM.PackNum = 5
ITEM.functions.TakeOutCig = {
    name = "Take out Cigarette",
    onRun = function(item)
        local client = item.player
        local inv = client:getChar():getInv()
        item.PackNum = item:getData("cigLeft")
        if item.PackNum > 1 then
            item:setData("cigLeft", item.PackNum - 1)
            inv:add("cigarette")
        else
            inv:add("cigarette")
            item:remove()
        end
        return false
    end
}

function ITEM:getDesc()
    local cigLeft = self:getData("cigLeft") or 5
    local description = "A pack of " .. cigLeft .. " cigarettes."
    if cigLeft == 1 then description = "A lone cigarette in a pack." end
    return description
end
