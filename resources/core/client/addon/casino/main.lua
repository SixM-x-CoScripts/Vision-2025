local posentree = CasinoConfig.EnterPos
local possortie = CasinoConfig.ExitPos

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local IsPedInArea = function(ped, x, y, z, radius)
    local pedcoords = GetEntityCoords(ped)
    return GetDistanceBetweenCoords(pedcoords, x, y, z, true) < radius+0.01 -- optimisé
end

local KeyboardInput = function(NameToShow, default, maxLength)
    AddTextEntry('FMMC_KEY_TIPCC', NameToShow)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIPCC", "", default, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

local vehActive = nil
local pedActive = nil
CreateThread(function()
    for k,v in pairs(CasinoConfig.Ipls) do
        RequestIpl(v)
    end
    EnableInteriorProp(274689, "Set_Pent_Tint_Shell")
    Wait(500)

    if CasinoConfig.Blips and CasinoConfig.Blips.activate then
        local blips = AddBlipForCoord(CasinoConfig.Blips.Pos.x, CasinoConfig.Blips.Pos.y, CasinoConfig.Blips.Pos.z)
        SetBlipSprite(blips, CasinoConfig.Blips.BlipId)
        SetBlipScale(blips, CasinoConfig.Blips.Scale)
        SetBlipColour(blips, CasinoConfig.Blips.Colour)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(CasinoConfig.Blips.Name)
        EndTextCommandSetBlipName(blips)
    end

    for k,v in pairs(CasinoConfig.Peds) do 
        if v.pedHash and v.pos then 
            if IsModelInCdimage(v.pedHash) then
                RequestModel(v.pedHash)
                while not HasModelLoaded(v.pedHash) do 
                    Wait(1)
                end
                local ped = CreatePed(4, v.pedHash, v.pos)
                FreezeEntityPosition(ped, v.freeze)
                SetEntityAsMissionEntity(ped, true, true)
                SetBlockingOfNonTemporaryEvents(ped, v.freeze)
                setBlackjackDealerClothes(7,ped)
                SetEntityInvincible(ped, v.invincible)
                if IsPedMale(ped) then
                    SetPedVoiceGroup(ped,GetHashKey("S_M_Y_Casino_01_WHITE_01"))
                else
                    SetPedVoiceGroup(ped,GetHashKey("S_F_Y_Casino_01_ASIAN_01"))	
                end
                pedActive = ped
            end
        end
    end

    while true do 
        Wait(1)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z < -30.0 then
            if IsPedInArea(PlayerPedId(), CasinoConfig.BuyChipsPos.x, CasinoConfig.BuyChipsPos.y, CasinoConfig.BuyChipsPos.z, 10.0) then
                local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CasinoConfig.BuyChipsPos.x, CasinoConfig.BuyChipsPos.y, CasinoConfig.BuyChipsPos.z)
                Bulle.create("achatcasino", vector3(1115.83, 220.17, -49.44), "bulleAcheterCasino", true)
                if dist < 3.0 then 
                    --CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.PressToBuy)
                    if IsControlJustPressed(0, 38) then 
                        PlayPedAmbientSpeechNative(pedActive,"MINIGAME_DEALER_GREET","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
                        --local jetons = tonumber(KeyboardInput(string.format(CasinoConfigSH.Lang.NumberToSell, CasinoConfig.ChipPrice), "", 20))
                        --if jetons and jetons > 0 then 
                        --    TriggerServerEvent("sunwise:casino:sellChips", jetons)
                        --end

                        SendNUIMessage({
                            type = 'openWebview',
                            name = 'MenuCasino',
                            data = {
                                premium = p:getSubscription(),
                                userChips = tonumber(Actualchips),
                            }
                        })
                    end 
                end
            else
                local distentree = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), possortie, true)
                if distentree < 10.0 then 
                    if distentree < 3.0 then 
                        CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.ExitCasino)
                        if IsControlJustPressed(0, 38) then 
                            RequestCollisionAtCoord(posentree)
                            TriggerServerEvent("sunwisecasino:status", "exit")
                            SetEntityCoords(PlayerPedId(), posentree)
                            DeletePedsCasino()
                        end
                    end
                else
                    Wait(1500)
                end
            end
        else
            local distentree = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), posentree, true)
            if distentree < 15.0 then 
                if distentree < 6.0 then 
                    CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.EnterCasino)
                    if IsControlJustPressed(0, 38) then 
                        if GlobalState.CasinoOpen then
                            RequestCollisionAtCoord(possortie)
                            SetEntityCoords(PlayerPedId(), possortie)
                            TriggerServerEvent("sunwisecasino:status", "enter")
                            SWTriggerServCallback("sunwisecasino:GetNumJetons", function(cb)
                                Actualchips = cb
                            end)
                            Wait(200)
                            ShowChips(Actualchips)
                            CreatePedsCasino()
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Le casino n'est pas ouvert"
                            })
                        end
                    end
                end
            else                
                Wait(2000)
            end
        end
    end
end)

RegisterNUICallback("casino.buyChips", function(data)
    local chips = data.chips 
    SWTriggerServCallback("Flozii:CanHaveJetons", function(cb)
        if cb then 
            CasinoConfig.ShowNotification(string.format(CasinoConfigSH.Lang.Youbought, data.chips))
            TriggerServerEvent("core:logCasino", data.chips, "achat")
            TriggerServerEvent("core:logs", token, {type = "casino", value = "Achat jetons : x" .. data.chips .. "\nTotal de jetons : " .. Actualchips})
        end
    end, data.chips)
    closeUI()
end)

RegisterNUICallback("casino.sellChips", function(data)
    local chips = data.chips 
    if chips == 0 then
        return
    end
    
    local sold = false
    for key, value in pairs(p:getInventaire()) do
        if value.name == "casino_chips" and value.count >= chips then
            sold = true
            TriggerServerEvent("core:RemoveItemToInventory", token, "casino_chips", chips, value.metadatas)
        end
    end
    if sold then
        p:AddItem("money", chips, {})
        TriggerEvent("casino:chipshud:remove", chips)
    end
    closeUI()
    Wait(2000)
    TriggerServerEvent("core:logCasino", data.chips, "vente")
    TriggerServerEvent("core:logs", token, {type = "casino", value = "Vente jetons : x" .. chips .. "\nTotal de jetons : " .. Actualchips})
end)

RegisterNetEvent("swcasino:updatehud", function(chip)
    ShowChips(chip)
end)

Actualchips = 0
RegisterCommand("setChips", function(source, args)
    ShowChips(tonumber(args[1]))
end)
function ShowChips(_chips)
    if CasinoConfig.ShowHUDChips then
        local scale = RequestScaleformScriptHudMovie(21)
        while not HasScaleformScriptHudMovieLoaded(21) do
            Wait(0)
        end
        BeginScaleformScriptHudMovieMethod(21, "SET_PLAYER_CHIPS")
        ScaleformMovieMethodAddParamInt(_chips)
        EndScaleformMovieMethod()
        if _chips ~= Actualchips then
            local bool = true
            local change = _chips - Actualchips
            if _chips < Actualchips then
                bool = false
                change = change*-1
            end
            local scale = RequestScaleformScriptHudMovie(22)
            while not HasScaleformScriptHudMovieLoaded(22) do
                Wait(0)
            end
            BeginScaleformScriptHudMovieMethod(22, "SET_PLAYER_CHIP_CHANGE")
            ScaleformMovieMethodAddParamInt(change)
            ScaleformMovieMethodAddParamBool(bool)
            EndScaleformMovieMethod()
        end
        Actualchips = _chips
        Wait(4000)
        RemoveScaleformScriptHudMovie(21)
        RemoveScaleformScriptHudMovie(22)
    end
end

RegisterNetEvent("casino:chipshud:give", function(amount)
    local chip = Actualchips + tonumber(amount)
    ShowChips(chip)
end)
RegisterNetEvent("casino:chipshud:remove", function(amount)
    local chip = Actualchips - tonumber(amount)
    ShowChips(chip)
end)

while not zone do Wait(100) end
zone.addZone("casinoAscenceur1", -- Nom
    vector3(1139.24, 234.8, -50.44),
    "~INPUT_CONTEXT~ Magasin de masque",
    function()
        if p:getPermission() > 0 then 
            SetEntityCoords(PlayerPedId(), 980.77, 56.61, 116.16)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous devez être VIP pour acceder à cet endroit"
            })
        end
    end, 
    false,
    27,
    1.5,
    { 255, 255, 255 },
    170,
    5.0,
    true,
    "bulleAscenseur"
)

zone.addZone("casinoAscenceur2", -- Nom
    vector3(980.77, 56.61, 116.16),
    "~INPUT_CONTEXT~ Magasin de masque",
    function()
        SetEntityCoords(PlayerPedId(), 1139.24, 234.8, -50.44)
    end, 
    false,
    27,
    1.5,
    { 255, 255, 255 },
    170,
    5.0,
    true,
    "bulleAscenseur"
)

CreateThread(function()
    local ent2 = entity:CreateObjectLocal("prop_atm_01", vector3(1095.19, 208.03, -50.0)).id
    SetEntityHeading(ent2, 343.01-180.0)
    SetEntityAsMissionEntity(ent2, true, true)
end)