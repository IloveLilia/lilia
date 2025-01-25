--------------------------------------------------------------------------------------------------------
ITEM.name = "Cigarette Pack"
ITEM.desc = "A pack of cigarettes."
ITEM.model = "models/unconid/props_pack/cigarette_pack.mdl"
ITEM.price = 50
ITEM.PackNum = 20
--------------------------------------------------------------------------------------------------------
ITEM.functions.TakeOutCig = {
    name = "Take out cigarette",
    onRun = function(item)
        local client = item.player
        local inv = client:getChar():getInv()
        item.PackNum = item:getData("cigLeft")

        if item.PackNum > 1 then
            item:setData("cigLeft", item.PackNum - 1)
            inv:add("cig")
        else
            inv:add("cig")
            item:remove()
        end

        return false
    end
}
--------------------------------------------------------------------------------------------------------
function ITEM:getDesc()
    local cigLeft = self:getData("cigLeft") or 5
    local description = "A pack of " .. cigLeft .. " cigarettes."

    if cigLeft == 1 then
        description = "A lone cigarette in a pack."
    end

    return description
end
--------------------------------------------------------------------------------------------------------