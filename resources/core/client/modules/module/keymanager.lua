-- ______  _  _                          _____  __  
-- |  ___|| |(_)                        |____ |/  | 
-- | |_   | | _  _ __ ___    __ _  _ __     / /`| | 
-- |  _|  | || || '_ ` _ \  / _` || '__|    \ \ | | 
-- | |    | || || | | | | || (_| || |   .___/ /_| |_
-- \_|    |_||_||_| |_| |_| \__,_||_|   \____/ \___/

-- 𝘂𝗶𝗖𝗼𝗻𝘁𝗿𝗼𝗹                                  𝘃.𝟬.𝟬.𝟴



local function KeyManagerStarted()

    print("KeyManager | Lancement du déploiement du KeyManager")

    KeyManager = {}
    KeyManager.keysPressed = {}
    KeyManager.debugMode = false

    function KeyManager.onKeyPress(key, callback)
        return exports['uiControl']:onKeyPress(key, callback)
    end

    function KeyManager.removeKeyCallback(key, id)
        exports['uiControl']:removeKeyCallback(key, id)
    end

    function KeyManager.setDebugMode(state)
        exports['uiControl']:setDebugMode(state)
    end

    function KeyManager.registerListenerCallback(resourceName, callback)
        exports['uiControl']:registerListenerCallback(resourceName, callback)
    end

    KeyManager.registerListenerCallback(GetCurrentResourceName(), 
        function(keys)
            KeyManager.keysPressed = keys
        end
    )

    while not p do Wait(500) end
    
    RegisterCommand("KeyManagerDebugMode", function(source, args, rawCommand)
        if p:getPermission() > 5 then
            KeyManager.debugMode = not KeyManager.debugMode
            KeyManager.setDebugMode(KeyManager.debugMode)
        end
    end, false)
    addChatSuggestion(5, "KeyManagerDebugMode", "Activer/Désactiver le mode debug du KeyManager", {})

end

AddEventHandler('KeyManager:started', KeyManagerStarted)
AddEventHandler('KeyManager:started:'..GetCurrentResourceName(), KeyManagerStarted)



-- Site de référence pour les codes des touches (Attention les touches sont en majuscules dans le KeyManager)
-- Pour les boutons de souris (mouseLeft, mouseRight, mouseMiddle, mouseScrollUp, mouseScrollDown)

-- https://fr.javascript.info/article/keyboard-events/keyboard-dump/




------------------------------------------------------------
------ Exemple d'utilisation de KeyManager.onKeyPress ------
------------------------------------------------------------

-- local idCallback = KeyManager.onKeyPress("ENTER", function()
--     print("La touche Entrée a été pressée")
-- end)



----------------------------------------------------------------
------ Exemple d'utilisation de KeyManager.removeCallback ------
----------------------------------------------------------------

-- KeyManager.removeCallback("ENTER", idCallback)



-------------------------------------------------------------
------ Exemple d'utilisation de KeyManager.keysPressed ------
-------------------------------------------------------------

-- Attention : Ce système ne fonctionne pas en temps réel, il faut donc utiliser une boucle pour vérifier si une touche est pressée.
-- Attention : Il doit ne doit pas être utilisé dans un événement qui se répète à chaque frame mais minimum toutes les 10 frames.

-- Citizen.CreateThread(function()
--     while true do
--         if KeyManager.keysPressed["ENTER"] then
--             print("La touche Entrée a été pressée.")
--         end
--         Citizen.Wait(10)
--     end
-- end)