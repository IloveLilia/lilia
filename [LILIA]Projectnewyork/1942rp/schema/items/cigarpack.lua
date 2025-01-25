ITEM.name = "Cigar Box"
ITEM.desc = "A box of Cigars."
ITEM.model = "models/polievka/cigarbox.mdl"
ITEM.price = 50
ITEM.PackNum = 8
ITEM.functions.TakeOutCig = {
    name = "Take out Cigar",
    onRun = function(item)
        local client = item.player
        local inv = client:getChar():getInv()
        item.PackNum = item:getData("cigarleft")
        if item.PackNum > 1 then
            item:setData("cigarleft", item.PackNum - 1)
            inv:add("cigar")
        else
            inv:add("cigar")
            item:remove()
        end
        return false
    end
}

function ITEM:getDesc()
    local cigarleft = self:getData("cigarleft") or 8
    local description = "A box of " .. cigarleft .. " Cigars."
    if cigarleft == 1 then description = "A lone Cigar in a box." end
    return description
end
