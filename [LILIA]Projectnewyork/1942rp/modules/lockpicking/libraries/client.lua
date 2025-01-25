function MODULE:DrawCharInfo(client, character, info)
    if client:getNetVar("isPicking") then info[#info + 1] = {"Lockpicking...", Color(255, 100, 100)} end
end

function MODULE:PlayerBindPress(client, bind, pressed)
    if string.find(bind, "+use") and client:getNetVar("isPicking") or string.find(bind, "+attack" or string.find(bind, "+attack2") and client:getNetVar("isPicking")) and client:getNetVar("isPicking") then return true end
end
