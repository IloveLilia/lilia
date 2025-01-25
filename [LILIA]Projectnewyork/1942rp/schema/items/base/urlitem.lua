ITEM.name = "URL Items Base"
ITEM.model = "models/weapons/kerry/w_garrys_pass.mdl"
ITEM.url = ""
ITEM.functions.show = {
    icon = "icon16/user.png",
    name = "Show",
    onRun = function(item)
        net.Start("OpenURL")
        net.WriteString(item.url)
        net.Send(item.player)
        return false
    end
}

if CLIENT then
    net.Receive("OpenURL", function(len)
        local url = net.ReadString()
        gui.OpenURL(url)
    end)
else
    util.AddNetworkString("OpenURL")
end
