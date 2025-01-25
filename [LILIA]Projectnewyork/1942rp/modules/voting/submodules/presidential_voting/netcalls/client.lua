local MODULE = MODULE
netstream.Hook("PresElectionNew", function()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("New Election")
    frame:DockPadding(5, 29, 5, 5)
    frame:MakePopup()
    local frSize = 515
    frame:SetSize(frSize, 500 - 164)
    local txOffset = 105
    local lblName = vgui.Create("DLabel", frame)
    lblName:SetText("Election Name:")
    lblName:SetPos(5, 32)
    lblName:SetTextColor(color_white)
    lblName:SizeToContents()
    local txName = vgui.Create("DTextEntry", frame)
    txName:SetPos(5 + txOffset, 29)
    txName:SetWidth(frSize - 10 - txOffset)
    txName:SetTextColor(color_white)
    frame:Center()
    local lblDesc = vgui.Create("DLabel", frame)
    lblDesc:SetText("Description:")
    lblDesc:SetPos(5, 32 + 25)
    lblDesc:SizeToContents()
    lblDesc:SetTextColor(color_white)
    local txDesc = vgui.Create("DTextEntry", frame)
    txDesc:SetPos(5 + txOffset, 29 + 25)
    txDesc:SetWidth(frSize - 10 - txOffset)
    txDesc:SetTextColor(color_white)
    frame:Center()
    local candidatesLbl = vgui.Create("DLabel", frame)
    candidatesLbl:SetText("Candidates:")
    candidatesLbl:SetTextColor(color_white)
    candidatesLbl:SetPos(5, 32 + 50)
    candidatesLbl:SizeToContents()
    local selectedCandidates = {}
    local candidatesListView = vgui.Create("DListView", frame)
    candidatesListView:SetPos(5 + txOffset, 29 + 50)
    candidatesListView:SetSize(frSize - 10 - txOffset, 200)
    candidatesListView:AddColumn("SteamID")
    candidatesListView:AddColumn("Name")
    local addCandidate = vgui.Create("DButton", frame)
    addCandidate:SetText("Add Candidate")
    addCandidate:SetPos(5 + txOffset, 29 + 50 + 205)
    addCandidate:SetTextColor(color_white)
    addCandidate:SetWidth(200)
    addCandidate:SetTextColor(color_white)
    addCandidate.OldPaint = addCandidate.Paint
    addCandidate.Paint = function(pnl, w, h)
        surface.SetDrawColor(100, 255, 100, 150)
        surface.DrawRect(0, 0, w, h)
        pnl:OldPaint(w, h)
    end

    addCandidate.DoClick = function()
        Derma_StringRequest("New Candidate", "Enter the new candidate's SteamID", "", function(stmID)
            Derma_StringRequest("New Candidate", "Enter the new candidate's Display Name (Shown in elections)", "", function(displayName)
                if selectedCandidates[stmID] == nil then
                    selectedCandidates[stmID] = displayName
                    local ln = candidatesListView:AddLine(stmID, displayName)
                    ln.stmID = stmID
                end
            end, nil, "Add", "Cancel")
        end, nil, "Next", "Cancel")
    end

    local delCandidate = vgui.Create("DButton", frame)
    delCandidate:SetText("Remove Selected")
    delCandidate:SetPos(5 + txOffset + 200, 29 + 50 + 205)
    delCandidate:SetWidth(200)
    delCandidate:SetTextColor(color_white)
    delCandidate.OldPaint = delCandidate.Paint
    delCandidate.Paint = function(pnl, w, h)
        surface.SetDrawColor(255, 100, 100, 150)
        surface.DrawRect(0, 0, w, h)
        pnl:OldPaint(w, h)
    end

    delCandidate.DoClick = function()
        if not candidatesListView:GetSelected() or table.Count(candidatesListView:GetSelected()) < 1 then return end
        local selPanel = candidatesListView:GetSelected()[1]
        if selectedCandidates[selPanel.stmID] then
            selectedCandidates[selPanel.stmID] = nil
            selPanel:Remove()
        end
    end

    local startElection = vgui.Create("DButton", frame)
    startElection:SetPos(5 + txOffset, 29 + 75 + 205)
    startElection:SetSize(frSize - 10 - txOffset, 20)
    startElection:SetTextColor(color_white)
    startElection:SetText("Start Election")
    startElection.OldPaint = startElection.Paint
    startElection.Paint = function(pnl, w, h)
        surface.SetDrawColor(121, 65, 203, 150)
        surface.DrawRect(0, 0, w, h)
        pnl:OldPaint(w, h)
    end

    startElection.DoClick = function()
        if not txName:GetValue() or txName:GetValue() == "" then
            chat.AddText(Color(255, 100, 100), "You must enter a name for the election")
            return
        elseif not txDesc:GetValue() or txDesc:GetValue() == "" then
            chat.AddText(Color(255, 100, 100), "You must enter a description for the election")
            return
        elseif table.Count(selectedCandidates) < 2 then
            chat.AddText(Color(255, 100, 100), "You must enter at least two candidates into the election")
            return
        end

        local electionData = {
            Name = txName:GetValue(),
            Description = txDesc:GetValue(),
            Candidates = selectedCandidates
        }

        netstream.Start("PresElectionNew", electionData)
        frame:Close()
    end
end)

netstream.Hook("ElectionVote", function(elData)
    local cols = {
        main = Color(58, 61, 76),
        bg = Color(46, 48, 61),
        bg2 = Color(50, 51, 63),
        purple = Color(121, 65, 203),
        purple_dark = Color(63, 44, 91),
    }

    local frameHeight = 40 + 36 + 25
    local frameWidth = 800
    local scrollingText = elData.Description .. " | Vote for your candidate now | "
    local scrollingTextFont = "liaMediumFont"
    surface.SetFont(scrollingTextFont)
    local scrollingTextW = surface.GetTextSize(scrollingText)
    local actualScrollingTextNum = math.ceil(frameWidth / scrollingTextW)
    local actualScrollingText = scrollingText
    for i = 1, actualScrollingTextNum do
        actualScrollingText = actualScrollingText .. scrollingText
    end

    local frame = vgui.Create("DFrame")
    frame.Paint = function(pnl, w, h)
        surface.SetDrawColor(cols.bg)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(cols.purple)
        surface.DrawRect(0, 0, w, 36)
        draw.SimpleText(elData.Name, "liaBigFont", w / 2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        surface.SetDrawColor(cols.main)
        surface.DrawRect(0, 36, w, 25)
        pnl.scrollOffset = pnl.scrollOffset or 0
        local delta = SysTime() - (pnl.lastPaint or SysTime())
        pnl.scrollOffset = (pnl.scrollOffset + delta * 50) % scrollingTextW
        draw.SimpleText(actualScrollingText, scrollingTextFont, -pnl.scrollOffset, 36, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        pnl.lastPaint = SysTime()
    end

    local candidateButtons = {}
    local w_buffer = 0
    local selectedCandidate = nil
    for k, v in pairs(elData.Candidates) do
        local candidateButton = vgui.Create("DButton", frame)
        candidateButton:SetFont("liaBigFont")
        candidateButton:SetText("")
        candidateButton:SetTextColor(color_white)
        candidateButton:SetSize(frameWidth, 36)
        candidateButton:SetPos(0, 10 + 36 + 25 + w_buffer)
        candidateButton.Candidate = k
        candidateButton.DoClick = function(pnl)
            selectedCandidate = pnl.Candidate
            surface.PlaySound("UI/buttonclick.wav")
        end

        candidateButton.Paint = function(pnl, w, h)
            local color_main = Color(75, 111, 223)
            local color_unselected = Color(65, 91, 203, 50)
            local color_unselected_hover = Color(65, 91, 203)
            if selectedCandidate ~= nil and selectedCandidate == pnl.Candidate then
                surface.SetDrawColor(color_main)
            else
                if not pnl:IsHovered() or selectedCandidate ~= nil then
                    surface.SetDrawColor(color_unselected)
                else
                    surface.SetDrawColor(color_unselected_hover)
                end
            end

            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(v, "liaBigFont", w / 2 + 1, h / 2 + 1, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(v, "liaBigFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if pnl:IsHovered() then
                if not pnl.HoverSound then
                    pnl.HoverSound = true
                    surface.PlaySound("UI/buttonrollover.wav")
                end
            else
                pnl.HoverSound = false
            end
        end

        table.insert(candidateButtons, candidateButton)
        w_buffer = w_buffer + 36 + 5
    end

    frameHeight = frameHeight + w_buffer + 20 + 40
    frame:SetSize(frameWidth, frameHeight)
    frame:MakePopup()
    frame:SetTitle("")
    frame:Center()
    frame:ShowCloseButton(false)
    local voteBtn = vgui.Create("DButton", frame)
    voteBtn:SetSize(frameWidth, 40)
    voteBtn:SetPos(0, frameHeight - 80)
    voteBtn:SetText("")
    voteBtn:SetTextColor(color_white)
    voteBtn:SetFont("liaBigFont")
    voteBtn.Paint = function(pnl, w, h)
        if selectedCandidate ~= nil then
            if pnl:IsHovered() then
                surface.SetDrawColor(50, 194, 89, 255)
            else
                surface.SetDrawColor(48, 171, 81, 225)
            end
        else
            surface.SetDrawColor(50, 80, 60, 255)
        end

        surface.DrawRect(0, 0, w, h)
        local delta = SysTime() - (pnl.LastPaint or SysTime())
        pnl.VotePerc = pnl.VotePerc or 0
        if pnl:IsHovered() and input.IsMouseDown(MOUSE_LEFT) and selectedCandidate ~= nil then
            pnl.VotePerc = math.Clamp(pnl.VotePerc + delta * 0.4, 0, 1)
            if pnl.VotePerc >= 1 and not pnl.Voted then
                pnl.Voted = true
                frame:Close()
                surface.PlaySound("UI/buttonclickrelease.wav")
                netstream.Start("ElectionVoteSubmit", selectedCandidate)
            end
        else
            pnl.VotePerc = math.Clamp(pnl.VotePerc - delta, 0, 1)
        end

        surface.SetDrawColor(52, 224, 98, 255)
        surface.DrawRect(0, 0, w * math.Clamp(pnl.VotePerc, 0, 1), h)
        pnl.LastPaint = SysTime()
        draw.SimpleText("Vote (Hold)", "liaBigFont", w / 2 + 1, h / 2 + 1, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Vote (Hold)", "liaBigFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if pnl:IsHovered() then
            if not pnl.HoverSound then
                pnl.HoverSound = true
                surface.PlaySound("UI/buttonrollover.wav")
            end
        else
            pnl.HoverSound = false
        end
    end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(frameWidth, 40)
    closeBtn:SetPos(0, frameHeight - 40)
    closeBtn:SetText("")
    closeBtn:SetTextColor(color_white)
    closeBtn:SetFont("liaBigFont")
    closeBtn.DoClick = function() frame:Close() end
    closeBtn.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            surface.SetDrawColor(200, 50, 50, 255)
        else
            surface.SetDrawColor(200, 50, 50, 225)
        end

        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Cancel", "liaBigFont", w / 2 + 1, h / 2 + 1, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Cancel", "liaBigFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if pnl:IsHovered() then
            if not pnl.HoverSound then
                pnl.HoverSound = true
                surface.PlaySound("UI/buttonrollover.wav")
            end
        else
            pnl.HoverSound = false
        end
    end
end)

netstream.Hook("ElectionResults", function(res)
    local cols = {
        main = Color(58, 61, 76),
        bg = Color(46, 48, 61),
        bg2 = Color(50, 51, 63),
        purple = Color(121, 65, 203),
        purple_dark = Color(63, 44, 91),
    }

    local frameHeight = 40 + 36
    local frameWidth = 800
    local frame = vgui.Create("DFrame")
    frame.Paint = function(pnl, w, h)
        surface.SetDrawColor(cols.bg)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(cols.purple_dark)
        surface.DrawRect(0, 0, w, 36)
        draw.SimpleText(res.Name .. " Results", "liaBigFont", w / 2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local w_buffer = 0
    local totalVotes = 0
    for k, v in pairs(res.Results) do
        totalVotes = totalVotes + v.Votes
    end

    for k, v in pairs(res.Results) do
        v.Perc = v.Votes / (totalVotes > 0 and totalVotes or 1)
    end

    for k, v in pairs(res.Results) do
        local candidateButton = vgui.Create("DButton", frame)
        candidateButton:SetFont("liaBigFont")
        candidateButton:SetText("")
        candidateButton:SetTextColor(color_white)
        candidateButton:SetSize(frameWidth, 36)
        candidateButton:SetPos(0, 10 + 36 + w_buffer)
        candidateButton.Paint = function(pnl, w, h)
            surface.SetDrawColor(cols.main)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(cols.purple)
            surface.DrawRect(0, 0, w * (v.Votes / res.Results[1].Votes), h)
            draw.SimpleText(v.CandidateName .. "( " .. math.Round(v.Perc * 100, 2) .. "% / " .. v.Votes .. " Votes)", "liaBigFont", w / 2 + 1, h / 2 + 1, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(v.CandidateName .. "( " .. math.Round(v.Perc * 100, 2) .. "% / " .. v.Votes .. " Votes)", "liaBigFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        w_buffer = w_buffer + 36 + 5
    end

    frameHeight = frameHeight + w_buffer + 15
    frame:SetSize(frameWidth, frameHeight)
    frame:MakePopup()
    frame:SetTitle("")
    frame:Center()
    frame:ShowCloseButton(false)
    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(frameWidth, 40)
    closeBtn:SetPos(0, frameHeight - 40)
    closeBtn:SetText("")
    closeBtn:SetTextColor(color_white)
    closeBtn:SetFont("liaBigFont")
    closeBtn.DoClick = function() frame:Close() end
    closeBtn.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            surface.SetDrawColor(200, 50, 50, 255)
        else
            surface.SetDrawColor(200, 50, 50, 225)
        end

        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Cancel", "liaBigFont", w / 2 + 1, h / 2 + 1, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Cancel", "liaBigFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if pnl:IsHovered() then
            if not pnl.HoverSound then
                pnl.HoverSound = true
                surface.PlaySound("UI/buttonrollover.wav")
            end
        else
            pnl.HoverSound = false
        end
    end
end)

netstream.Hook("ElectionResultsAdmin", function(index, curEl)
    local results = {}
    for k, v in pairs(index) do
        if v.Results and v.Winner and v.Name then results[k] = v end
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Election Results")
    frame:SetSize(500, 480)
    frame:Center()
    frame:MakePopup()
    local curElectionInfo = "No current election"
    if curEl then curElectionInfo = "ID=" .. curEl.ID .. " | Name=" .. curEl.Name .. " | Desc=" .. curEl.Description end
    local lbl1 = vgui.Create("DLabel", frame)
    lbl1:SetPos(5, 29)
    lbl1:SetText("Current Election (" .. curElectionInfo .. ")")
    lbl1:SizeToContents()
    local listViewCurrent = vgui.Create("DListView", frame)
    listViewCurrent:SetPos(5, 29 + 15)
    listViewCurrent:SetSize(490, 200)
    listViewCurrent:AddColumn("SteamID")
    listViewCurrent:AddColumn("Name")
    listViewCurrent:AddColumn("Votes")
    if curEl then
        local elData = curEl
        local votedSteamIDs = {}
        local votedIPs = {}
        local results = {}
        for k, v in pairs(elData.Candidates) do
            results[k] = 0
        end

        for k, v in pairs(elData.Votes) do
            if not v.Vote or not v.SteamID or not v.IP or not elData.Candidates[v.Vote] then continue end
            if votedSteamIDs[v.SteamID] or votedIPs[v.IP] then continue end
            votedSteamIDs[v.SteamID] = true
            votedIPs[v.IP] = true
            results[v.Vote] = results[v.Vote] + 1
        end

        local resultsSorted = {}
        local winner = nil
        local totalVotes = 0
        for k, v in pairs(results or {}) do
            totalVotes = totalVotes + v
            local curResult = {
                SteamID = k,
                CandidateName = elData.Candidates[k],
                Votes = v
            }

            resultsSorted[#resultsSorted + 1] = curResult
            if winner == nil or v > winner.Votes then winner = curResult end
        end

        table.sort(resultsSorted, function(a, b) return a.Votes > b.Votes end)
        for k, v in pairs(resultsSorted) do
            listViewCurrent:AddLine(v.SteamID, v.CandidateName, v.Votes .. " (" .. math.Round(v.Votes / totalVotes * 100, 2) .. "%)")
        end
    end

    local listViewPrev = vgui.Create("DListView", frame)
    listViewPrev:SetPos(5, 29 + 15 + 230)
    listViewPrev:SetSize(490, 200)
    listViewPrev:AddColumn("SteamID")
    listViewPrev:AddColumn("Name")
    listViewPrev:AddColumn("Votes")
    local comboBoxPrev = vgui.Create("DComboBox", frame)
    comboBoxPrev:SetPos(5, 29 + 15 + 205)
    comboBoxPrev:SetValue("Select a previous election to view results")
    comboBoxPrev:SetSize(490, 20)
    for k, v in pairs(results) do
        comboBoxPrev:AddChoice("ID_" .. k .. " " .. v.Name, k)
    end

    comboBoxPrev.OnSelect = function(pnl, index, value, data)
        if not data or not results[data] then return end
        listViewPrev:Clear()
        local totalVotes = 0
        for k, v in pairs(results[data].Results) do
            totalVotes = totalVotes + v.Votes
        end

        for k, v in pairs(results[data].Results) do
            listViewPrev:AddLine(v.SteamID, v.CandidateName, v.Votes .. " (" .. math.Round(v.Votes / totalVotes * 100, 2) .. "%)")
        end
    end
end)
