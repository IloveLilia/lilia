ForgedItems = ForgedItems or {}
ForgedItems.List = ForgedItems.List or {}
function ForgedItems.RegisterCustomItem(id, itemData)
    if not id then return end
    local ITEM = lia.item.register(id, nil, false, nil, true)
    if ITEM then
        for k, v in pairs(itemData) do
            ITEM[k] = v
        end

        if itemData.restore then
            ITEM.functions.Use = {
                onRun = function(item)
                    item.player:SetHealth(math.min(item.player:Health() + item.restore, 100))
                    item.player:setLocalVar("stamina", math.min(item.player:getLocalVar("stamina", 100) + item.restore, 100))
                end
            }
        end
    end
end
