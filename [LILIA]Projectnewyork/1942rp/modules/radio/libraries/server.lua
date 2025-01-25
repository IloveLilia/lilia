function MODULE:PlayerCanHearPlayersVoice(listener, speaker)
    local speakerChar = speaker:getChar()
    local listenerChar = listener:getChar()
    if not (speakerChar and listenerChar) then return end
    local speakerRadio = speakerChar:getInv():getFirstItemOfType("radio")
    local listenerRadio = listenerChar:getInv():getFirstItemOfType("radio")
    if not (speakerRadio and listenerRadio) then return end
    if speakerRadio:getData("freq", "000.0") == listenerRadio:getData("freq", "000.0") then return speaker:GetNW2Bool("radio_voice", false) end
end
