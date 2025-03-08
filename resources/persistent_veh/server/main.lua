local PV = {
  players = {},
  vehicles = {},
  waiting = 0,
  debugging = Config.debug,
}

if Config.txAdmin then
  AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
      Citizen.CreateThread(function() 
        Wait(50000)
        PV:SavedPlayerVehiclesToFile()
      end)
    end
  end)
end

-- commands
RegisterCommand('pv-cull', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  PV:CullVehicles(args[1])
  print('Persistent Vehicles: Culled:', args[1] or 10)
end, true)

RegisterCommand('pv-forget-all', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  PV:ForgetAllVehicles()
end, true)

RegisterCommand('pv-save-to-file', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  PV:SavedPlayerVehiclesToFile()
end, true)

RegisterCommand('pv-toggle-debugging', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  PV.debugging = not PV.debugging
  print('Persistent Vehicles: Toggled debugging', PV.debugging)
end, true)

RegisterCommand('pv-num-spawned', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  print('Persistent Vehicles: Number of vehicles currently spawned including unregistered:' .. Utils.Tablelength(GetAllVehicles()) .. ' Number of registered spawned: ' .. PV.NumberSpawned())
end, true)

RegisterCommand('pv-num-registered', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  print('Persistent Vehicles: Number of persistent vehicles registered: ' .. Utils.Tablelength(PV.vehicles))
end, true)

RegisterCommand('pv-shutdown', function (source, args, rawCommand)
  if tonumber(source) > 0 then return end
  for i = GetNumResources(), 1, -1 do
      local resource = GetResourceByFindIndex(i)
      StopResource(resource)
  end
end, true)

--[[ 
-- pv-spawn-test <number of vehicles> <vehicle model name>
RegisterCommand('pv-spawn-test', function (source, args, rawCommand)
  local total = Utils.Tablelength(PV.vehicles) + 1
	local num = 0.5
  print('GetPlayerPed(source)', source)
  local ped = GetPlayerPed(1)
  local coords = GetEntityCoords(ped)
  local amount = args[1] or 1
  for i = 1, tonumber(amount) do
    local plate = tostring(total)
    local data = {
      props = {model = args[2] or 'blista', plate = plate },
      pos = {x = coords.x + num, y = coords.y + num, z = coords.z + 0.1, h = 40.0},
    }
    num = num + 1.45
    total = total + 1
    PV.vehicles[data.props.plate] = data
    print('Debugging: Added Vehicles')
  end
end, true)

 ]]
-- events
RegisterServerEvent('persistent-vehicles/server/register-vehicle')
AddEventHandler('persistent-vehicles/server/register-vehicle', function (netId, props, trailer, forgetAfter)
  local _source = source
  if type(netId) ~= 'number' then return end
  PV.players[_source] = true
  PV:RegisterVehicle(netId, props, trailer, forgetAfter)

  local entity = NetworkGetEntityFromNetworkId(netId)
end)

RegisterServerEvent('persistent-vehicles/server/update-vehicle')
AddEventHandler('persistent-vehicles/server/update-vehicle', function (plate, props, trailer, forgetAfter)
  if PV.vehicles[plate] == nil then return end
  PV.vehicles[plate].props = props

  if trailer ~= nil and trailer > 0 then
    PV.vehicles[plate].trailer = trailer
  end

  if forgetAfter ~= nil then
    PV.vehicles[plate].forgetOn = forgetAfter + GetGameTimer()
  end

  if PV.debugging then
    print('Persistent Vehicles: Updated vehicle props for:', plate)
  end
end)

RegisterServerEvent('persistent-vehicles/server/forget-vehicle')
AddEventHandler('persistent-vehicles/server/forget-vehicle', function (plate)
  PV:ForgetVehicle(plate)
end)

-- must be called from the server with TriggerEvent('persistent-vehicles/save-vehicles-to-file')
RegisterServerEvent('persistent-vehicles/save-vehicles-to-file')
AddEventHandler('persistent-vehicles/save-vehicles-to-file', function ()
  --if not GetInvokingResource() then return end
  PV:SavedPlayerVehiclesToFile()
end)

RegisterServerEvent('persistent-vehicles/done-spawning')
AddEventHandler('persistent-vehicles/done-spawning', function (response)
  local _source = source
  if PV.waiting[_source] then 
    for i = 1, #response do
      local data = response[i]
      local entity = NetworkGetEntityFromNetworkId(data.netId)
      
      -- bug fix: sometimes onesync cannot get entity from net id :/
      if not DoesEntityExist(entity) then
          if PV.vehicles[data.plate].tried then
            if PV.debugging then
              print('Persistent Vehicles: Had to forget vehicle: '.. data.plate .. ' because OneSync couldn\'t get its entity twice in a row :/')
            end
            PV.ForgetVehicle(data.plate)
          else
            PV.vehicles[data.plate].tried = true
          end
      elseif(PV.vehicles[data.plate]) then
        PV.vehicles[data.plate].netId = data.netId
        PV.vehicles[data.plate].entity = entity
        PV.vehicles[data.plate].tried = nil
      end
    end
    PV.waiting[_source] = nil
  end

  if PV.debugging then
    local _source = source
    print('Persistent Vehicles: Server received client spawn confirmation from:', _source)
  end
end)

RegisterServerEvent('persistent-vehicles/new-player')
AddEventHandler('persistent-vehicles/new-player', function()
  local _source = source
  PV.players[_source] = true
end)

AddEventHandler("onResourceStop", function(resource)
  if resource ~= GetCurrentResourceName() then return end
  if Config.populateOnReboot then
    PV.SavedPlayerVehiclesToFile()
  end
end)

-- global functions
function PV:RegisterVehicle(netId, props, trailer, forgetAfter)
  if self.vehicles[props.plate] ~= nil then return end
  if props.plate == nil then
    return print('Persistent Vehicles: You tried to register a vehicle without passing its vehicle properties')
  end
  -- don't register the vehicle immediately incase it is deleted straight away
  Citizen.SetTimeout(1500, function ()
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity then return end
    self.vehicles[props.plate] = {netId = netId, entity = entity, props = props}

    if trailer ~= nil and trailer > 0 then
      self.vehicles[props.plate].trailer = trailer
    end
    
    if forgetAfter ~= nil then
      self.vehicles[props.plate].forgetOn = forgetAfter + GetGameTimer()
    end

    if self.debugging then
      print('Persistent Vehicles: Registered Vehicle', props.plate, netId, entity)
    end
  end)
end

function PV:NumberSpawned()
  local num = 0
  for plate, data in pairs(self.vehicles) do
    if DoesEntityExist(data.entity) then
      num = num + 1
    end
  end
  return num
end

function PV:ForgetVehicle(plate)
  if not plate then return end
  self.vehicles[plate] = nil
  if self.debugging then
    print('Persistent Vehicles: Forgotten Vehicle', plate)
  end
end

function PV:CullVehicles(amount)
  local num = amount or 10
  for key, value in pairs(self.vehicles) do
    self.ForgetVehicle(key)
    num = num - 1
    if num == 0 then
      break
    end
  end
  if self.debugging then
    print('Persistent Vehicles: Culled vehicles', num)
  end
end

function PV:ForgetAllVehicles()
  local num = Utils.Tablelength(self.vehicles)
  self.vehicles = {}
  self:SavedPlayerVehiclesToFile()
  print('Persistent Vehicles: Forgotten '..num..' vehicles. No vehicles are now persistent.')
end

function PV:SavedPlayerVehiclesToFile()
  SaveResourceFile(GetCurrentResourceName(), "vehicle-data.json", json.encode(PV.vehicles), -1)
  print('Persistent Vehicles: '.. Utils.Tablelength(PV.vehicles) .. ' vehicles saved to file')
end

function PV:LoadVehiclesFromFile()
  Wait(0)
  local SavedPlayerVehicles = LoadResourceFile(GetCurrentResourceName(), "vehicle-data.json")
  if SavedPlayerVehicles ~= '' then
      Wait(0)
      self.vehicles = json.decode(SavedPlayerVehicles)
      if not self.vehicles then
          self.vehicles = {}
      end
      if self.debugging then
          print('Persistent Vehicles: Loaded '.. Utils.Tablelength(self.vehicles) .. ' Vehicle(s) from file')
      end
  end
end

-- we shouldn't need to do this but so many people report duplicate vehicles spawning.. 
function PV:RemoveDuplicates(payloads)
  local allVehicles = GetAllVehicles()
  local plates = {}
  for i=1, #allVehicles do
    plates[GetVehicleNumberPlateText(allVehicles[i])] = true
  end
  --throttle
  Citizen.Wait(0) 
  
  for id, data in pairs(payloads) do
    for i=1, #data do
      print('remove', plates[data[i].props.plate])
      if plates[data[i].props.plate] then
        if self.debugging then
          print('Persistent Vehicles: Duplicate vehicle prevented from spawning ' ..  data[i].props.plate)
        end
        self:ForgetVehicle(data[i].props.plate)
        data[i] = nil
      end
    end
  end
  return payloads
end

function PV:TriggerSpawnEvents()

  local payloads = {}
  local requests = 0
  local spawned = 0

  for plate, data in pairs(self.vehicles) do
    if not DoesEntityExist(data.entity) then
      if data.pos then
        -- throttle if request gets too large
        requests = requests + 1
        if requests % 3 == 0 then
          Citizen.Wait(0)
        end

        if data.forgetOn ~= nil and GetGameTimer() > data.forgetOn then
            self:ForgetVehicle(plate)
        else

          local closestPlayerId, closestDistance = Utils.GetClosestPlayerToCoords(self.players, data.pos)

          -- only spawn the vehicle if a client is close enough
          if closestPlayerId ~= nil and closestDistance < Config.respawnDistance then

            if payloads[closestPlayerId] == nil then
              payloads[closestPlayerId] = {}
              spawned = spawned + 1 -- cheaper than counting the payloads
            end
            
            -- limit total number of vehicles this player will spawn this tick
            if #payloads[closestPlayerId] <= 10 then
              table.insert(payloads[closestPlayerId], data)
            end
          end
        end
      else
        self:ForgetVehicle(plate)
        if self.debugging then
          print('Persistent Vehicles: Warning', plate, 'did NOT have time to update its position before it was deleted')
        end
      end
    end
  end
  
  if spawned > 0 then
    Citizen.Wait(0)
    self.waiting = {}

    payloads = self:RemoveDuplicates(payloads)

    -- consume any respawn requests we have
    for id, payload in pairs(payloads) do
      print("3", DoesEntityExist(GetPlayerPed(id)), id)
      if DoesEntityExist(GetPlayerPed(id)) and #payload > 0 then
        TriggerClientEvent('persistent-vehicles/spawn-vehicles', id, payload)
        self.waiting[id] = true
        if self.debugging then
          print('Persistent Vehicles: Sent', #payload, 'vehicle(s) to client', id, 'for spawning.')
        end
      end
    end

    -- wait upto 4 seconds for clients to report that they've finished spawning. Nearly all should report in the first tick.
    local waited = 0
    repeat
      Citizen.Wait(500)
      waited = waited + 1
    until Utils.Tablelength(self.waiting) == 0 or waited == 16
    if self.debugging and waited >= 16 then
      print('Persistent Vehicles: Waited too long for ' .. Utils.Tablelength(self.waiting) .. ' client(s) to respawn vehicles')
    end
  end
end

function PV:UpdateAllVehicleData()

  for plate, data in pairs(self.vehicles) do
    if DoesEntityExist(data.entity) then
      local coords =  GetEntityCoords(data.entity)
      local rot = GetEntityRotation(data.entity) -- returns inconsistent results in newer version of OneSync
      
      -- coords sometimes returns nil for no reason
      data.pos = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        h = GetEntityHeading(data.entity),
        r = { x = rot.x, y = rot.y, z = rot.z }
      }
      
      if data.props then
        --data.props.fuelLevel = 25 -- maybe GetVehicleFuelLevel() will be implemented server side one day?
        data.props.locked = GetVehicleDoorLockStatus(data.entity)
	      data.props.engine = GetIsVehicleEngineRunning(data.entity)
        data.props.engineHealth = GetVehicleEngineHealth(data.entity)
        data.props.tankHealth = GetVehiclePetrolTankHealth(data.entity)
        data.props.dirtLevel = GetVehicleDirtLevel(data.entity)
        data.props.bodyHealth = GetVehicleBodyHealth(data.entity)

        -- forget vehicle if destroyed
        if Config.forgetOnDestroyed and (data.props.bodyHealth < 0 or data.props.tankHealth < 0) then
          self:ForgetVehicle(plate)
        end

      else
        self:ForgetVehicle(plate)
      end
      
    end
  end
end

-- main thread
Citizen.CreateThread(function ()

  if Config.populateOnReboot then
    PV:LoadVehiclesFromFile() 
  end
  
  while true do
    Citizen.Wait(Config.serverTickTime)
    PV:UpdateAllVehicleData()
    Citizen.Wait(0)
    PV:TriggerSpawnEvents()
  end
end)