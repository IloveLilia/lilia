net.Receive("RequestID", function(len, ply)
    lia.util.notifQuery("A player is requesting to see your ID.", "Accept", "Deny", true, NOT_CORRECT, function(code)
        if code == 1 then
            net.Start("ApproveID")
            net.WriteBool(true)
            net.SendToServer()
        elseif code == 2 then
            net.Start("ApproveID")
            net.WriteBool(false)
            net.SendToServer()
        end
    end)
end)
