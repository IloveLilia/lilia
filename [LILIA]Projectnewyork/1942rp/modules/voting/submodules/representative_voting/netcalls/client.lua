netstream.Hook("CreateRepresentativeVotingMenu", function(ent, Candidates)
    if ent:GetClass() ~= "representativevotingbox" then return end
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Vote for Representatives")
    frame:SetSize(400, 400)
    frame:Center()
    local candidateList = vgui.Create("DPanel", frame)
    candidateList:Dock(FILL)
    local grid = vgui.Create("DGrid", candidateList)
    grid:Dock(FILL)
    grid:SetCols(2)
    grid:SetColWide(200)
    grid:SetRowHeight(40)
    local voteButton = vgui.Create("DButton", frame)
    voteButton:Dock(BOTTOM)
    voteButton:SetText("Vote")
    voteButton:SetSize(0, 40)
    voteButton:SetEnabled(false)
    local selectedCandidates = {}
    for steamID, candidateName in pairs(Candidates) do
        local checkbox = vgui.Create("DCheckBoxLabel")
        checkbox:SetText(candidateName)
        checkbox:SetValue(0)
        checkbox:SetTextColor(color_white)
        checkbox.OnChange = function(self, isChecked)
            if isChecked then
                if #selectedCandidates < 2 then -- Allow only up to 2 selections
                    table.insert(selectedCandidates, {
                        steamID = steamID,
                        name = candidateName
                    })
                else
                    self:SetValue(0) -- Uncheck the checkbox if exceeding the limit
                    Derma_Message("You can only vote for up to 2 candidates.", "Invalid Vote")
                end
            else
                for i, candidate in ipairs(selectedCandidates) do
                    if candidate.steamID == steamID then
                        table.remove(selectedCandidates, i)
                        break
                    end
                end
            end

            voteButton:SetEnabled(#selectedCandidates > 0 and #selectedCandidates <= 2) -- Enable vote button based on selection count
        end

        grid:AddItem(checkbox)
    end

    voteButton.DoClick = function()
        if #selectedCandidates > 0 and #selectedCandidates <= 2 then
            local voteData = {
                candidates = selectedCandidates,
            }

            netstream.Start("SubmitVotes", voteData)
            frame:Close()
        else
            Derma_Message("Please select between 1 to 2 candidates to vote.", "Invalid Vote")
        end
    end

    frame:MakePopup()
end)

netstream.Hook("ChatPrintRepVotes", function(results)
    if results then
        for name, votes in pairs(results) do
            chat.AddText(Color(255, 255, 255), "Name: " .. name .. " Votes: " .. votes)
        end
    else
        chat.AddText(Color(255, 255, 255), "No results available!")
    end
end)

netstream.Hook("ListCurrentCandidates", function(Candidates)
    for index, candidate in ipairs(Candidates) do
        LocalPlayer():ChatPrint("Candidate " .. index .. " - " .. candidate)
    end
end)

netstream.Hook("RepresentativeMenu", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 400)
    frame:SetTitle("Representative Menu")
    frame:Center()
    local buttons = {
        {
            label = "Start Representative Election",
            command = "repelectionnew"
        },
        {
            label = "End Representative Election",
            command = "repelectionend"
        },
        {
            label = "List Current Candidates",
            command = "replistcurrentcandidates"
        },
        {
            label = "Add Candidates",
            command = "repelectionaddcandidate"
        },
        {
            label = "Election Results",
            command = "repelectionresults"
        }
    }

    for i, buttonData in ipairs(buttons) do
        local button = vgui.Create("DButton", frame)
        button:SetText(buttonData.label)
        button:SetSize(200, 30)
        button:SetPos(200, 20 + 35 * (i - 1))
        button.DoClick = function()
            lia.command.send(buttonData.command)
            frame:Close()
        end
    end

    frame:MakePopup()
end)

netstream.Hook("RepAddCandidate", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 150)
    frame:SetTitle("Add Candidate")
    frame:Center()
    frame:MakePopup()
    local candidateEntry = vgui.Create("DTextEntry", frame)
    candidateEntry:Dock(TOP)
    candidateEntry:DockMargin(10, 10, 10, 0)
    candidateEntry:SetPlaceholderText("Enter your Candidate's Name")
    local addButton = vgui.Create("DButton", frame)
    addButton:Dock(TOP)
    addButton:DockMargin(10, 10, 10, 0)
    addButton:SetText("Add Candidate")
    addButton.DoClick = function()
        local candidate = candidateEntry:GetValue()
        if candidate and candidate ~= "" then
            netstream.Start("RepRegisterCandidate", candidate)
            LocalPlayer():ChatPrint("Added Candidate " .. candidate .. " to the representative voting!")
            frame:Close()
        else
            print("Please enter a valid question.")
        end
    end
end)
