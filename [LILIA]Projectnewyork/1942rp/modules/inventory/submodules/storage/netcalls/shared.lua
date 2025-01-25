﻿local MODULE = MODULE
netstream.Hook("trunkInitStorage", function(entity)
    if istable(entity) then
        for vehicle, _ in pairs(entity) do
            MODULE:InitializeStorage(vehicle)
        end
    else
        MODULE:InitializeStorage(entity)
    end
end)
