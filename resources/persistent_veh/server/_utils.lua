Utils = {}

function Utils.Tablelength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

function Utils.DistanceBetweenCoords(coordsA, coordsB)
	return #(vector3(coordsA.x, coordsA.y, coordsA.z).xy - vector3(coordsB.x, coordsB.y, coordsB.z).xy)
end

function Utils.DistanceFrom(x1, y1, z1, x2, y2, z2)
  return  math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function Utils.GetPlayers()
  local players = {}
  for _source,v in pairs(PV.players) do
    local ped = GetPlayerPed(_source)
    if DoesEntityExist(ped) then
      table.insert(players, _source)
    else
      PV.players[_source] = nil
    end
  end
	return players
end

function Utils.GetClosestPlayerToCoords(players, coords)
  local closestDist, closestPlayerId, ped, dist, pedCoords
  for playerId in pairs(players) do
    ped = GetPlayerPed(playerId)
    if ped > 0 then
      pedCoords = GetEntityCoords(ped)
      dist = Utils.DistanceBetweenCoords(pedCoords, coords)
      if not closestDist or dist < closestDist then
          closestDist = dist
          closestPlayerId = playerId
      end
      -- this is close enough, no need to go through every player
      if closestDist < Config.respawnDistance then
         break
      end
    end
  end
  return closestPlayerId, closestDist
end