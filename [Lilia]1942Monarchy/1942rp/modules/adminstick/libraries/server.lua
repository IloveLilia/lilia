--------------------------------------------------------------------------------------------------------
function MODULE:PostPlayerLoadout(ply)
    if CAMI.PlayerHasAccess(ply, "Lilia - Management - Use Admin Stick", nil) or ply:Team() == FACTION_STAFF then
        ply:Give("adminstick")
    end
end
--------------------------------------------------------------------------------------------------------