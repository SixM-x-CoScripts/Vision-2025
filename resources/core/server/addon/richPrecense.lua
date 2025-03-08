CreateThread(function ()
    while true do
        GlobalState["nbJoueur"] = #GetPlayers()
        Wait(30000)
    end
end)