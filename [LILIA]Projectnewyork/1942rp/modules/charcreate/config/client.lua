MODULE.CharacterCharacteristics = {
    ["Eye Color"] = {"Green", "Blue", "Brown", "Amber"},
    ["Hair Color"] = {"Black", "Brown", "Blond", "Grey", "Bald", "Auburn"},
    ["Blood Type"] = {"O-", "O+", "A-", "A+", "B-", "B+", "AB+", "AB-"},
    ["Ethnicity"] = {"American", "Russian", "Romanian", "Hungarian", "Finnish", "Caucasian", "Baltic", "Danish", "Dutch", "French", "German", "Italian", "Japanese", "Polish", "Swedish", "English", "Irish", "Scottish", "Canadian"},
    ["Age"] = function(val) return val .. " years old" end,
    ["Weight"] = function(val) return val .. " lbs" end,
    ["Height"] = function(val) end
}

MODULE.hoverSound = "song.mp3"
MODULE.clickSound = "song.mp3"
MODULE.MainTheme = "intro_music.mp3"
MODULE.cMdlPos = "setpos -353.987457 9.994422 -2050.468750;setang 0 0 0.000000"
MODULE.backDrop = "setpos 234.913284 10.061234 -2008.895508;setang -1.441009 -179.951645 0.000000"