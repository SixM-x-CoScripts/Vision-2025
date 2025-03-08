--------------------------------------------------------
-- Variables
--------------------------------------------------------
PlayerPingBallInHand = nil

--------------------------------------------------------
-- Functions
--------------------------------------------------------
function OnThrowFinished()
    LeaveBeerPongGame()
    ThrowLinePos = {}
end

function OnMarkerGameEnter(game)
    if (Config.OnlyAuthorCanQuit and game.IsAuthor()) or IsAtAllowedGroup() then
        ShowNotification(_U("enter_help_and_quit_msg"))

--[[         -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = _U("enter_help_and_quit_msg")
        }) ]]

    else
        ShowNotification(_U("enter_help_msg"))

--[[         -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = _U("enter_help_msg")
        }) ]]

    end
end

function OnPlayerEnterGameZone(game)
    if not NearbyeActivaGames[game.GetIdentifier()] then
        game.CreateCupsFromCache()

        if game.IsPlayerInThisGame() then
            SendNUIMessage({ type = "clear" })

            for _, val in pairs(game.GetScoreList()) do
                SendNUIMessage({
                    type = "update",
                    name = val.name,
                    score = val.score,
                    you = GetPlayerServerId(PlayerId()) == val.source,
                    source = val.source,
                })
            end

            SendNUIMessage({ type = "refresh" })
            TriggerServerEvent(TriggerName("VisibleScoreStatusForPlayer"), game.GetIdentifier(), true)
        end

        NearbyeActivaGames[game.GetIdentifier()] = game
    end
end

function OnPlayerLeaveGameZone(game)
    SendNUIMessage({ type = "clear" })

    for k, v in pairs(game.spawnedCups) do
        DeleteEntity(k)
        CachedEntities[k] = nil
    end

    NearbyeActivaGames[game.GetIdentifier()] = nil

    for _, v in pairs(CachedPongsEntity) do
        DeleteEntity(v)
    end

    CachedPongsEntity = {}

    TriggerServerEvent(TriggerName("VisibleScoreStatusForPlayer"), game.GetIdentifier(), false)

    if Config.RemoveCupsIfNoOneNear then
        TriggerServerEvent(TriggerName("CheckIfPlayerIsNoOneNearToRemoveGame"), game.GetIdentifier())
    end
end

function OnMarkerGameExit(game)
    CloseAllOpenedMenu()
    DisableMarker = false
end

function OnMarkerGamePushKey(game)
    if DestroyedGamesIdentifier[game.GetIdentifier()] then
        return
    end

    if game.GetAdmissionMoney() ~= nil then
        if game.HavePlayerPaid() == false then
            local payMenu = CreateMenu("create_beer_game")

            payMenu.SetMenuTitle(_U("pay_admission_menu"))

            payMenu.SetProperties({
                float = "right",
                position = "middle",
            })

            payMenu.AddItem(1, { _U("pay"), "<FONT color='green'>$" .. CommaValue(game.GetAdmissionMoney()) }, function()
                callCallback(TriggerName("PayForBeerGame"), function(cb)
                    game.SetPaidStatus(cb)
                end, game.GetAdmissionMoney(), game.GetIdentifier())
                payMenu.Close()
            end)

            payMenu.AddItem(2, _U("exit"), function()
                payMenu.Close()
            end)

            payMenu.Open()
            return
        end
    end
    ActiveGame = game
    TriggerServerEvent(TriggerName("SetGameBusy"), game.GetIdentifier(), true)

    local ballVel, canShoot, endCoords = GetFinalForwardResult()

    newPos = endCoords
    lastPos = endCoords

    Animation.ResetAll(PlayerPedId())
    Animation.Play("dart_idle")

    PlayerPingBallInHand = CreateNetworkObject("prop_ping_pong", GetEntityCoords(PlayerPedId()) + vector3(0, 0, 2))
    AttachPongToHand(PlayerPingBallInHand, PlayerPedId())

    CupPositionGame = game.GetCupsPositions()
    if not Config.DisableAimCamera then
        aimCam.SetCoords(GetGameplayCamCoord())
        aimCam.SetRotation(GetGameplayCamRot())
        aimCam.Render()
    end
    Wait(33)

    local pPos = GetEntityCoords(PlayerPedId()) + vector3(0, 0, 2)

    SetPlayerControl(PlayerId(), false, 8)
    if not Config.DisableAimCamera then
        aimCam.ChangePosition(pPos, pPos, GetGameplayCamRot(), 1500)
    end
    SetPlayerControl(PlayerId(), true, 8)

    if GetResourceKvpString("seen_guide_") ~= "true" then
        SetResourceKvp("seen_guide_", "true")
        SendNUIMessage({ type = "show_guide" })
        SetNuiFocus(true, true)
    end
    animCamPosZ = 0.0
    DisableAllMovement = true
    DisableMarker = true
end

--------------------------------------------------------
-- Events
--------------------------------------------------------
-- User send input froom html
RegisterNUICallback("closefocus", function(data)
    SetNuiFocus(false, false)
end)

RegisterNetEvent(TriggerName("VisibleScoreStatusForPlayer"), function(identifier, status, source)
    if ActiveGame then
        if ActiveGame.GetIdentifier() == identifier then
            SendNUIMessage({
                type = "visible",
                status = status,
                source = source,
            })
        end
    end
end)

RegisterNetEvent(TriggerName("InteractWithObject"), function(id, identifier, throwerId)
    for k, v in pairs(NearbyeActivaGames) do
        if v.GetIdentifier() == identifier then
            for key, value in pairs(v.GetSpawnedCups()) do
                if value == id then
                    PlayCupHitSound(GetEntityCoords(key), GetPlayerServerId(PlayerId()) == throwerId)
                    FreezeEntityPosition(key, false)
                    SetEntityVelocity(key, 0.0, 0.0, 4.5)
                    Wait(350)
                    local i = 255
                    while i >= 0 do
                        Wait(16)

                        SetEntityAlpha(key, i, false)

                        i = i - 12
                    end
                    v.RemoveCupByEntity(key)
                    return
                end
            end
        end
    end
end)

RegisterNetEvent(TriggerName("PutPlayerToThrow"), function()
    local ped = PlayerPedId()
    JoinBeerPongGame()
    FreezeEntityPosition(ped, true)
    SetPlayerThrowStatus(true)
    PlayerRotation = GetEntityHeading(ped)
end)

RegisterNetEvent(TriggerName("EndGame"), function(identifier)
    SendNUIMessage({ type = "clear" })

    if ActiveGame then
        if ActiveGame.GetIdentifier() == identifier then
            for _, v in pairs(CachedPongsEntity) do
                DeleteEntity(v)
            end

            CachedPongsEntity = {}
        end
    end

    RemoveGameByIdentifier(identifier, false)
end)

RegisterNetEvent(TriggerName("SetGameBusy"), function(identifier, status)
    local data = GetGameByIdentifier(identifier)
    if data then
        data.SetGameBusy(status)
    end
end)

RegisterNetEvent(TriggerName("WonGameAnimation"), function()
    DisableMissAnimation = true
    PlayWinnerPedAnimation()
end)

RegisterNetEvent(TriggerName("UpdateGame"), function(data)
    if ActiveGame then
        if ActiveGame.GetIdentifier() == data.IdentifierGame then
            ActiveGame.SetCupInfoTable(data.CupEntityPositions)
            ActiveGame.SetScoreList(data.Score)

            SendNUIMessage({ type = "clear" })

            for _, val in pairs(data.Score) do
                SendNUIMessage({
                    type = "update",
                    name = val.name,
                    score = val.score,
                    you = GetPlayerServerId(PlayerId()) == val.source,
                    source = val.source,
                })
            end

            SendNUIMessage({ type = "refresh" })
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DeleteEntity(PlayerPingBallInHand)

    for k, _ in pairs(CachedEntities) do
        DeleteEntity(k)
    end

    for _, v in pairs(CachedPongsEntity) do
        DeleteEntity(v)
    end
end)

RegisterNetEvent(TriggerName("CreateBeerGame"), function(data, source)
    if GetPlayerServerId(PlayerId()) == source then
        return
    end
    local beerGame = CreateBeerPongGame()

    beerGame.SetCupInfoTable(data.CupEntityPositions)

    beerGame.SetAuthor(false)

    beerGame.SetIdentifier(data.IdentifierGame)

    beerGame.CreateStartPoint(data.StartPosition)

    beerGame.SetGameDifficulty(data.Difficulty)

    if data.AdmissionMoney then
        beerGame.SetAdmissionMoney(data.AdmissionMoney)
    end

    beerGame.Create()

    table.insert(GameCache, beerGame)
end)

RegisterNetEvent(TriggerName("FetchCache"), function(data)
    for k, v in pairs(data) do
        local beerGame = CreateBeerPongGame()

        beerGame.SetGameBusy(v.IsBusy)

        beerGame.SetIdentifier(v.IdentifierGame)

        if v.AdmissionMoney then
            beerGame.SetAdmissionMoney(v.AdmissionMoney)
        end

        for _, val in pairs(v.Score) do
            beerGame.SetScore(val.name, val.score)
        end

        beerGame.SetCupInfoTable(v.CupEntityPositions)

        beerGame.CreateStartPoint(v.StartPosition)

        beerGame.SetGameDifficulty(v.Difficulty)

        beerGame.Create()

        table.insert(GameCache, beerGame)
    end
end)