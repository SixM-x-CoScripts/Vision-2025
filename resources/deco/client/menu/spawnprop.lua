--local Input = exports.core:Input()

function KeyboardImput(text, value)
    if not value then
        value = ""
    end
	local amount = nil
	AddTextEntry("CUSTOM_AMOUNT", text)
	DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', value, '', '', '', 255)
	GlobalBlockWeaponsKeys = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(1)
	end
	GlobalBlockWeaponsKeys = false
	if UpdateOnscreenKeyboard() ~= 2 then
		amount = GetOnscreenKeyboardResult()
		Citizen.Wait(1)
	else
		Citizen.Wait(1)
	end
	return amount
end

RotationToDirection = function (rotation)
    local adjustedRotation = vec3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    local direction = vec3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    return direction
end

PropsMenu.SpawnProp = {};
PropsMenu.SpawnProp.UI = RageUI.CreateSubMenu(PropsMenu.Main.UI, "Spawn un prop", "Props Menu");
PropsMenu.SpawnProp.Items = {
    {
        Name = "Spawn un prop (nom)",
        Type = "Button",
        Enabled = true,
        SubMenuLink = nil,
        Callback = {
            onSelected = function()
                -- Get the model name
                local modelName = KeyboardImput("Nom du prop")
                local model = GetHashKey(modelName)
                local i = 0
    
                if not IsModelInCdimage(model) then
                    print("Model not found")
                    return
                end
    
                -- Request the model
                RequestModel(model)
                while not HasModelLoaded(model) do
                    i = i + 1
                    Wait(50)
                    if i > 10 then
                        print("Model not loaded")
                        break
                    end
                end
    
                local distance = 5 -- Distance to spawn object from the camera
                local cameraRotation = GetFinalRenderedCamRot()
                local cameraCoord = GetFinalRenderedCamCoord()
                local direction = RotationToDirection(cameraRotation)
                local coords =  vec3(cameraCoord.x + direction.x * distance, cameraCoord.y + direction.y * distance, cameraCoord.z + direction.z * distance)
                local obj = CreateObject(model, coords.x, coords.y, coords.z)
    
                Wait(50)
                if not DoesEntityExist(obj) then
                    print("Object not created")
                    return
                end
    
                FreezeEntityPosition(obj, true)
    
                table.insert(props_list, {
                    handle = obj,
                    name = modelName,
                })
                Functions.Gizmo.Use(obj, modelName)
            end
        },
        Style = { RightLabel = "" }
    },
    --{
    --    Name = "Voir la liste des props",
    --    Type = "Button",
    --    Enabled = true,
    --    SubMenuLink = nil,
    --    Callback = {
    --        onSelected = function()
    --            NUI.OpenBrowser("https://forge.plebmasters.de/objects")
    --        end
    --    },
    --    Style = { RightLabel = "" }
    --}
}

table.insert(PropsMenu.Main.Items, {
    Name = "Ajouter un prop",
    Type = "Button",
    Enabled = true,
    SubMenuLink = PropsMenu.SpawnProp.UI,
    Callback = {},
    Style = { RightLabel = "→" }
})