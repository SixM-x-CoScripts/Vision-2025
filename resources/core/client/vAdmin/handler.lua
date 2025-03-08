RegisterNetEvent("core:FreezePlayer")
AddEventHandler("core:FreezePlayer", function(staut)
    FreezeEntityPosition(p:ped(), staut)
end)

RegisterNetEvent("core:GotoBring")
AddEventHandler("core:GotoBring", function(coords)
    SetEntityCoords(p:ped(), coords)
end)

RegisterNetEvent("core:ctxm:SetEntityCoords")
AddEventHandler("core:ctxm:SetEntityCoords", function(coords)
    SetEntityCoords(p:ped(), coords)
end)



RegisterNetEvent("core:StaffSpectate")
AddEventHandler("core:StaffSpectate", function(coords, id)
    if Staff.pLastId == nil then
        RequestCollisionAtCoord(coords)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do RequestCollisionAtCoord(coords) Citizen.Wait(0) end
        SetEntityVisible(PlayerPedId(), false)
        SetEntityCollision(PlayerPedId(), false, true)
        SetEntityCoords(PlayerPedId(), coords)
        Citizen.Wait(500)
        NetworkSetInSpectatorMode(true, GetPlayerPed(GetPlayerFromServerId(id)))
        Staff.pLastId = id
    else
        RequestCollisionAtCoord(Staff.pLastPosition)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do RequestCollisionAtCoord(Staff.pLastPosition)
            Citizen
                .Wait(0)
        end
        NetworkSetInSpectatorMode(false, GetPlayerPed(GetPlayerFromServerId(id)))
        SetEntityCoords(PlayerPedId(), Staff.pLastPosition)
        SetEntityCollision(PlayerPedId(), true, true)
        SetEntityVisible(PlayerPedId(), true)
        Staff.pLastId = nil
    end
end)


RegisterNetEvent("core:TakeScreenBiatch")
AddEventHandler("core:TakeScreenBiatch", function(license)
    exports["screenshot-basic"]:requestScreenshotUpload("https://discord.com/api/webhooks/1199399485177073897/4O3cPDVOyL9YH-IGXg8ETa2ANGAVQzBHKen3Rh39owvTSuMSgwgyncnEHi85oDN6EZRm", "files[]",
        function(data)
            local resp = json.decode(data)

            if resp == nil then 
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Une erreur est survenue lors de la capture d'écran, veuillez réessayer.",
                })
                return
            end

            TriggerServerEvent("testlog", resp.attachments[1].url, license)
        end)

end)


RegisterNetEvent("core:setPedStaff")
AddEventHandler("core:setPedStaff", function(ped)
    if LoadModel(ped) then
        if IsModelInCdimage(ped) and IsModelValid(ped) then
            SetPlayerModel(PlayerId(), ped)
            SetPedDefaultComponentVariation(p:ped())
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Un staff a changé votre ped.",
            })
        end
    end
end)

RegisterNetEvent("core:updatePermission")
AddEventHandler("core:updatePermission", function()
    Wait(1000)

    local perm = p:getPermission()
    if perm < 2 then

        vAdminMods.playerNames = false
        UseBlipsName(false)
        DestroyPlayerNames()
        DevPrint = false
        vAdminMods.blips = false
        UseBlipsName(false)
        DestroyGamerTag()

        updateAdminOverlay()
        AdminChecked = false;
        TriggerServerEvent("core:StaffInAction", token, AdminChecked)
        AdminInAction = AdminChecked

        vAdminMods = {
            noclip = false,
            freecam = false,
            godmode = false,
            invisible = false,
            blips = false,
            playerNames = false,
        }
    end
end)