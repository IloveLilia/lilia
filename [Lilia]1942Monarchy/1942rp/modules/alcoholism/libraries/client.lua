--------------------------------------------------------------------------------------------------------
function MODULE:RenderScreenspaceEffects()
    if LocalPlayer():GetNW2Int("lia_alcoholism_bac", 0) > 0 then
        DrawMotionBlur(lia.config.AlcoholismAddAlpha, LocalPlayer():GetNW2Int("lia_alcoholism_bac", 0) / 100, lia.config.AlcoholismEffectDelay)
    end
end
--------------------------------------------------------------------------------------------------------
function MODULE:DrawCharInfo(client, character, info)
    if client:IsDrunk() then
        info[#info + 1] = {"This Person Is Heavily Intoxicated", Color(245, 215, 110)}
    end
end
--------------------------------------------------------------------------------------------------------