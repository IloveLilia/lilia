net.Receive(
    "advert_client",
    function()
        local nick = net.ReadString()
        local message = net.ReadString()
        chat.AddText(Color(216, 190, 18), "[Advertisement by " .. nick .. "]: ", Color(255, 255, 255), message)
    end
)