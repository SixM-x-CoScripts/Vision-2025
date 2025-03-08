---Hide hud components, used in the camera app
function HideHudComponents()
    HideHudAndRadarThisFrame()
    HideHelpTextThisFrame()
end

---@param entity number
---@return boolean success
function TakeControlOfEntity(entity)
    if NetworkHasControlOfEntity(entity) then
        return true
    end

    local timer = GetGameTimer() + 5000

    while not NetworkHasControlOfEntity(entity) and timer > GetGameTimer() do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end

    return NetworkHasControlOfEntity(entity)
end

---Request a model and wait for it to load
---@param model number|string
---@return number model
function LoadModel(model)
    model = type(model) == "number" and model or joaat(model)

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(0)
    end

    return model
end

---Wait for network id & entity to exist
---@param netId number
---@return number? entity The entity, or nil if it doesn't exist
function WaitForNetworkId(netId)
    local timer = GetGameTimer() + 5000

    while not NetworkDoesNetworkIdExist(netId) do
        Wait(0)

        if GetGameTimer() > timer then
            return
        end
    end

    timer = GetGameTimer() + 5000

    while not DoesEntityExist(NetworkGetEntityFromNetworkId(netId)) do
        Wait(0)

        if GetGameTimer() > timer then
            return
        end
    end

    return NetworkGetEntityFromNetworkId(netId)
end
