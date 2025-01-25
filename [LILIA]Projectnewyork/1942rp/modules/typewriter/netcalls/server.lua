util.AddNetworkString("CreateDocumentInv")
util.AddNetworkString("liaOpenTypewriter")
net.Receive("CreateDocumentInv", function(len, ply)
    ply.TypewriterAntiSpam = ply.TypewriterAntiSpam or CurTime()
    local timeRemaining = ply.TypewriterAntiSpam - CurTime()
    if ply.TypewriterAntiSpam > CurTime() then
        ply:notify("You must wait 5 minutes to use the Typewriter again. You must wait " .. math.ceil(timeRemaining) .. " more second(s).")
        return
    end

    ply.TypewriterAntiSpam = CurTime() + 300
    local documentName = net.ReadString()
    local documentBody = net.ReadString()
    local quantityAmount = net.ReadInt(32)
    local inventory = ply:getChar():getInv()
    local characterName = ply:getChar():getName()
    if quantityAmount > tonumber(lia.config.MaxQuantityAmount) or quantityAmount < 1 then
        ply:notify("Cheating ass bastard. Stop trying to hack to the typewriters.")
        return
    end

    local titleTooLong = #documentName > 128
    local titleTooShort = #documentName == 0
    if titleTooLong or titleTooShort then
        ply:notify(titleTooLong and "The title cannot be longer than 128 characters in length!" or "The title cannot be empty!")
        return
    end

    local bodyTooLong = #documentBody > 256
    local bodyTooShort = #documentBody < 16
    if bodyTooLong or bodyTooShort then
        ply:notify(bodyTooLong and "The document body cannot be longer than 256 characters in length!" or "The document body cannot be any shorter than 16 characters in length!")
        return
    end

    if inventory and string.StartsWith(documentBody, "https://docs.google.com/") then
        timer.Create("CreateItemDocuments", 0.5, quantityAmount, function()
            inventory:add("paper", 1, {
                documentName = documentName,
                documentBody = documentBody,
                creator = characterName
            })
        end)

        ply:notify('You created ' .. quantityAmount .. ' document(s) titled "' .. documentName .. '".')
    else
        ply:notify("Something went wrong. Try again.")
        return
    end
end)
