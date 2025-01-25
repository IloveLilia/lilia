function MODULE:openNotes(client, target, edit)
    if IsValid(target) and target:getChar() then
        local charID = target:getChar():getID()
        local path = "lilia/" .. SCHEMA.folder .. "/charnotes/" .. charID
        local notes = {
            [1] = {
                name = "Name: " .. target:Nick(),
                data = file.Read(path .. ".txt") or "",
                size = {400, 400},
                pos = {0.29, 0.5},
                saveFunc = "lia_charNoteSave",
            },
        }

        netstream.Start(client, "lia_charNoteOpen", charID, notes, edit)
    end
end

function MODULE:LoadData()
    local path = "lilia/" .. SCHEMA.folder .. "/charnotes/"
    if not file.Exists(path, "DATA") then file.CreateDir("lilia/" .. SCHEMA.folder .. "/charnotes/") end
end

netstream.Hook("lia_charNoteSave", function(client, charID, notes)
    local path = "lilia/" .. SCHEMA.folder .. "/charnotes/" .. charID .. ".txt"
    file.Write(path, notes)
end)
