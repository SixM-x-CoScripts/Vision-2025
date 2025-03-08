local SITTING_SCENE = nil
local CURRENT_CHAIR_DATA = nil
local SELECTED_CHAIR_ID = nil
local selectedRoulette = nil
local RouletteDZ = {}
local closeToRoulette = false
local currentBetAmount = 0
local idleTimer = 0
local aimingAtBet = -1
local lastAimedBet = -1
local rouletteInstructional = nil
local CurrentChips = 0

local function PlaySoundFront(soundId, audioName, audioRef, p3)
    if CasinoConfig.PlayFrontendSounds then
        PlaySoundFrontend(soundId, audioName, audioRef, p3)
    end
end

local Draw3DText = function(coords, text, size, font)
    coords = vector3(coords.x, coords.y, coords.z)

    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)

    if not size then
        size = 1
    end
    if not font then
        font = 0
    end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)

    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local CreateRouletteTable = function(index, data)
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
    local self = {}

    self.index = index
    self.data = data

    RequestModel(GetHashKey('vw_prop_casino_roulette_01'))
    while not HasModelLoaded(GetHashKey('vw_prop_casino_roulette_01')) do
        Wait(1)
    end

    self.tableObject = CreateObject(GetHashKey('vw_prop_casino_roulette_01'), data.position, false)
    SetEntityHeading(self.tableObject, data.rot)

    RequestModel(GetHashKey('S_M_Y_Casino_01'))
    while not HasModelLoaded(GetHashKey('S_M_Y_Casino_01')) do
        Wait(1)
    end

    local pedOffset = GetObjectOffsetFromCoords(data.position.x, data.position.y, data.position.z, data.rot, 0.0, 0.7, 1.0)
    self.ped = CreatePed(2, GetHashKey('S_M_Y_Casino_01'), pedOffset, data.rot + 180.0, false, true)

    SetEntityCanBeDamaged(self.ped, 0)
    SetPedAsEnemy(self.ped, 0)
    SetBlockingOfNonTemporaryEvents(self.ped, 1)
    SetPedCanEvasiveDive(self.ped, 0)
    SetPedCanRagdollFromPlayerImpact(self.ped, 0)
    frm_setPedClothes(3, self.ped)
    frm_setPedClothes(3, self.ped)

    -- 1.0.1 
    SetPedVoiceGroup(self.ped, 'S_M_Y_Casino_01_WHITE_01') 

    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'idle', 3.0, 3.0, -1, 2, 0, true, true, true)

    self.numbersData = {}
    self.betData = {}
    self.hoverObjects = {}
    self.betObjects = {}
    self.ballObject = nil

    self.rouletteCam = nil
    self.cameraMode = 1

    self.enableCamera = function(state)
        if state then
            self.speakPed('MINIGAME_DEALER_GREET')
            --casinoNuiUpdateGame(self.index, self.ido, self.statusz)

            local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
            self.rouletteCam =
                CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', self.data.position.x, self.data.position.y, self.data.position.z + 2.0, rot.x, rot.y, rot.z, 80.0, true, 2)
            SetCamActive(self.rouletteCam, true)
            RenderScriptCams(true, 900, 900, true, false)

            selectedRoulette = self.index            
            rouletteInstructional = setupRouletteInstructionalScaleform("instructional_buttons")
            self.betRenderState(true)

            RoueletteIdle()

            CreateThread(
                function()
                    while selectedRoulette ~= nil do
                        Wait(1000)

                        if idleTimer ~= nil then
                            idleTimer = idleTimer - 1
                            if idleTimer < 1 then
                                idleTimer = nil
                                RoueletteIdle()
                            end
                        end
                    end
                end
            )

            CreateThread(
                function()
                    while selectedRoulette ~= nil do
                        Wait(1)

                        if self.betObjects then
                            for i = 1, #self.betObjects, 1 do
                                local bet = self.betObjects[i]
                                if DoesEntityExist(bet.obj) then
                                    local coords = GetEntityCoords(bet.obj)
                                    if bet.playerSrc == GetPlayerServerId(PlayerId()) then
                                        Draw3DText(coords, string.format('~w~%s', bet.betAmount), 0.10, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            )

            CreateThread(
                function()
                    while selectedRoulette ~= nil do
                        Wait(125)

                        if IsDisabledControlPressed(0, 172) then
                            currentBetAmount = currentBetAmount + 10
                            changeBetAmount(currentBetAmount)
                        elseif IsDisabledControlPressed(0, 173) then
                            if currentBetAmount > 0 then
                                currentBetAmount = currentBetAmount - 10

                                if currentBetAmount < 0 then
                                    currentBetAmount = 0
                                end

                                changeBetAmount(currentBetAmount)
                            end
                        end
                    end
                end
            )

            CreateThread(
                function()
                    while selectedRoulette ~= nil do
                        Wait(1)
                        DisableAllControlActions(0)

                        DrawScaleformMovieFullscreen(rouletteInstructional, 255, 255, 255, 255, 0)
                        DrawRect(0.933, 0.928, 0.105, 0.032, 0, 0, 0, 150) 
                        DrawAdvancedNativeTextBlack(0.991, 0.935, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Bet .. ":", 255, 255, 255, 255, 0, 0)
                        DrawAdvancedNativeTextBlack(1.041, 0.928, 0.005, 0.0028, 0.464, tostring(currentBetAmount), 255, 255, 255, 255, 0, 0)
                        
                        if self.ido and self.ido > 0 then
                            DrawRect(0.944, 0.886, 0.081, 0.032, 0, 0, 0, 150)
                            DrawAdvancedNativeTextBlack(1.013, 0.892, 0.005, 0.0028, 0.29, CasinoConfigSH.Lang.Time .. ":", 255, 255, 255, 255, 0, 0)
                            if self.ido < 10 then
                                DrawAdvancedNativeTextBlack(1.05, 0.885, 0.005, 0.0028, 0.464, "00:0" .. tostring(self.ido), 255, 255, 255, 255, 0, 0)
                            else
                                DrawAdvancedNativeTextBlack(1.05, 0.885, 0.005, 0.0028, 0.464, "00:" .. tostring(self.ido), 255, 255, 255, 255, 0, 0)
                            end
                        end

                        if IsDisabledControlJustPressed(0, 177) then
                            self.enableCamera(false)
                            PlaySoundFront(-1, 'FocusOut', 'HintCamSounds', false)
                        end
                        if IsDisabledControlJustPressed(0, 38) then
                            self.changeCameraMode()
                            PlaySoundFront(-1, 'FocusIn', 'HintCamSounds', false)
                        end

                        if IsDisabledControlJustPressed(0, 22) then --Custom Bet [space]
                            local tmpInput = getGenericTextInput(CasinoConfigSH.Lang.PlaceBet)
                            if tonumber(tmpInput) then
                                tmpInput = tonumber(tmpInput)
                                if tmpInput > 0 then
                                    changeBetAmount(tmpInput)
                                end
                            end
                        end
                    end
                end
            )

            Wait(1500)
        else
            TriggerServerEvent('sunwiseRoulette:notUsing', selectedRoulette)

           --SendNUIMessage(
           --    {
           --        action = 'showRulettNui',
           --        state = false
           --    }
           --)

            if DoesCamExist(self.rouletteCam) then
                DestroyCam(self.rouletteCam, false)
            end
            RenderScriptCams(false, 900, 900, true, false)
            self.betRenderState(false)
            selectedRoulette = nil
            self.speakPed('MINIGAME_DEALER_LEAVE_NEUTRAL_GAME')

            NetworkStopSynchronisedScene(SITTING_SCENE)

            local endingDict = 'anim_casino_b@amb@casino@games@shared@player@'
            RequestAnimDict(endingDict)
            while not HasAnimDictLoaded(endingDict) do
                Wait(1)
            end

            local whichAnim = nil
            if SELECTED_CHAIR_ID == 1 then
                whichAnim = 'sit_exit_left'
            elseif SELECTED_CHAIR_ID == 2 then
                whichAnim = 'sit_exit_right'
            elseif SELECTED_CHAIR_ID == 3 then
                whichAnim = ({'sit_exit_left', 'sit_exit_right'})[math.random(1, 2)]
            elseif SELECTED_CHAIR_ID == 4 then
                whichAnim = 'sit_exit_left'
            end

            TaskPlayAnim(PlayerPedId(), endingDict, whichAnim, 1.0, 1.0, 2500, 0)
            SetPlayerControl(PlayerId(), 0, 0)
            Wait(3600)
            rouletteInstructional = nil

            SetPlayerControl(PlayerId(), 1, 0)
        end
    end

    self.changeCameraMode = function()
        if DoesCamExist(self.rouletteCam) then
            if self.cameraMode == 1 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 2
                local camOffset = GetOffsetFromEntityInWorldCoords(self.tableObject, -1.45, -0.15, 1.45)
                SetCamCoord(self.rouletteCam, camOffset)
                SetCamRot(self.rouletteCam, -25.0, 0.0, self.data.rot + 270.0, 2)
                SetCamFov(self.rouletteCam, 40.0)
                ShakeCam(self.rouletteCam, 'HAND_SHAKE', 0.3)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 2 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 3
                local camOffset = GetOffsetFromEntityInWorldCoords(self.tableObject, 1.45, -0.15, 2.15)
                SetCamCoord(self.rouletteCam, camOffset)
                SetCamRot(self.rouletteCam, -58.0, 0.0, self.data.rot + 90.0, 2)
                ShakeCam(self.rouletteCam, 'HAND_SHAKE', 0.3)
                SetCamFov(self.rouletteCam, 80.0)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 3 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 4
                local camOffset = GetWorldPositionOfEntityBone(self.tableObject, GetEntityBoneIndexByName(self.tableObject, 'Roulette_Wheel'))
                local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
                SetCamCoord(self.rouletteCam, camOffset + vector3(0.0, 0.0, 0.5))
                SetCamRot(self.rouletteCam, rot, 2)
                StopCamShaking(self.rouletteCam, false)
                SetCamFov(self.rouletteCam, 80.0)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 4 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Wait(1)
                end
                self.cameraMode = 1
                local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
                SetCamCoord(self.rouletteCam, self.data.position + vector3(0.0, 0.0, 2.0))
                SetCamRot(self.rouletteCam, rot, 2)
                SetCamFov(self.rouletteCam, 80.0)
                StopCamShaking(self.rouletteCam, false)
                DoScreenFadeIn(200)
            end
        end
    end

    self.loadTableData = function()
        self.numbersData = {}
        self.betData = {}
        local e = 1
        for i = 0, 11, 1 do
            for j = 0, 2, 1 do
                table.insert(
                    self.numbersData,
                    {
                        name = e + 1,
                        hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                        hoverObject = 'vw_prop_vw_marker_02a'
                    }
                )
                local offset = nil
                if j == 0 then
                    offset = 0.155
                elseif j == 1 then
                    offset = 0.171
                elseif j == 2 then
                    offset = 0.192
                end

                table.insert(
                    self.betData,
                    {
                        betId = e,
                        name = e + 1,
                        pos = GetOffsetFromEntityInWorldCoords(self.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                        objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.081 * i - 0.057, 0.167 * j - 0.192, 0.9448),
                        hoverNumbers = {e}
                    }
                )

                e = e + 1
            end
        end
        table.insert(
            self.numbersData,
            {
                name = 'Zero',
                hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
                hoverObject = 'vw_prop_vw_marker_01a'
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'Zero',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
                hoverNumbers = {#self.numbersData}
            }
        )
        table.insert(
            self.numbersData,
            {
                name = 'Double Zero',
                hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                hoverObject = 'vw_prop_vw_marker_01a'
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'Double Zero',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                hoverNumbers = {#self.numbersData}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'RED',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.3, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.3, -0.4, 0.9448),
                hoverNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'BLACK',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.5, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.5, -0.4, 0.9448),
                hoverNumbers = {0, 2, 4, 6, 8, 9, 11, 13, 15, 18, 20, 22, 24, 26, 27, 29, 31, 33, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'EVEN',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.15, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.15, -0.4, 0.9448),
                hoverNumbers = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'ODD',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.65, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.65, -0.4, 0.9448),
                hoverNumbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '1to18',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.02, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.02, -0.4, 0.9448),
                hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '19to36',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.78, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.78, -0.4, 0.9448),
                hoverNumbers = {19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '1st 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.05, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.05, -0.3, 0.9448),
                hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2nd 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.4, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.4, -0.3, 0.9448),
                hoverNumbers = {13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '3rd 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.75, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.75, -0.3, 0.9448),
                hoverNumbers = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, -0.15, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, -0.15, 0.9448),
                hoverNumbers = {1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.0, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.0, 0.9448),
                hoverNumbers = {2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.15, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.15, 0.9448),
                hoverNumbers = {3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36}
            }
        )
    end

    self.speakPed = function(speakName)
        PlayAmbientSpeech1(self.ped, speakName, 'SPEECH_PARAMS_FORCE_NORMAL_CLEAR', 1)
    end

    self.createBetObjects = function(bets)
        for i = 1, #self.betObjects, 1 do
            if DoesEntityExist(self.betObjects[i].obj) then
                DeleteObject(self.betObjects[i].obj)
            end
        end

        self.betObjects = {}

        local existBetId = {}

        for i = 1, #bets, 1 do
            local t = self.betData[bets[i].betId]

            if existBetId[bets[i].betId] == nil then
                existBetId[bets[i].betId] = 0
            else
                existBetId[bets[i].betId] = existBetId[bets[i].betId] + 1
            end

            if t ~= nil then
                local betModelObject = getBetObjectType(bets[i].betAmount)

                if betModelObject ~= nil then
                    RequestModel(betModelObject)
                    while not HasModelLoaded(betModelObject) do
                        Wait(0)
                    end

                    local obj = CreateObject(betModelObject, t.objectPos.x, t.objectPos.y, t.objectPos.z + (existBetId[bets[i].betId] * 0.0081), false)
                    SetEntityHeading(obj, self.data.rot)
                    table.insert(
                        self.betObjects,
                        {
                            obj = obj,
                            betAmount = bets[i].betAmount,
                            playerSrc = bets[i].playerSrc
                        }
                    )
                end
            end
        end
    end

    self.hoverNumbers = function(hoveredNumbers)
        for i = 1, #self.hoverObjects, 1 do
            if DoesEntityExist(self.hoverObjects[i]) then
                DeleteObject(self.hoverObjects[i])
            end
        end

        self.hoverObjects = {}

        for i = 1, #hoveredNumbers, 1 do
            local t = self.numbersData[hoveredNumbers[i]]
            if t ~= nil then
                RequestModel(GetHashKey(t.hoverObject))
                while not HasModelLoaded(GetHashKey(t.hoverObject)) do
                    Wait(1)
                end

                local obj = CreateObject(GetHashKey(t.hoverObject), t.hoverPos, false)
                SetEntityHeading(obj, self.data.rot)

                table.insert(self.hoverObjects, obj)
            end
        end
    end

    self.betRenderState = function(state)
        enabledBetRender = state

        if state then
            CreateThread(
                function()
                    while enabledBetRender do
                        Wait(8)

                        if aimingAtBet ~= -1 and lastAimedBet ~= aimingAtBet then
                            lastAimedBet = aimingAtBet
                            local bettingData = self.betData[aimingAtBet]
                            if bettingData ~= nil then
                                self.hoverNumbers(bettingData.hoverNumbers)
                            else
                                self.hoverNumbers({})
                            end
                        end

                        if aimingAtBet == -1 and lastAimedBet ~= -1 then
                            self.hoverNumbers({})
                        end
                    end
                end
            )

            CreateThread(
                function()
                    while enabledBetRender do
                        Wait(0)

                        ShowCursorThisFrame()

                        local e = RouletteDZ[selectedRoulette]
                        if e ~= nil then
                            local cx, cy = GetNuiCursorPosition()
                            local rx, ry = GetActiveScreenResolution()

                            local n = 30 -- this is for the cursor point, how much to tolerate in range, increasing it you will find it easier to click on the bets.

                            local foundBet = false

                            for i = 1, #self.betData, 1 do
                                local bettingData = self.betData[i]
                                local onScreen, screenX, screenY = World3dToScreen2d(bettingData.pos.x, bettingData.pos.y, bettingData.pos.z)
                                local l = math.sqrt(math.pow(screenX * rx - cx, 2) + math.pow(screenY * ry - cy, 2))
                                if l < n then
                                    aimingAtBet = i
                                    foundBet = true

                                    if IsDisabledControlJustPressed(0, 24) then
                                        if currentBetAmount > 0 then
                                            if CasinoConfig.RouletteTables[selectedRoulette] ~= nil then
                                                if currentBetAmount >= CasinoConfig.RouletteTables[selectedRoulette].minBet and currentBetAmount <= CasinoConfig.RouletteTables[selectedRoulette].maxBet then
                                                    PlaySoundFront(-1, 'DLC_VW_BET_DOWN', 'dlc_vw_table_games_frontend_sounds', true)
                                                    TriggerServerEvent('sunwiseRoulette:goRoulette', selectedRoulette, aimingAtBet, currentBetAmount)
                                                else
                                                    CasinoConfig.ShowNotification(string.format(CasinoConfigSH.Lang.BadAmountMinandMax, CasinoConfig.RouletteTables[selectedRoulette].minBet, CasinoConfig.RouletteTables[selectedRoulette].maxBet))
                                                end
                                            end
                                        else
                                            CasinoConfig.ShowNotification(CasinoConfigSH.Lang.BadAmount)
                                        end
                                    end
                                end
                            end

                            if not foundBet then
                                aimingAtBet = -1
                            end
                        end
                    end
                end
            )
        end
    end

    self.spinRoulette = function(tickRate)
        if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
            self.speakPed('MINIGAME_DEALER_CLOSED_BETS')
            TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'no_more_bets', 3.0, 3.0, -1, 0, 0, true, true, true)

            Wait(1500)

            if DoesEntityExist(self.ballObject) then
                DeleteObject(self.ballObject)
            end

            TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'spin_wheel', 3.0, 3.0, -1, 0, 0, true, true, true)

            RequestModel(GetHashKey('vw_prop_roulette_ball'))
            while not HasModelLoaded(GetHashKey('vw_prop_roulette_ball')) do
                Wait(1)
            end

            local ballOffset = GetWorldPositionOfEntityBone(self.tableObject, GetEntityBoneIndexByName(self.tableObject, 'Roulette_Wheel'))

            local LIB = 'anim_casino_b@amb@casino@games@roulette@table'
            RequestAnimDict(LIB)
            while not HasAnimDictLoaded(LIB) do
                Wait(1)
            end

            Wait(3000)

            self.ballObject = CreateObject(GetHashKey('vw_prop_roulette_ball'), ballOffset, false)
            SetEntityHeading(self.ballObject, self.data.rot)
            SetEntityCoordsNoOffset(self.ballObject, ballOffset, false, false, false)
            local h = GetEntityRotation(self.ballObject)
            SetEntityRotation(self.ballObject, h.x, h.y, h.z + 90.0, 2, false)

            if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                PlayEntityAnim(self.ballObject, 'intro_ball', LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(self.ballObject, 'loop_ball', LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(self.tableObject, 'intro_wheel', LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(self.tableObject, 'loop_wheel', LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(self.ballObject, string.format('exit_%s_ball', tickRate), LIB, 1000.0, false, true, false, 0, 136704)
                PlayEntityAnim(self.tableObject, string.format('exit_%s_wheel', tickRate), LIB, 1000.0, false, true, false, 0, 136704)

                Wait(11e3)

                if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone1', 3.0, 3.0, -1, 0, 0, true, true, true)
                    Wait(1500)
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone2', 3.0, 3.0, -1, 0, 0, true, true, true)
                    Wait(1500)
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone3', 3.0, 3.0, -1, 0, 0, true, true, true)

                    Wait(2000)
                    if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                        TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'idle', 3.0, 3.0, -1, 0, 0, true, true, true)
                    end

                    if DoesEntityExist(self.ballObject) then
                        DeleteObject(self.ballObject)
                    end
                end
            end
        end
    end

    self.loadTableData()
    RouletteDZ[self.index] = self
end

function changeBetAmount(amount)
    currentBetAmount = amount
    CurrentChips = amount
    PlaySoundFront(-1, 'DLC_VW_BET_HIGHLIGHT', 'dlc_vw_table_games_frontend_sounds', true)
end

function getGenericTextInput(type)
    if type == nil then
        type = ''
    end
    AddTextEntry('FMMC_MPM_NA', tostring(type))
    DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', tostring(type), '', '', '', '', 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
    return false
end

local loadedTables = false
local function funcCreateRoulette()
    if not loadedTables then 
        loadedTables = true 
        for rouletteIndex, data in pairs(CasinoConfig.RouletteTables) do
            CreateRouletteTable(rouletteIndex, data)
    
            RequestAnimDict('anim_casino_b@amb@casino@games@roulette@table')
            RequestAnimDict('anim_casino_b@amb@casino@games@roulette@dealer_female')
            RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
            RequestAnimDict('anim_casino_b@amb@casino@games@roulette@player')
        end
    end
end

CreateThread(function()
    while true do
        Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z < -30.0 then
            closeToRoulette = false
            for k, v in pairs(CasinoConfig.RouletteTables) do
                if #(playerCoords - CasinoConfig.RouletteTables[k].position) < 100.0 then
                    closeToRoulette = true
                    funcCreateRoulette()
                end
            end
        else
            Wait(6000)
        end
    end
end)

local closestChairData
CreateThread(function()
    while true do
        local letSleep = true

        local playerpos = GetEntityCoords(PlayerPedId())

        if closeToRoulette and selectedRoulette == nil then
            for k, v in pairs(RouletteDZ) do
                if DoesEntityExist(v.tableObject) then
                    local objcoords = GetEntityCoords(v.tableObject)
                    Bulle.create("roulette" .. k, objcoords + vector3(0.0, 0.0, 1.15), "bulleRoulette", true)
                    local dist = Vdist2(playerpos, objcoords)
                    if dist < 4.0 then
                        -- En attente d'une bulle
                        --Bulle.create("")
                        letSleep = false
                        closestChairData = getClosestChairData(v.tableObject)
                        CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.PlayRoulette)
                        if closestChairData == nil then
                            break
                        end

                        DrawMarker(
                            20,
                            closestChairData.position + vector3(0.0, 0.0, 1.0),
                            0.0,
                            0.0,
                            0.0,
                            180.0,
                            0.0,
                            0.0,
                            0.3,
                            0.3,
                            0.3,
                            255,
                            255,
                            255,
                            255,
                            true,
                            true,
                            2,
                            true,
                            nil,
                            nil,
                            false
                        )
                        if IsControlJustPressed(0, 38) then 
                            TriggerServerEvent('casino:roulette:taskSitDown', k, closestChairData)
                        end
                    else
                        closestChairData = nil
                    end
                end
            end
        end

        --if closestChairData == nil then 
        --    Wait(200)
        --end

        if letSleep then
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            if z > -30.0 then
                Wait(2500)
            else
                Wait(1000)
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent('sunwiseRoulette:callback::taskSitDown')
AddEventHandler(
    'sunwiseRoulette:callback::taskSitDown',
    function(rouletteIndex, chairData)
        SELECTED_CHAIR_ID = chairData.chairId
        CURRENT_CHAIR_DATA = chairData
        SITTING_SCENE = NetworkCreateSynchronisedScene(chairData.position, chairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
        RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
        while not HasAnimDictLoaded('anim_casino_b@amb@casino@games@shared@player@') do
            Wait(1)
        end

        local randomSit = ({'sit_enter_left', 'sit_enter_right'})[math.random(1, 2)]
        NetworkAddPedToSynchronisedScene(PlayerPedId(), SITTING_SCENE, 'anim_casino_b@amb@casino@games@shared@player@', randomSit, 2.0, -2.0, 13, 16, 2.0, 0)
        NetworkStartSynchronisedScene(SITTING_SCENE)
        SetPlayerControl(PlayerId(), 0, 0)
        startRoulette(rouletteIndex, chairData.chairId)
        Wait(4000)
        SetPlayerControl(PlayerId(), 1, 0)
    end
)

function startRoulette(index, chairId)
    if RouletteDZ[index] then
        TriggerServerEvent('casino:taskStartRoulette', index, chairId)
    end
end

RegisterNetEvent('sunwiseRoulette:open')
AddEventHandler(
    'sunwiseRoulette:open',
    function(rouletteIndex)
        if RouletteDZ[rouletteIndex] ~= nil then
            Wait(4000)
            RouletteDZ[rouletteIndex].enableCamera(true)
        end
    end
)

RegisterNetEvent('sunwiseRoulette:startSpin')
AddEventHandler('sunwiseRoulette:startSpin',function(rouletteIndex, tickRate)
    if RouletteDZ[rouletteIndex] ~= nil then
        RouletteDZ[rouletteIndex].spinRoulette(tickRate)

        if selectedRoulette == rouletteIndex then
            playImpartial()
        end
    end
end)

RegisterNetEvent('sunwiseRoulette:updateStatus')
AddEventHandler('sunwiseRoulette:updateStatus', function(rouletteIndex, ido, statusz)
    if RouletteDZ[rouletteIndex] ~= nil then
        RouletteDZ[rouletteIndex].ido = ido
        RouletteDZ[rouletteIndex].statusz = statusz
        casinoNuiUpdateGame(rouletteIndex, ido, statusz)
    end
end)

RegisterNetEvent('sunwiseRoulette:updateTableBets')
AddEventHandler('sunwiseRoulette:updateTableBets',function(rouletteIndex, bets)
    if RouletteDZ[rouletteIndex] ~= nil then
        RouletteDZ[rouletteIndex].createBetObjects(bets)
    end
end)

local function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentSubstringPlayerName(sub)
	end
end

function ShowAboveRadarMessage(message, back)
    if back then ThefeedNextPostBackgroundColor(back) end
    BeginTextCommandThefeedPost("jamyfafi")
    AddLongString(message)
    return EndTextCommandThefeedPostTicker(0, 1)
end
local ShowPNotification = function(msg, id)
	if not id then
		if notifID then ThefeedRemoveItem(notifID) end
        Wait(1)
		notifID = ShowAboveRadarMessage(msg)
		Citizen.SetTimeout(7000, function() if notifID then ThefeedRemoveItem(notifID) end end)
	else
		if notifID2 then ThefeedRemoveItem(notifID2) end
		notifID2 = ShowAboveRadarMessage(msg)
		Citizen.SetTimeout(7000, function() if notifID2 then ThefeedRemoveItem(notifID2) end end)
	end
end

function casinoNuiUpdateGame(rouletteIndex, ido, status)
    if selectedRoulette == rouletteIndex then
        if not status and ido then
            ShowPNotification(string.format(CasinoConfigSH.Lang.GameWillStart, ido))
        end
    end
end

function getClosestChairData(tableObject)
    local localPlayer = PlayerPedId()
    local playerpos = GetEntityCoords(localPlayer)
    if DoesEntityExist(tableObject) then
        local chairs = {'Chair_Base_01', 'Chair_Base_02', 'Chair_Base_03', 'Chair_Base_04'}
        for i = 1, #chairs, 1 do
            local objcoords = GetWorldPositionOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i]))
            local dist = Vdist2(playerpos, objcoords)
            if dist < 1.7 then
                return {
                    position = objcoords,
                    rotation = GetWorldRotationOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i])),
                    chairId = CasinoConfig.ChairsId[chairs[i]]
                }
            end
        end
    end
end

function getBetObjectType(betAmount)
    if betAmount < 10 then
        return GetHashKey('vw_prop_vw_coin_01a')
    elseif betAmount >= 10 and betAmount < 50 then
        return GetHashKey('vw_prop_chip_10dollar_x1')
    elseif betAmount >= 50 and betAmount < 100 then
        return GetHashKey('vw_prop_chip_50dollar_x1')
    elseif betAmount >= 100 and betAmount < 500 then
        return GetHashKey('vw_prop_chip_100dollar_x1')
    elseif betAmount >= 500 and betAmount < 1000 then
        return GetHashKey('vw_prop_chip_500dollar_x1')
    elseif betAmount >= 1000 and betAmount < 5000 then
        return GetHashKey('vw_prop_chip_1kdollar_x1')
    elseif betAmount >= 5000 then
        return GetHashKey('vw_prop_plaq_10kdollar_x1')
    else -- this should never happen, but yeah.
        return GetHashKey('vw_prop_plaq_10kdollar_x1')
    end

    -- these are deprecated, it looks cool, but it hides some data, you can put it in you like the big chip piles.

    -- elseif bets[i].betAmount >= 10000 and bets[i].betAmount < 25000 then
    --     return GetHashKey('vw_prop_vw_chips_pile_01a')
    -- elseif bets[i].betAmount >= 25000 and bets[i].betAmount < 50000 then
    --     return GetHashKey('vw_prop_vw_chips_pile_02a')
    -- elseif bets[i].betAmount >= 50000 then
    --     return GetHashKey('vw_prop_vw_chips_pile_03a')
    -- end
end

RegisterNetEvent('sunwiseRoulette:playBetAnim')
AddEventHandler('sunwiseRoulette:playBetAnim', function(chairId)
        local sex = 0

        if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
            sex = 1
        end

        local rot = CURRENT_CHAIR_DATA.rotation

        if chairId == 4 then
            rot = rot + vector3(0.0, 0.0, 90.0)
        elseif chairId == 3 then
            rot = rot + vector3(0.0, 0.0, -180.0)
        elseif chairId == 2 then
            rot = rot + vector3(0.0, 0.0, -90.0)
        elseif chairId == 1 then
            chairId = 1
            rot = rot + vector3(0.0, 0.0, -90.0)
        end

        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@play@v01', chairId, chairId)
        if sex == 1 then
            L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@play@v01', chairId, chairId)
        end

        RequestAnimDict(L)
        while not HasAnimDictLoaded(L) do
            Wait(1)
        end

        if CURRENT_CHAIR_DATA ~= nil then
            local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                currentScene,
                L,
                ({'place_bet_zone1', 'place_bet_zone2', 'place_bet_zone3'})[math.random(1, 3)],
                4.0,
                -2.0,
                13,
                16,
                1148846080,
                0
            )
            NetworkStartSynchronisedScene(currentScene)

            idleTimer = 8
        end
    end
)

RegisterNetEvent('sunwiseRoulette:playWinAnim')
AddEventHandler('sunwiseRoulette:playWinAnim',function(chairId)
    local rot = CURRENT_CHAIR_DATA.rotation

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, 'reaction_great', 4.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end)

RegisterNetEvent('sunwiseRoulette:playLossAnim')
AddEventHandler('sunwiseRoulette:playLossAnim',function(chairId)
        local rot = CURRENT_CHAIR_DATA.rotation

        if chairId == 4 then
            rot = rot + vector3(0.0, 0.0, 90.0)
        elseif chairId == 3 then
            rot = rot + vector3(0.0, 0.0, -180.0)
        elseif chairId == 2 then
            rot = rot + vector3(0.0, 0.0, -90.0)
        elseif chairId == 1 then
            chairId = 1
            rot = rot + vector3(0.0, 0.0, -90.0)
        end

        local sex = 0
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)

        if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
            sex = 1
        end

        if sex == 1 then
            local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)
        end

        RequestAnimDict(L)
        while not HasAnimDictLoaded(L) do
            Wait(1)
        end

        if CURRENT_CHAIR_DATA ~= nil then
            local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                currentScene,
                L,
                ({'reaction_bad_var01', 'reaction_bad_var02', 'reaction_terrible'})[math.random(1, 3)],
                4.0,
                -2.0,
                13,
                16,
                1148846080,
                0
            )
            NetworkStartSynchronisedScene(currentScene)

            idleTimer = 8
        end
    end
)

function playImpartial()
    local rot = CURRENT_CHAIR_DATA.rotation

    if SELECTED_CHAIR_ID == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif SELECTED_CHAIR_ID == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif SELECTED_CHAIR_ID == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif SELECTED_CHAIR_ID == 1 then
        SELECTED_CHAIR_ID = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(),
            currentScene,
            L,
            ({'reaction_impartial_var01', 'reaction_impartial_var02', 'reaction_impartial_var03'})[math.random(1, 3)],
            4.0,
            -2.0,
            13,
            16,
            1148846080,
            0
        )
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end

function RoueletteIdle()
    local rot = CURRENT_CHAIR_DATA.rotation

    if SELECTED_CHAIR_ID == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif SELECTED_CHAIR_ID == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif SELECTED_CHAIR_ID == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif SELECTED_CHAIR_ID == 1 then
        SELECTED_CHAIR_ID = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@idles', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@idles', SELECTED_CHAIR_ID, SELECTED_CHAIR_ID)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Wait(1)
    end

    if CURRENT_CHAIR_DATA ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(CURRENT_CHAIR_DATA.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, ({'idle_a', 'idle_b', 'idle_c', 'idle_d'})[math.random(1, 4)], 1.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)
    end
end

function addRandomClothes(ped)
    local r = math.random(1, 5)

    if r == 1 then
        SetPedComponentVariation(ped, 0, 4, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 4, 0, 0)
        SetPedComponentVariation(ped, 3, 2, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 1, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
        SetPedPropIndex(ped, 1, 0, 0, false)
    elseif r == 2 then
        SetPedComponentVariation(ped, 0, 3, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 1, 0)
        SetPedComponentVariation(ped, 3, 1, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
    elseif r == 3 then
        SetPedComponentVariation(ped, 0, 3, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 1, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
        SetPedPropIndex(ped, 1, 0, 0, false)
    elseif r == 4 then
        SetPedComponentVariation(ped, 0, 2, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 2, 1, 0)
        SetPedComponentVariation(ped, 3, 3, 3, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
    end
end

function ButtonMessageRoul(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function ButtonRoul(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupRouletteInstructionalScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    ButtonRoul(GetControlInstructionalButton(2, 194, true)) -- The button to display
    ButtonMessageRoul(CasinoConfigSH.Lang.LeaveTable) --BACKSPACE
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    ButtonRoul(GetControlInstructionalButton(2, 24, true))
    ButtonMessageRoul(CasinoConfigSH.Lang.Bet) --ENTER
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    ButtonRoul(GetControlInstructionalButton(2, 51, true))
    ButtonMessageRoul(CasinoConfigSH.Lang.ChangeCam)
    PopScaleformMovieFunctionVoid()

   -- PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
   -- PushScaleformMovieFunctionParameterInt(3)
   -- ButtonRoul(GetControlInstructionalButton(2, 10, true))
   -- ButtonMessageRoul("Augmenter la mise") --Page Up
   -- PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    ButtonRoul(GetControlInstructionalButton(2, 22, true))
    ButtonMessageRoul(CasinoConfigSH.Lang.PersoBet) --Space
    PopScaleformMovieFunctionVoid()  
    
    

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end