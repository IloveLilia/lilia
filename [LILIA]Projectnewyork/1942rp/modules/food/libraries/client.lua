lia.bar.add(function()
    local hunger = 0
    local maxHunger = 100
    if LocalPlayer():getChar() then hunger = LocalPlayer():getHunger() end
    return math.Clamp(hunger / maxHunger, 0, 1)
end, Color(50, 180, 100), nil, "hunger_new")

lia.bar.add(function()
    local thrist = 0
    local maxThrist = 100
    if LocalPlayer():getChar() then thrist = LocalPlayer():getThrist() end
    return math.Clamp(thrist / maxThrist, 0, 1)
end, Color(80, 150, 220), nil, "thrist_new")
