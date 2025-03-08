local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function createKeys(plate, model, premium)
    if plate == nil or model == nil then return end
    TriggerServerEvent("core:addItemToInventoryStaffButNoStaff", token, GetPlayerServerId(PlayerId()), "keys", 1, {plate=plate, premium = premium, renamed=model, canRename=false})
end

function removeKeys(plate, model)
    if plate == nil or model == nil then return end
    TriggerServerEvent("core:RemoveItemToInventory", token, "keys", 1, {plate=plate, renamed=model, canRename=false})
end

RegisterNetEvent("core:createKeys")
AddEventHandler("core:createKeys", function(plate, model, premium)
    createKeys(plate, GetLabelText(GetDisplayNameFromVehicleModel(model)), premium)
end)
