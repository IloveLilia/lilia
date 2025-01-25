local MODULE = MODULE
ITEM.name = "Base Language Book"
ITEM.model = "models/props_lab/binderblue.mdl"
ITEM.description = "A book that teaches you how to speak a language."
ITEM.langKey = ""
ITEM.category = "Books"
ITEM.price = 0
ITEM.functions.LearnLanguage = {
    name = "Learn Language",
    tip = "equipTip",
    icon = "icon16/tick.png",
    onRun = function(item)
        local client = item.player
        local character = client:getChar()
        if not character then return false end
        local langKey = item.langKey
        local langName = MODULE.LanguageTable[langKey]
        if not langName then
            client:notify("Invalid language.")
            return false
        end

        local langData = character:getData("languages", {})
        if langData[langKey] then
            client:notify("You already know the " .. langName .. " language.")
            return false
        end

        langData[langKey] = 1
        character:setData("languages", langData, false, player.GetAll())
        client:notify("You have learned the " .. langName .. " language.")
        return true
    end,
    onCanRun = function(item)
        local client = item.player
        local character = client:getChar()
        if not character then return false end
        local langKey = item.langKey
        local langData = character:getData("languages", {})
        if langData[langKey] then return false end
        return true
    end
}
