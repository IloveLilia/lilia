﻿local playerMeta = FindMetaTable("Player")
function playerMeta:IsDrunk()
    return self:GetBAC() > lia.config.DrunkNotifyThreshold
end

function playerMeta:GetBAC()
    return self:GetNW2Int("lia_alcoholism_bac", 0)
end