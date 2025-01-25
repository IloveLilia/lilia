util.AddNetworkString("AskForGestureAnimation")
util.AddNetworkString("OpenGestureWheel")
util.AddNetworkString("GestureAnimation")
net.Receive("AskForGestureAnimation", function(len, client)
    local gest = net.ReadString()
    if not client:IsPlayer() or (client.GestDelay and client.GestDelay > CurTime()) then return end
    client:PlayGestureAnimation(client:LookupSequence(gest))
    client.GestDelay = CurTime() + 1
end)
