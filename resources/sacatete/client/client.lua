local propsHeadBag = nil 

RegisterNetEvent("core:setBagInHead", function(int)
    if tonumber(int) == 1 then 
        TriggerServerEvent("TREFSDFD5156FD", "IOAPP", 5000)
        RequestModel(GetHashKey("prop_money_bag_01"))
        while not HasModelLoaded(GetHashKey("prop_money_bag_01")) do Wait(1) end
        propsHeadBag = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(propsHeadBag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
        SendNUIMessage({
            type = "openWebview",
            name = "bagInHead",
            data = {
                opacity = 1
            }
        })
        Wait(250)
        SetNuiFocus(false, false)
    else 
        DeleteEntity(propsHeadBag)
        SetEntityAsNoLongerNeeded(propsHeadBag)
		SetModelAsNoLongerNeeded(GetHashKey("prop_money_bag_01"))
        SendNUIMessage({
            type = "closeWebview",
            name = "bagInHead",
            data = {
                opacity = 0
            }
        })

        Wait(250)
        SetNuiFocus(false, false)
    end 
end)