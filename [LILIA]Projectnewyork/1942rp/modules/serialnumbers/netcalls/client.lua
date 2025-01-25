net.Receive("OwnerRequest", function() if SerialNumberSearch then SerialNumberSearch:ReceiveData(net.ReadTable()) end end)
net.Receive("OpenComputer", function()
    if SerialNumberSearch then SerialNumberSearch:Close() end
    SerialNumberSearch = vgui.Create("Computer")
end)
