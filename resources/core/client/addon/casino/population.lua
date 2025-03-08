local peds = {
    {
        ped = "a_f_y_scdressy_01",
        pos = vector3(1087.8389892578, 221.70310974121, -50.200420379639),
        dict = "anim@move_f@waitress",
        anim = "idle",
        AnimationOptions = {
            Prop = "vw_prop_vw_tray_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0,
                0.0,
                0.0100,
                0.0,
                0.0,
                0.0
            },
            SecondProp = 'prop_champ_cool',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.0,
                0.0,
                0.010,
                0.0,
                0.0,
                0.0
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    {
        ped = "a_f_y_beach_01",
        pos = vector3(1123.6834716797, 250.72584533691, -51.040599822998),
        dict = "anim@move_f@waitress",
        anim = "idle",
        AnimationOptions = {
            Prop = "vw_prop_vw_tray_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0,
                0.0,
                0.0100,
                0.0,
                0.0,
                0.0
            },
            SecondProp = 'prop_champ_cool',
            SecondPropBone = 28422,
            SecondPropPlacement = {
                0.0,
                0.0,
                0.010,
                0.0,
                0.0,
                0.0
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    {
        ped = "a_f_y_vinewood_03",
        pos = vector3(1113.166015625, 203.31033325195, -50.440135955811),
    },
    {
        ped = "a_m_y_business_02",
        pos = vector3(1147.2130126953, 247.63891601562, -52.035724639893),
    },
    {
        ped = "a_m_y_busicas_01",
        pos = vector3(1134.6315917969, 253.00971984863, -52.043495178223),
    },
    {
        ped = "a_m_y_busicas_01",
        pos = vector3(1134.6315917969, 253.00971984863, -52.043495178223),
    },
    {
        ped = "a_m_y_busicas_01",
        pos = vector3(1117.4888916016, 204.05044555664, -50.440132141113),
        h = 61.54,
        dict = "timetable@ron@ig_3_couch",
        anim = "base",
        fix = true
    },
    {
        ped = "a_m_y_ktown_02",
        pos = vector3(1103.3421630859, 195.62004089355, -50.440078735352),
        h = 22.54,
        dict = "clothingshirt",
        anim = "try_shirt_neutral_b",
        fix = true
    },
}

local speds = {}
local sprops = {}

function AttachProp(pedid, prop1, bone, off1, off2, off3, rot1, rot2, rot3, textureVariation)
    local Player = pedid or PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not IsModelValid(prop1) then
        return false
    end

    if not HasModelLoaded(prop1) then
        if not HasModelLoaded(joaat(prop1)) then
            RequestModel(joaat(prop1))
            local timeout = 2000
            while not HasModelLoaded(joaat(prop1)) and timeout > 0 do
                Wait(5)
                timeout = timeout - 5
            end
            if timeout == 0 then
                return
            end
        end
    end

    prop = CreateObject(joaat(prop1), x, y, z + 0.2)
    if textureVariation ~= nil then
        SetObjectTextureVariation(prop, textureVariation)
    end
    table.insert(sprops,prop)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true,
        false, true, 1, true)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function CreatePedsCasino()
    for k,v in pairs(peds) do 
        RequestModel(GetHashKey(v.ped)) while not HasModelLoaded(GetHashKey(v.ped)) do Wait(1) end
        speds[k] = CreatePed(4, GetHashKey(v.ped), v.pos, 0.0)
        if v.AnimationOptions then 
            local x, y, z, xR, yR, zR = table.unpack(v.AnimationOptions.PropPlacement)
            local propEntity = CreateObject(GetHashKey(v.AnimationOptions.Prop), 0, 0, 0)
            AttachProp(speds[k], v.AnimationOptions.Prop, v.AnimationOptions.PropBone, x, y, z, xR, yR, zR, v.AnimationOptions.PropTextureVariation)
            table.insert(sprops, propEntity)
            SetEntityAsNoLongerNeeded(propEntity)
        end
        if v.AnimationOptions and v.AnimationOptions.SecondProp then
            local x, y, z, xR, yR, zR = table.unpack(v.AnimationOptions.SecondPropPlacement)
            local propEntity = CreateObject(GetHashKey(v.AnimationOptions.SecondProp), 0, 0, 0)
            AttachProp(speds[k], v.AnimationOptions.SecondProp, v.AnimationOptions.SecondPropBone, x, y, z, xR, yR, zR, v.AnimationOptions.SecondPropTextureVariation)
            table.insert(sprops, propEntity)
            SetEntityAsNoLongerNeeded(propEntity)
        end
        SetBlockingOfNonTemporaryEvents(speds[k], true)
        TaskWanderStandard(speds[k], 10.0, 10.0)
        if v.h then 
            SetEntityHeading(speds[k], v.h)
        end
        if v.dict then
            CreateThread(function()
                while true do 
                    if speds[k] and DoesEntityExist(speds[k]) then
                        if not IsEntityPlayingAnim(speds[k], v.dict, v.anim, 3) then
                            RequestAnimDict(v.dict)
                            while not HasAnimDictLoaded(v.dict) do Wait(1) end
                            TaskPlayAnim(speds[k], v.dict, v.anim, 8.0, 8.0, -1, v.fix and 0 or 51, 0, false, false, false)
                        end
                    else
                        break
                    end
                    Wait(1000)
                end
            end)
        end
    end
end

function DeletePedsCasino()
    for k,v in pairs(speds) do 
        DeleteEntity(v)
    end
    for k,v in pairs(sprops) do 
        DeleteEntity(v)
    end
end