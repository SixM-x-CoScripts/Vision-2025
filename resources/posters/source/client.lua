editing = false
deleting = false
Point1 = false
Point2 = false
ActivePosters = {}
CurrentPoster = {}
GLOBAL_COORDS = nil
TXD = nil

local function RotationToDirection(rot)
	rot = rot or GetGameplayCamRot(2)
	local rotZ = rot.z  * ( 3.141593 / 180.0 )
	local rotX = rot.x  * ( 3.141593 / 180.0 )
	local c = math.cos(rotX)
	local multXY = math.abs(c)   
	local res = vector3((math.sin(rotZ) * -1) * multXY, math.cos(rotZ) * multXY, math.sin(rotX)) 
	return res 
end

local function GetCoordsInFrontOfCam(...)   
	local unpack = table.unpack   
	local coords,direction = GetGameplayCamCoord(), RotationToDirection()   
	local inTable  = {...}   
	local retTable = {}    
	if (#inTable == 0) or (inTable[1] < 0.000001) then
		inTable[1] = 0.000001
	end    
	for k,distance in pairs(inTable) do     
		if (type(distance) == "number") then       
			if (distance == 0) then         
				retTable[k] = coords       
			else         
				retTable[k] = vector3(coords.x + (distance * direction.x), coords.y + (distance * direction.y), coords.z + (distance * direction.z))  
			end     
		end   
	end   
	return unpack(retTable)
end

local function DrawSelectedArea(PointA, PointB, minZ, maxZ, r, g, b, a)
	DrawPoly(PointB.x, PointB.y, minZ, PointB.x, PointB.y, maxZ, PointA.x, PointA.y, maxZ, r, g, b, a)
	DrawPoly(PointB.x, PointB.y, minZ, PointA.x, PointA.y, maxZ, PointA.x, PointA.y, minZ, r, g, b, a)
end

local function DrawImageOnArea(PointA, PointB, minZ, maxZ, r, g, b, a, texture, dict)
	DrawSpritePoly(PointB.x, PointB.y, minZ, PointB.x, PointB.y, maxZ, PointA.x, PointA.y, maxZ, r, g, b, a, texture, dict, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0)
	DrawSpritePoly(PointA.x, PointA.y, maxZ, PointA.x, PointA.y, minZ, PointB.x, PointB.y, minZ, r, g, b, a, texture, dict, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0)
end

--[[
function loadData()
    for k,v in pairs(images) do
        DUILoaded = false
        v.duiObj = CreateDui(string.format("https://cfx-nui-%s/web/dist/index.html", GetCurrentResourceName()), v.width, v.height)
        v.duiHandle = GetDuiHandle(v.duiObj)
        v.txd = CreateRuntimeTxd(v.textureid)
        v.texture = CreateRuntimeTextureFromDuiHandle(v.txd, v.txn, v.duiHandle)
        while not DUILoaded do Wait(0) end
        SendDuiMessage(v.duiObj, json.encode({
            action = "setDUIVariables",
            imageSrc = v.url,
            width = v.width,
            height = v.height,
        }))
        ActivePosters[#ActivePosters+1] = v
        Wait(1000)
    end
end]]

RegisterNetEvent("posters:deleteClientImage", function(id)
    for k,v in pairs(ActivePosters) do
        if v.id == id then
            DestroyDui(v.duiObj)
            table.remove(ActivePosters, k)
            break
        end
    end
end)

RegisterNetEvent("posters:sendAddedImage", function(newImage)
    DUILoaded = false
    newImage.duiObj = CreateDui(string.format("https://cfx-nui-%s/web/dist/index.html", GetCurrentResourceName()), newImage.width, newImage.height)
    newImage.duiHandle = GetDuiHandle(newImage.duiObj)
    newImage.txd = CreateRuntimeTxd(newImage.textureid)
    newImage.texture = CreateRuntimeTextureFromDuiHandle(newImage.txd, newImage.txn, newImage.duiHandle)
    while not DUILoaded do Wait(0) end
    SendDuiMessage(newImage.duiObj, json.encode({
        action = "setDUIVariables",
        imageSrc = newImage.url,
        width = newImage.width,
        height = newImage.height,
    }))
    ActivePosters[#ActivePosters+1] = newImage
end)

local function PlaceImage()
    editing = true
    Point1 = false
    Point2 = false
    CurrentPoster = {}
    while editing do
        DisableControlAction(0, 38, true)
        local start,fin = GetCoordsInFrontOfCam(0, 5000)
        local ray = StartShapeTestRay(start.x, start.y, start.z, fin.x, fin.y, fin.z, 4294967295, PlayerPedId(), 5000)
        local _ray,hit,pos,norm,ent = GetShapeTestResult(ray)
        if hit then
            DrawSphere(pos, 0.06, 0, 255, 0, 0.5)
            if not Point1 then
                if IsDisabledControlJustReleased(0, 38) then
                    Point1 = pos
                    Point2 = pos
                    Wait(100)

                end
            end
            if Point2 then
                Point2 = pos
                if IsDisabledControlJustReleased(0, 38) then
                    editing = false
                end
            end
        end
        if Point1 then
            DrawSelectedArea(Point1, Point2, Point2.z, Point1.z, 0, 155, 0, 80)
        end
        Wait(0)
    end
    if #(Point1 - Point2) < 50.0 then
        CurrentPoster.pointA = Point1
        CurrentPoster.pointB = Point2
        SendNUIMessage({ action = "openEditor" })
        SetNuiFocus(true, true)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "La taille du poster doit être inférieure à 50m"
        })
    end
end

function DeleteImage()
    deleting = true
    lib.showTextUI("[E] Select Image Area", {
        icon = 'fas fa-hand-pointer',
        position = 'left-center', 
    })
    while deleting do
        DisableControlAction(0, 38, true)
        local start,fin = GetCoordsInFrontOfCam(0, 5000)
        local ray = StartShapeTestRay(start.x, start.y, start.z, fin.x, fin.y, fin.z, 4294967295, PlayerPedId(), 5000)
        local _ray,hit,pos,norm,ent = GetShapeTestResult(ray)
        if hit then
            DrawSphere(pos, 0.06, 0, 255, 0, 0.5)
            if IsDisabledControlJustReleased(0, 38) then
                deleting = false
                lib.hideTextUI()
                local closestDist, currentKey = 999.9, 1
                local currentPoster = nil
                for k,v in pairs(ActivePosters) do
                    if #(pos - v.pointA) < closestDist then
                        closestDist = #(pos - v.pointA)
                        currentKey = v.id
                        currentPoster = v
                    end
                    if #(pos - v.pointB) < closestDist then
                        closestDist = #(pos - v.pointB)
                        currentKey = v.id
                        currentPoster = v
                    end
                end
                if closestDist < 10 then
                    if lib.progressCircle({
                        label = 'Removing Poster...',
                        duration = 10000,
                        position = "bottom",
                        useWhileDead = false,
                        canCancel = true,
                        disable = {car = true, move = true, combat = true},
                        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
                    }) then
                        TriggerServerEvent("posters:deleteImage", currentKey, GetPlayerName(PlayerId()) == currentPoster.cid)
                        print('Poster sent for deletion!')
                    else
                        print('Menu deletion canceled.')
                    end
                else
                    print('Could not find an poster close enough to delete. Please try again')
                end
            end
        end
        Wait(0)
    end
end

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNuiCallback('loaded', function(_, cb)
    DUILoaded = true
    cb({resName = GetCurrentResourceName()})
end)

RegisterNUICallback("savePoster", function(data, cb)
    SetNuiFocus(false, false)
    CurrentPoster.url = data.url
    CurrentPoster.width = data.width
    CurrentPoster.height = data.height
    CurrentPoster.id = math.random(999999, 999999999)
    CurrentPoster.cid = GetPlayerName(PlayerId())
    CurrentPoster.textureid = "newtexture"..tostring(math.random(1, 100000))
    CurrentPoster.txn = "newtexture"..tostring(math.random(1, 100000))
    TriggerServerEvent("posters:addNewImage", CurrentPoster)
    cb('ok')
end)

CreateThread(function()
    while true do
        GLOBAL_COORDS = GetEntityCoords(PlayerPedId())
        Wait(1500)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1500
        for k,v in pairs(ActivePosters) do
            if #(GLOBAL_COORDS - v.pointA) < 50.0 or #(GLOBAL_COORDS - v.pointB) < 50.0 then
                sleep = 0
                DrawImageOnArea(v.pointA, v.pointB, v.pointB.z, v.pointA.z, 255, 255, 255, 255, v.textureid, v.txn)
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("posters:placeImage", PlaceImage)

RegisterNetEvent("posters:removePoster", DeleteImage)

RegisterCommand("image", function(source, args, raw)
    PlaceImage()
end)
