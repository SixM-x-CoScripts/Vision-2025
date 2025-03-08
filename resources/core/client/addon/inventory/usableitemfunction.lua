local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function createSapin()

    local haveitem, problem = TriggerServerCallback("core:sapinprerequischeck", token)
    if haveitem == true then
      TriggerServerEvent("core:RemoveItemToInventory", token, "sapin", 1, {})
      TriggerServerEvent("core:RemoveItemToInventory", token, "guirlande", 1, {})
      TriggerServerEvent("core:RemoveItemToInventory", token, "boulenoel", 3, {})

      FreezeEntityPosition(p:ped(), true)
      p:PlayAnim("mini@repair", "fixing_a_ped", 1)
      Wait(1500)

      local px, py, pz = table.unpack(p:pos()) -- Les coords du joueurs unpack
      local vx, vy , vz = table.unpack(GetEntityForwardVector(p:ped())) -- Le vecteur unitaire de direction du joueur unpack
      local x = px + vx  -- Utilise le vecteur unitaire pour mettre les props à 1 unité de lui grace au vecteur unitaire + ces coords
      local y = py + vy
      local z = pz + vz 

      local prop = "prop_xmas_tree_int"
      local modelhash = GetHashKey(prop)
      local isNetwork = true

      RequestModel(modelhash)
      while not HasModelLoaded(modelhash) do
        Wait(100)
      end

      sapin = CreateObject(modelhash, x, y, z, isNetwork, false, false)
      PlaceObjectOnGroundProperly(sapin)
      FreezeEntityPosition(sapin, true)
      SetModelAsNoLongerNeeded(modelhash) -- unload de la mémoire le props (bonne procédure d'opti)

      Wait(5000)
      ClearPedTasks(p:ped())
      FreezeEntityPosition(p:ped(), false)
    else
      -- ShowNotification("Vous n'avez pas assez de "  ..problem.. " !")

      -- New notif
      exports['vNotif']:createNotification({
        type = 'ROUGE',
        -- duration = 5, -- In seconds, default:  4
        content = "Vous n'avez pas assez de ~s " ..problem.. " !"
      })

    end
end

RegisterNetEvent("core:SpawnSapinNoel")
AddEventHandler("core:SpawnSapinNoel", createSapin)

-- Test /debugger pour la création du sapin
--[[RegisterCommand('sapin', function(source, args, rawCommand)
    createSapin(source)
end)]]

