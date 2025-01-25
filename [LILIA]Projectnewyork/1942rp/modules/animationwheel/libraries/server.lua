function ReturnModelGestures(entity)
    if not IsValid(entity) then return end
    for k, v in pairs(entity:GetSequenceList()) do
        local act = entity:GetSequenceActivity(k)
        if act ~= -1 then print(v) end
    end
end