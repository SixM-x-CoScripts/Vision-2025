local hasgear = false
local TankObject
local MaskObject
local function GearAnim()
    Utils.LoadAnimDict("clothingshirt")    	
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

RegisterNetEvent("core:useRecycleur", function()
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    if not hasgear then
        GearAnim()
        SetEnableScuba(PlayerPedId(), true)
        SetEnableScubaGearLight(PlayerPedId(), true)
        SetPedMaxTimeUnderwater(PlayerPedId(), 2000.00)        
        local maskModel = GetHashKey("p_d_scuba_mask_s")
        local tankModel = GetHashKey("p_s_scuba_tank_s")
        RequestModel(tankModel)
        while not HasModelLoaded(tankModel) do
            Wait(1)
        end
        TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone1 = GetPedBoneIndex(PlayerPedId(), 24818)
        AttachEntityToEntity(TankObject, PlayerPedId(), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
        RequestModel(maskModel)
        while not HasModelLoaded(maskModel) do
            Wait(1)
        end        
        MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone2 = GetPedBoneIndex(PlayerPedId(), 12844)
        AttachEntityToEntity(MaskObject, PlayerPedId(), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
        SetEnableScuba(PlayerPedId(), true)
        SetPedMaxTimeUnderwater(PlayerPedId(), 2000.00)
        hasgear = true
        Wait(2000)
        ClearPedTasks(PlayerPedId())
    else
        SetModelAsNoLongerNeeded(GetHashKey("p_d_scuba_mask_s"))
        SetModelAsNoLongerNeeded(GetHashKey("p_s_scuba_tank_s"))
        SetEnableScuba(PlayerPedId(), false)
        SetEnableScubaGearLight(PlayerPedId(), false)
        SetPedMaxTimeUnderwater(PlayerPedId(), 1.00)
        DeleteEntity(TankObject)
        DeleteEntity(MaskObject)
        hasgear = false
    end
end)