-- local isAttached = false
-- local canSleep = false

-- Citizen.CreateThread(function()
--     AddTextEntry("press_attach_vehicle", "Press ~INPUT_DETONATE~ to pick up this container up")
--     AddTextEntry("press_detach_vehicle", "Press ~INPUT_DETONATE~ to detach this container")
--     while true do
--         Citizen.Wait(10)
--         local ped = PlayerPedId()
--         if IsPedInAnyVehicle(ped, false) then
--             local veh = GetVehiclePedIsIn(ped, false)
--             if GetEntityModel(veh) == `handler` then
--                 local pedCoords = GetEntityCoords(ped, 0)
--                 local objectId = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z+5.0, 5.0, GetHashKey("prop_contr_03b_ld"), false)
--                 if objectId ~= 0 then
--                     if isAttached then

--                         if IsEntityAttachedToHandlerFrame(veh, objectId) == false then
--                             isAttached = false
--                             Wait(2000)
--                         end

--                         DisplayHelpTextThisFrame("press_detach_vehicle")
--                     else
--                         if IsHandlerFrameAboveContainer(veh, objectId) == 1 then
--                             DisplayHelpTextThisFrame("press_attach_vehicle")
--                         end
--                     end
                    
--                     if IsControlJustPressed(0, 47) then
--                         if isAttached ~= true and IsHandlerFrameAboveContainer(veh, objectId) == 1 then
--                             AttachContainerToHandlerFrame(veh, objectId)
--                             isAttached = true
--                         else
--                             DetachContainerFromHandlerFrame(veh)
--                             isAttached = false
--                             Wait(2000)
--                         end
--                     end
--                     canSleep = false
--                 else
--                     if not isAttached then
--                         canSleep = true
--                     end
--                 end
--             end
--         end
--         if canSleep then
--             Citizen.Wait(2000)
--         end
--     end
-- end)


-- -- Variables globales
-- local useCraneTick
-- local usingCrane = false
-- local soundID = {}
-- local camera

-- -- Charger les sons et animations
-- RequestAmbientAudioBank('Crane', false, -1)
-- RequestAmbientAudioBank('Crane_Stress', false, -1)
-- RequestAmbientAudioBank('Crane_Impact_Sweeteners', false, -1)
-- RequestScriptAudioBank('Container_Lifter', false, -1)
-- RequestAnimDict('map_objects')
-- RequestAnimDict('missheistdockssetup1trevor_crane')

-- -- Classe Crane
-- Crane = {}
-- Crane.__index = Crane

-- function Crane:new()
--     local instance = setmetatable({}, Crane)
--     instance.container = nil
--     instance.cameraAngle = nil
--     return instance
-- end

-- function Crane:SetContainer(container)
--     self.container = container
-- end

-- function Crane:GetPos(object)
--     local x,y,z = table.unpack(GetEntityCoords(CranecreatedObjects[object]))
--     return {x,y,z}
-- end

-- function Crane:Down()
--     local cable = 'lifter-cables' .. currentCable
--     local maxZ = self.container and -2.16 or -2.5

--     if (math.round((CraneObjects[cable].position.z - 0.06 + 0.000001) * 100) / 100) >= maxZ then
--         if not soundID['down'] then
--             soundID['down'] = { id = GetSoundId(), played = true }
--             PlaySoundFromEntity(soundID['down'].id, 'Move_U_D', CranecreatedObjects['cabin'], 'CRANE_SOUNDS', 0, false, 0)
--         end
--         CraneObjects[cable].position.z = CraneObjects[cable].position.z - 0.06
--         AttachEntityToEntity(CranecreatedObjects[cable], CranecreatedObjects['lifter-cables' .. (currentCable - 1)], 0, 0.0, 0.0, CraneObjects[cable].position.z, 0.0, 0.0, 90.0, false, false, true, false, 0, false)
--     else
--         if currentCable ~= 6 then
--             currentCable = currentCable + 1
--         end
--     end
-- end

-- function Crane:Up()
--     local cable = 'lifter-cables' .. currentCable

--     if (math.round((CraneObjects[cable].position.z + 0.06 + 0.000001) * 100) / 100) < 0.0 then
--         if not soundID['up'] then
--             soundID['up'] = { id = GetSoundId(), played = true }
--             PlaySoundFromEntity(soundID['up'].id, 'Move_U_D', CranecreatedObjects['cabin'], 'CRANE_SOUNDS', 0, false, 0)
--         end
--         CraneObjects[cable].position.z = CraneObjects[cable].position.z + 0.06
--         AttachEntityToEntity(CranecreatedObjects[cable], CranecreatedObjects['lifter-cables' .. (currentCable - 1)], 0, 0.0, 0.0, CraneObjects[cable].position.z, 0.0, 0.0, 90.0, false, false, true, false, 0, false)
--     else
--         if currentCable ~= 2 then
--             currentCable = currentCable - 1
--         end
--     end
-- end

-- function Crane:Left()
--     if (math.round((CraneObjects['cabin'].position.y - 0.02 + 0.000001) * 100) / 100) > -7.0 then
--         if not soundID['left'] then
--             soundID['left'] = { id = GetSoundId(), played = true }
--             PlaySoundFromEntity(soundID['left'].id, 'Move_L_R', CranecreatedObjects['cabin'], 'CRANE_SOUNDS', 0, false, 0)
--         end
--         CraneObjects['cabin'].position.y = CraneObjects['cabin'].position.y - 0.02
--         AttachEntityToEntity(CranecreatedObjects['cabin'], CranecreatedObjects['frame'], 0, -0.1, CraneObjects['cabin'].position.y, 18.0, 0.0, 0.0, 0.0, false, false, true, false, 0, false)
--         self:Camera(self.cameraAngle, { 1, CraneObjects['cabin'].position.y })
--     end
-- end

-- function Crane:Right()
--     if (math.round((CraneObjects['cabin'].position.y - 0.02 + 0.000001) * 100) / 100) < 5.66 then
--         if not soundID['right'] then
--             soundID['right'] = { id = GetSoundId(), played = true }
--             PlaySoundFromEntity(soundID['right'].id, 'Move_L_R', CranecreatedObjects['cabin'], 'CRANE_SOUNDS', 0, false, 0)
--         end
--         CraneObjects['cabin'].position.y = CraneObjects['cabin'].position.y + 0.02
--         AttachEntityToEntity(CranecreatedObjects['cabin'], CranecreatedObjects['frame'], 0, -0.1, CraneObjects['cabin'].position.y, 18.0, 0.0, 0.0, 0.0, false, false, true, false, 0, false)
--         self:Camera(self.cameraAngle, { 1, CraneObjects['cabin'].position.y })
--     end
-- end

-- function Crane:Forward()
--     if (math.round((CraneObjects['frame'].coords.x - 0.05 + 0.000001) * 100) / 100) > -109.34 then
--         if not soundID['forward'] then
--             soundID['forward'] = { id = GetSoundId(), played = true }
--             PlaySoundFromEntity(soundID['forward'].id, 'Move_Base', CranecreatedObjects['cabin'], 'CRANE_SOUNDS', 0, false, 0)
--         end
--         CraneObjects['frame'].coords.x = CraneObjects['frame'].coords.x - 0.05
--         SetEntityCoords(CranecreatedObjects['frame'], CraneObjects['frame'].coords.x, CraneObjects['frame'].coords.y, CraneObjects['frame'].coords.z - 0.12)
--         self:Camera(self.cameraAngle, { 0, CraneObjects['cabin'].position.x })
--     end
-- end

-- function Crane:Backwards()
--     if (math.round((CraneObjects['frame'].coords.x + 0.05 + 0.000001) * 100) / 100) < -47.29 then
--         if not soundID['backwards'] then
--             soundID['backwards'] = { id = GetSoundId(), played = true }
--             PlaySoundFromEntity(soundID['backwards'].id, 'Move_Base', CranecreatedObjects['cabin'], 'CRANE_SOUNDS', 0, false, 0)
--         end
--         CraneObjects['frame'].coords.x = CraneObjects['frame'].coords.x + 0.05
--         SetEntityCoords(CranecreatedObjects['frame'], CraneObjects['frame'].coords.x, CraneObjects['frame'].coords.y, CraneObjects['frame'].coords.z - 0.12)
--         self:Camera(self.cameraAngle, { 0, CraneObjects['cabin'].position.x })
--     end
-- end

-- function Crane:Attach()
--     for container, data in pairs(CraneObjects.containers) do
--         local model = GetHashKey(data.model)
--         local coords = self:GetPos('lifter')
--         local closestContainer = GetClosestObjectOfType(coords[1], coords[2], coords[3] - 2.8, 1.0, model)

--         if closestContainer and not self.container then
--             self.container = closestContainer
--             FreezeEntityPosition(self.container, true)
--             AttachEntityToEntity(self.container, CranecreatedObjects['lifter'], 0, 0.0, 0.0, -3.2, 0.0, 0.0, 90.0, false, false, true, false, 0, false)
--             PlaySoundFromEntity(-1, 'Attach_Container', CranecreatedObjects['frame'], 'CRANE_SOUNDS', false, false)
--             PlayEntityAnim(CranecreatedObjects['lifter'], 'Dock_crane_SLD_load', 'map_objects', 8.0, false, true, 0, 0.0, 0)
--         end
--     end
-- end

-- function Crane:Detach()
--     local zValue = 5

--     for container, data in pairs(CraneObjects.containers) do
--         local model = GetHashKey(data.model)
--         local coords = self:GetPos('lifter')
--         local closestContainer = GetClosestObjectOfType(coords[1], coords[2], zValue, 1.5, model)

--         if closestContainer and self.container ~= closestContainer then
--             zValue = GetEntityCoords(closestContainer).z + 2.8
--         end
--     end

--     DetachEntity(self.container)
--     SetEntityCollision(self.container, false, true)
--     FreezeEntityPosition(self.container, false)
--     SetEntityDynamic(self.container, true)
--     PlaySoundFromEntity(-1, 'Detach_Container', CranecreatedObjects['frame'], 'CRANE_SOUNDS', false, false)
--     PlayEntityAnim(CranecreatedObjects['lifter'], 'Dock_crane_SLD_unload', 'map_objects', 8.0, false, true, 0, 0.0, 0)

--     Citizen.CreateThread(function()
--         while true do
--             Citizen.Wait(1)
--             if GetEntityCoords(self.container).z <= zValue then
--                 SetEntityCollision(self.container, true, true)
--                 StopSound(soundID['down'].id)
--                 ReleaseSoundId(soundID['down'].id)
--                 FreezeEntityPosition(self.container, true)
--                 break
--             end
--         end
--     end)
-- end

-- function Crane:Rotate()
--     local direction = GetEntityHeading(CranecreatedObjects['lifter'])

--     if direction >= 5.0 and direction <= 175.0 then
--         SetEntityHeading(CranecreatedObjects['lifter'], 185.0)
--     else
--         SetEntityHeading(CranecreatedObjects['lifter'], 0.0)
--     end
-- end

-- function Crane:Camera(angle, pos)
--     local frameCoords = Crane:GetPos('frame')
--     local cabinCoords = Crane:GetPos('cabin')
    
--     if ( not DoesCamExist(camera) ) then
--         camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true);
--     end

--     if angle == 0 then 
--         RenderScriptCams(false,  false,  0,  true,  true);
--         DestroyCam(camera);
--         self.cameraAngle = 0;
--     elseif angle == 1 then
--         if ( pos ) then
--             if ( cabinCoords[pos[1]] < pos[2] ) then
--                 cabinCoords[pos[1]] = cabinCoords[pos[1]] + pos[2];
--             else
--                 cabinCoords[pos[1]] = cabinCoords[pos[1]] - pos[2];
--             end
--         end

--         self.cameraAngle = 1;

--         SetCamCoord(camera, cabinCoords[1], cabinCoords[2] + 1, cabinCoords[3] - 2.8);
--         PointCamAtCoord(camera, cabinCoords[1], cabinCoords[2] + 1, cabinCoords[3] - 10);
--         RenderScriptCams(true, true, 0, true, true);
--     elseif angle == 2 then
--         self.cameraAngle = 2;
--         SetCamCoord(camera, frameCoords[1] - 5, frameCoords[2] + 8, frameCoords[3] + 10);
--         PointCamAtCoord(camera, cabinCoords[1], cabinCoords[2], cabinCoords[3] - 20);
--         RenderScriptCams(true, true, 0, true, true);
--     elseif angle == 3 then
--         this.cameraAngle = 3;
--         SetCamCoord(camera, frameCoords[0] + 5, frameCoords[1] - 8, frameCoords[2] + 10);
--         PointCamAtCoord(camera, cabinCoords[0], cabinCoords[1], cabinCoords[2] - 20);
--         RenderScriptCams(true, true, 0, true, true);
--     end
-- end


-- function Crane:AttachOrDetach() 
--     if ( not self.container ) then
--         self.Attach();
--     else
--         self.Detach();
--     end
-- end

-- function releaseSound( sound )
--     if ( soundID[sound] ) then
--         StopSound(soundID[sound].id)
--         ReleaseSoundId(soundID[sound].id)
--         soundID[sound] = nil
--     end
-- end

-- function useCrane()
--     useCraneTick = CreateThread(function()
--         usingCrane = true
--         while true do 
--             Wait(1)
--             HideHudComponentThisFrame(19);

--             if ( IsControlPressed(1, 173) ) then
--                 Crane:Left();
--             end

--             if ( IsControlJustReleased(1, 173) ) then
--                 releaseSound('left');
--             end

--             if ( IsControlPressed(1, 172) ) then
--                 Crane:Right();
--             end

--             if ( IsControlJustReleased(1, 172) ) then
--                 releaseSound('right');
--             end

--             if ( IsControlPressed(1, 32) ) then
--                 Crane:Up();
--             end

--             if ( IsControlJustReleased(1, 32) ) then
--                 releaseSound('up');
--             end

--             if ( IsControlPressed(1, 33) ) then
--                 Crane:Down();
--             end

--             if ( IsControlJustReleased(1, 33) ) then
--                 releaseSound('down');
--             end

--             if ( IsControlPressed(1, 34) ) then
--                 Crane:Forward();
--             end

--             if ( IsControlJustReleased(1, 34) ) then
--                 releaseSound('forward');
--             end

--             if ( IsControlPressed(1, 35) ) then
--                 Crane:Backwards();
--             end

--             if ( IsControlJustReleased(1, 35) ) then
--                 releaseSound('backwards');
--             end

--             if ( IsControlJustReleased(1, 191) ) then
--                 Crane:AttachOrDetach();
--             end

--             if ( IsControlJustReleased(1, 157) ) then
--                 Crane:Camera(0);
--             end

--             if ( IsControlJustReleased(1, 158) ) then
--                 Crane:Camera(1);
--             end

--             if ( IsControlJustReleased(1, 160) ) then
--                 Crane:Camera(2);
--             end

--             if ( IsControlJustReleased(1, 164) ) then
--                 Crane:Camera(3);
--             end
--         end
--     end)
-- end

-- RegisterCommand('usecrane', function()
--     local playerPed = PlayerPedId();
--     local xe,ye,ze = table.unpack(GetEntityCoords(playerPed))
--     local coordsPlayer = {xe,ye,ze}
--     local coordsCabin = Crane:GetPos('cabin');
--     print(coordsCabin[1], coordsCabin[2] - 2, coordsCabin[3])
--     local distance = GetDistanceBetweenCoords(coordsPlayer[1], coordsPlayer[2], coordsPlayer[3] + 1, coordsCabin[1], coordsCabin[2] - 2, coordsCabin[3], true);

--     if not usingCrane then
--         if ( distance < 2.2 ) then
--             scene = CreateSynchronizedScene(-0.1, -0.1, -0.35, 0, 0, 0, 2);
--             AttachSynchronizedSceneToEntity(scene, CranecreatedObjects['cabin'], -1);
--             TaskSynchronizedScene(PlayerPedId(), scene, 'missheistdockssetup1trevor_crane', 'get_in', 1000.0, -8.0, 0, 0, 1148846080, 0);
--             SetSynchronizedSceneHoldLastFrame(scene, true);
--             Wait(2000)
--             SetFollowPedCamViewMode(4);
--             useCrane();
--         else
--             print("Vous êtes trop loin")
--         end
--     else
--         usingCrane = false;
--         scene = CreateSynchronizedScene(-0.1, -0.1, -0.35, 0, 0, 0, 2);
--         SetSynchronizedSceneHoldLastFrame(scene, true);
--         SetSynchronizedSceneLooped(scene, false)
--         AttachSynchronizedSceneToEntity(scene, CranecreatedObjects['cabin'], -1);
--         TaskSynchronizedScene(PlayerPedId(), scene, 'missheistdockssetup1trevor_crane', 'get_out', 1000.0, -8.0, 0, 0, 1148846080, 0);
--         Wait(8000)
--         SetFollowPedCamViewMode(1); -- Reset to third person
--         SetEntityCollision(playerPed, true, true); -- Set ped collision since it seems to be gone without it(?)
--         ClearPedTasks(playerPed); -- Clear the ped task
--         DetachEntity(playerPed, false, true); -- Detach the player from the cabin
--     end
-- end)