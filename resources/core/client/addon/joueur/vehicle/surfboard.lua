RegisterNetEvent("core:UseSurfBoard")
AddEventHandler("core:UseSurfBoard", function()
    RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
            Wait(0)
        end
    p:PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Monte la planche de surf",
            time = 3,
        }
    }))
    Modules.UI.RealWait(3000)
    ExecuteCommand("e c")
    local pos = vector4(p:pos().x, p:pos().y, p:pos().z, GetEntityHeading(p:ped()))
    local veh = vehicle.create("surfboard", pos, {})
    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
end)