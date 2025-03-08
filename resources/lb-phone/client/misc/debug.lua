RegisterCommand("phonedebug", function()
    Config.Debug = not Config.Debug
    SendReactMessage("phone:toggleDebug", Config.Debug)
    print("DEBUG:", Config.Debug)
end, false)

local function registerDebugCommand(command, fn)
    RegisterCommand(command, function(src, args)
        if Config.Debug then
            fn(src, args)
        end
    end, false)
end

registerDebugCommand("center", function()
    SetCursorLocation(0.5, 0.5)
end)

registerDebugCommand("getcache", function()
    SendReactMessage("phone:printCache")
end)

registerDebugCommand("getstacks", function()
    SendReactMessage("phone:printStacks")
end)

registerDebugCommand("testnotification", function(src, args)
    exports["lb-phone"]:SendNotification({
        title = "test",
    })

    -- TriggerEvent("phone:sendNotification", {
    --     app = args[1] or "Wallet",
    --     title = "Test Notification",
    --     -- content = "This is a test notification.",
    -- })
end)

registerDebugCommand("testamberalert", function()
    TriggerEvent("phone:sendNotification", {
        title = "Emergency Alert",
        content = "This is a test emergency alert.",
        icon = "./assets/img/icons/warning.png"
    })
end)

registerDebugCommand("testamberalert2", function()
    TriggerEvent("phone:sendNotification", {
        title = "Emergency Alert",
        content = "This is a test emergency alert. 123",
        icon = "./assets/img/icons/danger.png"
    })
end)

registerDebugCommand("setbattery", function(source, args)
    battery = tonumber(args[1]) or 50
    exports["lb-phone"]:SetBattery(battery)
end)

registerDebugCommand("togglecharging", function(source, args)
    exports["lb-phone"]:ToggleCharging(args[1] == "true" and true or false)
end)

registerDebugCommand("addcontact", function(source, args)
    exports["lb-phone"]:AddContact({
        firstname = "John",
        lastname =  "Doe",
        number = args[1] or "1234567890",
        avatar = "https://i.imgur.com/2X1uYkU.png"
    })
end)

registerDebugCommand("flashlight", function()
    local flashlightEnabled = exports["lb-phone"]:GetFlashlight()
    print("Flashlight enabled:", flashlightEnabled)

    local shouldEnable = not flashlightEnabled
    exports["lb-phone"]:ToggleFlashlight(shouldEnable)
    print((shouldEnable and "Enabled" or "Disabled") .. " flashlight")
end)

registerDebugCommand("call", function(source, args)
    exports["lb-phone"]:CreateCall({
        number = args[1] or "1234567890",
        videoCall = args[2] == "1" and true or false
    })
end)

registerDebugCommand("callcompany", function(source, args)
    exports["lb-phone"]:CreateCall({
        company = args[1] or "police"
    })
end)

registerDebugCommand("testpopup", function(source, args)
    exports["lb-phone"]:SetPopUp({
        title = "Test",
        description = "This is a test popup.",
        input = {
            type = "text",
            placeholder = "Type something...",
            minCharacters = 5,
            maxCharacters = 100,
            onChange = function(value)
                print("Input changed:", value)
            end,
        },
        buttons = {
            {
                title = "OK",
                cb = function()
                    print("Pressed button")
                end
            },
        }
    })
end)

if Config.QBMailEvent then
    registerDebugCommand("qbmail", function()
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Very Cool",
            subject = "Delivery Location",
            message = "whatever",
            button = {
                enabled = true,
                buttonEvent = "phone:debug:mail",
                buttonData = "waitingDelivery"
            }
        })
    end)
end

RegisterNetEvent("phone:debug:mail", function(id, data)
    print(id, json.encode(data))
end)

-- local function drawText(text)
--     AddTextEntry(GetCurrentResourceName(), text)
--     BeginTextCommandDisplayText(GetCurrentResourceName())
--     SetTextScale(0.35, 0.35)
--     SetTextCentre(true)
--     SetTextFont(4)
--     SetTextDropShadow()
--     EndTextCommandDisplayText(0.5, 0.5)
-- end

-- CreateThread(function()
--     while true do
--         Wait(0)
--         drawText(("Pressing LMB: %s\nPressing PTT: %s"):format(tostring(IsControlPressed(0, 24)), tostring(MumbleIsPlayerTalking(PlayerId()))))
--     end
-- end)

-- CreateThread(function()
--     -- SetNuiFocus(false, false)
--     -- SetNuiFocusKeepInput(false)

--     Wait(2000)

--     -- SetNuiFocus(true, true)
--     -- SetNuiFocusKeepInput(true)

--     local timer = GetGameTimer() + 1000
--     while timer > GetGameTimer() do
--         Wait(0)

--         DisableControlAction(0, 249, true)
--     end
-- end)

if Config.Debug then
    RegisterCommand("phonescale", function (_, args)
        local rawScale = tonumber(args[1])

        if not rawScale or rawScale < 50 or rawScale > 120 then
            print("Invalid scale. Must be between 50 and 120.")
            return
        end

        local scale = rawScale / 100

        SendReactMessage("setScale", scale)
    end, false)
end