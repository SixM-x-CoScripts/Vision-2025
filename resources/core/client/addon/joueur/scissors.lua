local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
  token = t
end)

RegisterNetEvent("core:scissors")
AddEventHandler("core:scissors", function()
  local closestPlayer = ChoicePlayersInZone(5.0, true)
  if closestPlayer == nil then
    return
  end
  local globalTarget = GetPlayerServerId(closestPlayer)
  
  -- update haircut of the player
  TriggerServerEvent("core:scissors", token, globalTarget)
end)