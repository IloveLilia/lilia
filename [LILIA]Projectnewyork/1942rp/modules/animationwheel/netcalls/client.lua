net.Receive("OpenGestureWheel", function() vgui.Create("GestureWheel") end)
net.Receive("GestureAnimation", function()
    local client = net.ReadEntity()
    if not IsValid(client) then return end
    local sequence = net.ReadString()
    client:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, sequence, 0, true)
end)
