---@diagnostic disable: param-type-mismatch, missing-parameter, cast-local-type


local open = false
local posX = 0
local posY = 0
local posZ = 0
local rotX = 0
local rotY = 0
local rotZ = 0
local dict = ""
local anim = ""
local flag = 49
local prop = "prop_wall_light_04a"
local loadedItem = 0
local bone = "IK_R_Hand"
local mainMenu = RageUI.CreateMenu("test", "test prop")
local obj = nil

function StartPropTestMenu()
    if open then
        open = false
        return
    else
        open = true
        heading = 0
        loadedItem = 0
        posX = p:pos().x
        posY = p:pos().y
        posZ = p:pos().z
        rotX = 0
        rotY = 0
        rotZ = 0
        p:PlayAnim(dict, anim, flag)
        RageUI.Visible(mainMenu, true)

        Citizen.CreateThread(function()
            while open do
                
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button('Prop: '..tostring(prop), nil, {}, true, {
                        onSelected = function()
                            prop = KeyboardImput("Choisir le prop")
                        end,
                    })
                    -- RageUI.Button('Bone: '..tostring(bone), nil, {}, true, {
                    --     onSelected = function()
                    --         bone = KeyboardImput("Choisir le bone")
                    --     end,
                    -- })
                    RageUI.Button('Spawn: '..tostring(prop), nil, {}, true, {
                        onSelected = function()
                            obj = entity:CreateObject(prop, p:pos()) 
                            -- AttachEntityToEntity(obj:getEntityId(), p:ped(), GetEntityBoneIndexByName(p:ped(), bone), posX, posY, posZ, rotX, rotY, rotZ, false, false, false, false, 0.0, true)
                            -- loadedItem = obj
                        end,
                    })

                    RageUI.Button('posX: '..tostring(posX), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 38) then
                                posX = posX - 0.1
                                SetEntityCoords(obj:getEntityId(), posX, posY, posZ, false, false, false, false)
                            elseif IsControlPressed(0, 44) then
                                posX = posX + 0.1
                                SetEntityCoords(obj:getEntityId(), posX, posY, posZ, false, false, false, false)

                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la position X")
                            posX = tonumber(input)
                        end
                    })

                    RageUI.Button('posY: '..tostring(posY), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 38) then
                                posY = posY - 0.1
                                SetEntityCoords(obj:getEntityId(), posX, posY, posZ, false, false, false, false)
                                
                            elseif IsControlPressed(0, 44) then
                                posY = posY + 0.1
                                SetEntityCoords(obj:getEntityId(), posX, posY, posZ, false, false, false, false)

                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la position Y")
                            posY = tonumber(input)
                        end
                    })

                    RageUI.Button('posZ: '..tostring(posZ), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 38) then
                                posZ = posZ - 0.1
                                SetEntityCoords(obj:getEntityId(), posX, posY, posZ, false, false, false, false)
                                
                            elseif IsControlPressed(0, 44) then
                                posZ = posZ + 0.1
                                SetEntityCoords(obj:getEntityId(), posX, posY, posZ, false, false, false, false)
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la position Z")
                            posZ = tonumber(input)
                        end
                    })

                    RageUI.Button('Direction: '..tostring(heading), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 38) then
                                heading = heading - 0.5
                                SetEntityHeading(obj:getEntityId(), heading)
                            elseif IsControlPressed(0, 44) then
                                heading = heading + 0.5
                                SetEntityHeading(obj:getEntityId(), heading)
                            end
                        end
                    })

                    RageUI.Button("Retirer Props", nil, {}, true, {
                        onSelected = function()
                            if loadedItem ~= 0 then
                                obj:delete()
                                loadedItem = 0
                            end
                        end
                    })

                    

                    -- if loadedItem ~= 0 then
                    --     AttachEntityToEntity(loadedItem:getEntityId(), p:ped(), GetEntityBoneIndexByName(p:ped(), bone), posX, posY, posZ, rotX, rotY, rotZ, false, false, false, false, 0.0, true)
                    -- end

                end)

                Wait(1)
            end
        end)
    end
end

RegisterCommand("propdev", function()
    if p:getPermission() >= 4 then
        StartPropTestMenu()
    end
end)
