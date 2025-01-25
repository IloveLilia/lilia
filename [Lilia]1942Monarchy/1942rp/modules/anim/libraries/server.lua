--------------------------------------------------------------------------------------------------------
local MODULE = MODULE
--------------------------------------------------------------------------------------------------------
function MODULE:GetCrossArmsAnim()
    return {
        ["ValveBiped.Bip01_R_Forearm"] = Angle(-43.7, -107.1, 15.9),
        ["ValveBiped.Bip01_R_UpperArm"] = Angle(20.2, -57.2, -6.1),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle(-28.9, -59.4, 1.0),
        ["ValveBiped.Bip01_R_Thigh"] = Angle(4.7, -6.0, -0.4),
        ["ValveBiped.Bip01_L_Thigh"] = Angle(-7.6, -0.2, 0.4),
        ["ValveBiped.Bip01_L_Forearm"] = Angle(51.0, -120.4, -18.8),
        ["ValveBiped.Bip01_R_Hand"] = Angle(14.4, -33.4, -7.2),
        ["ValveBiped.Bip01_L_Hand"] = Angle(25.9, 31.5, -14.9),
    }
end

--------------------------------------------------------------------------------------------------------
function MODULE:GetSaluteAnim()
    return {
        ["ValveBiped.Bip01_R_UpperArm"] = Angle(80, -95, -77.5),
        ["ValveBiped.Bip01_R_Forearm"] = Angle(35, -125, -5),
    }
end

--------------------------------------------------------------------------------------------------------
function MODULE:GetSurrenderAnim()
    return {
        ["ValveBiped.Bip01_L_Forearm"] = Angle(25, -65, 25),
        ["ValveBiped.Bip01_R_Forearm"] = Angle(-25, -65, -25),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle(-70, -180, 70),
        ["ValveBiped.Bip01_R_UpperArm"] = Angle(70, -180, -70),
    }
end

--------------------------------------------------------------------------------------------------------
function MODULE:GetEaseAnim()
    return {
        ["ValveBiped.Bip01_Head1"] = Angle(0, 12, 0),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle(-6, -6, 0),
        ["ValveBiped.Bip01_R_Forearm"] = Angle(-9, 0, 0),
        ["ValveBiped.Bip01_L_Forearm"] = Angle(9, 0, 0),
        ["ValveBiped.Bip01_R_Thigh"] = Angle(-3, 0, 0),
        ["ValveBiped.Bip01_L_Thigh"] = Angle(3, 5, 0),
        ["ValveBiped.Bip01_R_Foot"] = Angle(20, 0, 0),
        ["ValveBiped.Bip01_L_Foot"] = Angle(-20, 0, 0),
        ["ValveBiped.Bip01_R_Hand"] = Angle(0, 0, 20),
        ["ValveBiped.Bip01_L_Hand"] = Angle(0, 0, -20),
    }
end

--------------------------------------------------------------------------------------------------------
function MODULE:GetAttentionAnim()
    return {
        ["ValveBiped.Bip01_Head1"] = Angle(0, 12, 0),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle(-6, -6, 0),
        ["ValveBiped.Bip01_R_Forearm"] = Angle(-9, 0, 0),
        ["ValveBiped.Bip01_L_Forearm"] = Angle(9, 0, 0),
        ["ValveBiped.Bip01_R_Thigh"] = Angle(-3, 0, 0),
        ["ValveBiped.Bip01_L_Thigh"] = Angle(3, 5, 0),
        ["ValveBiped.Bip01_R_Foot"] = Angle(20, 0, 0),
        ["ValveBiped.Bip01_L_Foot"] = Angle(-20, 0, 0),
        ["ValveBiped.Bip01_R_Hand"] = Angle(0, 0, 20),
        ["ValveBiped.Bip01_L_Hand"] = Angle(0, 0, -20),
    }
end

--------------------------------------------------------------------------------------------------------
function MODULE:GetSurrenderAnim()
    return {
        ["ValveBiped.Bip01_R_UpperArm"] = Angle(30, 0, 90),
        ["ValveBiped.Bip01_L_UpperArm"] = Angle(-30, 0, -90),
        ["ValveBiped.Bip01_R_ForeArm"] = Angle(0, -130, 0),
        ["ValveBiped.Bip01_L_ForeArm"] = Angle(0, -120, 20)
    }
end

--------------------------------------------------------------------------------------------------------
MODULE.AnimTable = {
    [1] = {"surrender_animation_swep", MODULE:GetSurrenderAnim()},
    [2] = {"salute_swep", MODULE:GetSaluteAnim()},
    [3] = {"cross_arms_swep", MODULE:GetCrossArmsAnim()},
    [4] = {"atease_swep", MODULE:GetEaseAnim()},
    [5] = {"attention_swep", MODULE:GetAttentionAnim()},
    [6] = {"surrender_swep", MODULE:GetSurrenderAnim()},
}

--------------------------------------------------------------------------------------------------------
function MODULE:VelocityIsHigher(client, value)
    local x, y, z = math.abs(client:GetVelocity().x), math.abs(client:GetVelocity().y), math.abs(client:GetVelocity().z)
    if x > value or y > value or z > value then
        return true
    else
        return false
    end
end

--------------------------------------------------------------------------------------------------------
function MODULE:ApplyAnimation(client, targetValue, class)
    local classassigned
    if not (IsValid(client) or client:getChar() or client:Alive()) then return end
    for k, v in pairs(self.AnimTable) do
        if class == v[1] then
            classassigned = v[2]
            break
        end
    end

    if not classassigned then return end
    for boneName, angle in pairs(classassigned) do
        local bone = client:LookupBone(boneName)
        if bone then
            if targetValue == 0 then
                client:ManipulateBoneAngles(bone, angle * 0)
            else
                client:ManipulateBoneAngles(bone, angle)
            end
        end
    end
end

--------------------------------------------------------------------------------------------------------
function MODULE:ToggleAnimaton(client, crossing, class, deactivateOnMove)
    if crossing then
        client:SetNWBool("animationStatus", true)
        if class then
            client:SetNWString("animationClass", class)
        end

        client:SetNWInt("deactivateOnMove", deactivateOnMove)
    else
        client:SetNWBool("animationStatus", false)
        client:SetNWInt("deactivateOnMove", 5)
    end
end

--------------------------------------------------------------------------------------------------------
function MODULE:Think()
    for _, client in pairs(player.GetHumans()) do
        local animationClass = client:GetNWString("animationClass")
        if client:GetNWBool("animationStatus") then
            self:ApplyAnimation(client, 1, animationClass)
        else
            self:ApplyAnimation(client, 0, animationClass)
        end
    end
end

--------------------------------------------------------------------------------------------------------
function MODULE:SetupMove(client, moveData, cmd)
    if client:GetNWBool("animationStatus") then
        local deactivateOnMove = client:GetNWInt("deactivateOnMove", 5)
        if self:VelocityIsHigher(client, deactivateOnMove) then
            self:ToggleAnimaton(client, false)
        end

        if client:KeyDown(IN_DUCK) then
            self:ToggleAnimaton(client, false)
        end

        if client:KeyDown(IN_USE) then
            self:ToggleAnimaton(client, false)
        end

        if client:KeyDown(IN_JUMP) then
            self:ToggleAnimaton(client, false)
        end
    end
end
--------------------------------------------------------------------------------------------------------