netstream.Hook("CreateLegislativeVotingMenu", function(ent, topics, steamids, lpsteamid)
    local currentTopicIndex = 1
    -- Create the frame
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:SetTitle("Legislative Voting")
    frame:Center()
    frame:MakePopup()
    -- Create the topic label
    local topicLabel = vgui.Create("DLabel", frame)
    topicLabel:SetText("Topic:")
    topicLabel:SetTextColor(Color(255, 255, 255)) -- Set text color to white
    topicLabel:SetContentAlignment(5)
    topicLabel:SizeToContents()
    topicLabel:CenterHorizontal()
    -- Create the topic text
    local topictext = vgui.Create("DLabel", frame)
    topictext:SetTextColor(Color(255, 255, 255)) -- Set text color to white
    topictext:SetContentAlignment(5)
    topictext:SizeToContents()
    topictext:CenterHorizontal()
    -- Create the vote button
    local voteButton = vgui.Create("DButton", frame)
    voteButton:SetSize(100, 30)
    voteButton:SetText("Vote")
    voteButton:CenterHorizontal()
    -- Create the vote combo box
    local voteComboBox = vgui.Create("DComboBox", frame)
    voteComboBox:SetSize(100, 25)
    voteComboBox:AddChoice("Aye")
    voteComboBox:AddChoice("Nye")
    voteComboBox:AddChoice("Abstain")
    voteComboBox:ChooseOptionID(3)
    -- Layout and docking
    topicLabel:Dock(TOP)
    topictext:Dock(TOP)
    voteButton:Dock(BOTTOM)
    voteComboBox:Dock(BOTTOM)
    -- Update the topic text
    topictext.DoLayout = function()
        print(topics[currentTopicIndex])
        topictext:SetText(topics[currentTopicIndex])
        topictext:SizeToContents()
        topictext:CenterHorizontal()
    end

    -- Handle vote button click
    voteButton.DoClick = function()
        local vote = voteComboBox:GetValue()
        if vote then
            local selectedTopic = topics[currentTopicIndex]
            if selectedTopic then
                netstream.Start("SendVote", selectedTopic, vote, ent)
                currentTopicIndex = currentTopicIndex + 1
                if currentTopicIndex <= #topics then
                    topictext.DoLayout()
                else
                    netstream.Start("RegisterFinaledVoting")
                    frame:Close()
                end
            else
                Derma_Message("No more topics available.", "Error", "OK")
            end
        else
            Derma_Message("Please select a vote.", "Error", "OK")
        end
    end

    topictext.DoLayout()
end)

netstream.Hook("ChatPrintLegVotes", function(results)
    if istable(results) then
        for topic, votes in pairs(results) do
            if topic == "Abstain" or topic == "Aye" or topic == "Nye" then continue end
            if istable(votes) then
                local voteCounts = {
                    Abstain = 0,
                    Aye = 0,
                    Nye = 0
                }

                for typeofvote, votevalue in pairs(votes) do
                    if typeofvote == "Abstain" and votevalue == 1 then
                        voteCounts.Abstain = voteCounts.Abstain + 1
                    elseif typeofvote == "Aye" and votevalue == 1 then
                        voteCounts.Aye = voteCounts.Aye + 1
                    elseif typeofvote == "Nye" and votevalue == 1 then
                        voteCounts.Nye = voteCounts.Nye + 1
                    end
                end

                chat.AddText(Color(255, 255, 255), "Topic: " .. topic .. " Votes| Abstain: " .. voteCounts.Abstain .. " | Aye: " .. voteCounts.Aye .. "| Nye: " .. voteCounts.Nye)
            else
                chat.AddText(Color(255, 0, 0), "Invalid vote data for topic: " .. topic)
            end
        end
    else
        chat.AddText(Color(255, 255, 255), "No results available!")
    end
end)

netstream.Hook("LegAddTopic", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 150)
    frame:SetTitle("Add Legislative Topic")
    frame:Center()
    frame:MakePopup()
    local questionEntry = vgui.Create("DTextEntry", frame)
    questionEntry:Dock(TOP)
    questionEntry:DockMargin(10, 10, 10, 0)
    questionEntry:SetPlaceholderText("Enter your Topic")
    local addButton = vgui.Create("DButton", frame)
    addButton:Dock(TOP)
    addButton:DockMargin(10, 10, 10, 0)
    addButton:SetText("Add Question")
    addButton.DoClick = function()
        local question = questionEntry:GetValue()
        LocalPlayer():ChatPrint(question)
        if question and question ~= "" then
            netstream.Start("LegRegisterTopic", question)
            frame:Close()
        else
            print("Please enter a valid question.")
        end
    end
end)

netstream.Hook("LegAddSteamID", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 150)
    frame:SetTitle("Add A SteamID")
    frame:Center()
    frame:MakePopup()
    local steamidEntry = vgui.Create("DTextEntry", frame)
    steamidEntry:Dock(TOP)
    steamidEntry:DockMargin(10, 10, 10, 0)
    steamidEntry:SetPlaceholderText("Enter the player's SteamID")
    local addButton = vgui.Create("DButton", frame)
    addButton:Dock(TOP)
    addButton:DockMargin(10, 10, 10, 0)
    addButton:SetText("Add SteamID")
    addButton.DoClick = function()
        local steamid = steamidEntry:GetValue()
        if steamid and steamid ~= "" then
            print("Adding SteamID:", steamid)
            netstream.Start("LegRegisterSteamID", tostring(steamid))
            frame:Close()
        else
            print("Please enter a valid SteamID.")
        end
    end
end)

netstream.Hook("LegRemoveSteamID", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 150)
    frame:SetTitle("Add A SteamID")
    frame:Center()
    frame:MakePopup()
    local steamidEntry = vgui.Create("DTextEntry", frame)
    steamidEntry:Dock(TOP)
    steamidEntry:DockMargin(10, 10, 10, 0)
    steamidEntry:SetPlaceholderText("Enter the player's SteamID")
    local addButton = vgui.Create("DButton", frame)
    addButton:Dock(TOP)
    addButton:DockMargin(10, 10, 10, 0)
    addButton:SetText("Add SteamID")
    addButton.DoClick = function()
        local steamid = steamidEntry:GetValue()
        if steamid and steamid ~= "" then
            netstream.Start("LegUnRegisterSteamID", steamid)
            frame:Close()
        else
            print("Please enter a valid SteamID.")
        end
    end
end)

netstream.Hook("ListCurrentTopics", function(topics)
    for index, topic in ipairs(topics) do
        LocalPlayer():ChatPrint("Question " .. index .. " - " .. topic)
    end
end)

netstream.Hook("ListCurrentSteamIDs", function(steamIDs)
    for index, steamid in ipairs(steamIDs) do
        LocalPlayer():ChatPrint("SteamID " .. index .. " - " .. steamid)
    end
end)

netstream.Hook("LegislativeMenu", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 400)
    frame:SetTitle("Legislative Menu")
    frame:Center()
    local buttons = {
        {
            label = "Start Legislative Election",
            command = "legelectionnew"
        },
        {
            label = "End Legislative Election",
            command = "legelectionend"
        },
        {
            label = "List SteamIDs",
            command = "leglistcurrentsteamids"
        },
        {
            label = "Add SteamIDs",
            command = "legelectionaddsteamids"
        },
        {
            label = "Remove SteamIDs",
            command = "legelectionremovesteamids"
        },
        {
            label = "List Current Topics",
            command = "leglistcurrenttopics"
        },
        {
            label = "Add Topics",
            command = "legelectionaddtopic"
        },
        {
            label = "Election Results",
            command = "legelectionresults"
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
