local shield = false

RegisterNetEvent("shield:TogglePoliceShield")
AddEventHandler("shield:TogglePoliceShield", function()
  Citizen.CreateThread(function()
    if not shield then
      local ped = PlayerPedId()
      local propName = "lspd_ballistic_shieldon_h"
      local coords = GetEntityCoords(ped)
      local prop = GetHashKey(propName)

      local dict = "smo@shield_pistol_req_01"
      local name = "shield_pistol_req_01_clip"

      while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
        RequestAnimDict(dict)
      end

      RequestModel(prop)
      while not HasModelLoaded(prop) do
        Citizen.Wait(100)
      end
      TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

      local attachProps = CreateObject(prop, coords, true, false, false)
      local netid = ObjToNet(attachProps)

      TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
      AttachEntityToEntity(attachProps, ped, GetPedBoneIndex(ped, 57005), -0.20, 0.27, -0.15, 42.0, 315.0, 80.0, false, false, false, true, 1, true)

      shield_net = netid
      shield = true
    else
      shield = false
      ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
      SetModelAsNoLongerNeeded(prop)
      SetEntityAsMissionEntity(attachProps, true, false)
      DetachEntity(NetToObj(shield_net), 1, 1)
      DeleteEntity(NetToObj(shield_net))
      shield_net = nil
    end
  end)
end)

RegisterNetEvent("shield:ToggleLSSDShield")
AddEventHandler("shield:ToggleLSSDShield", function()
  Citizen.CreateThread(function()
    if not shield then
      local ped = PlayerPedId()
      local propName = "lssd_ballistic_shieldon_b"
      local coords = GetEntityCoords(ped)
      local prop = GetHashKey(propName)

      local dict = "smo@shield_pistol_req_01"
      local name = "shield_pistol_req_01_clip"

      while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
        RequestAnimDict(dict)
      end

      RequestModel(prop)
      while not HasModelLoaded(prop) do
        Citizen.Wait(100)
      end
      TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

      local attachProps = CreateObject(prop, coords, true, false, false)
      local netid = ObjToNet(attachProps)

      TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
      AttachEntityToEntity(attachProps, ped, GetPedBoneIndex(ped, 57005), -0.20, 0.27, -0.15, 42.0, 315.0, 80.0, false, false, false, true, 1, true)

      shield_net = netid
      shield = true
    else
      shield = false
      ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
      SetModelAsNoLongerNeeded(prop)
      SetEntityAsMissionEntity(attachProps, true, false)
      DetachEntity(NetToObj(shield_net), 1, 1)
      DeleteEntity(NetToObj(shield_net))
      shield_net = nil
    end
  end)
end)