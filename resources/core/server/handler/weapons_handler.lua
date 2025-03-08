RegisterNetEvent("core:GetWeaponFromArmory") --useless
AddEventHandler("core:GetWeaponFromArmory", function(token, name, ammo)
    if CheckPlayerToken(source, token) then
        GetPlayer(source):AddWeaponIfPossible(name, ammo)
        MarkPlayerDataAsNonSaved(source)
        --RefreshPlayerData(source)
    else
        -- TODO ac detection
    end
end)

RegisterNetEvent("core:UpdateWeaponAmmo")
AddEventHandler("core:UpdateWeaponAmmo", function(token, name, ammo)
    if CheckPlayerToken(source, token) then
        GetPlayer(source):SetWeaponAmmo(name, ammo)
    else
        -- TODO ac detection
    end
end)


RegisterNetEvent("core:UpdateWeaponComponents")
AddEventHandler("core:UpdateWeaponComponents", function(token, name, components, option)
    if CheckPlayerToken(source, token) then
        GetPlayer(source):SetWeaponComponents(name, components, option)
    else
        -- TODO ac detection
    end
end)

--RegisterNetEvent("core:GiveWeaponToPlayer")--useless
--AddEventHandler("core:GiveWeaponToPlayer", function(token, name, target)
--    if CheckPlayerToken(source, token) then
--        GetPlayer(source):GiveWeaponIfPossible(name, source, target)
--        MarkPlayerDataAsNonSaved(source)
--        MarkPlayerDataAsNonSaved(target)
--        --RefreshPlayerData(source)
--        --RefreshPlayerData(target)
--    else
--        -- TODO ac detection
--    end
--end)

RegisterNetEvent("core:shootingcases", function(coords, weapon_category, weaponid)
    if weapon_category == 416676503 or weapon_category == -957766203 or weapon_category == 1159398588 then
        weapon_category = '9mm'
    elseif weapon_category == 860033945 then
        weapon_category = '12 Gauge'
    elseif weapon_category == 970310034 then
        weapon_category = '5.56x45mm Rifle'
    elseif weapon_category == 3082541095 or weapon_category == -1212426201 then
        weapon_category = '7.62x51mm Sniper'
    elseif weapon_category == 2725924767 then
        weapon_category = '12.7x99mm (.50 Cal)'
    elseif weapon_category == -1569042529 then
        weapon_category = 'Roquette'
    end
    local time = os.date('%H:%M:%S', os.time())
    TriggerClientEvents("core:shootingcases", GetAllJobsIds({ "lspd", "lssd", "usss" }),
        { pos = coords, time = time, typeAmmo = weapon_category, id = weaponid })
end)

local Charset = {}
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
local function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(os.time())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

local function GenerateWeaponID()
	math.randomseed(os.time())
	return tostring(string.upper(GetRandomLetter(2)) .. math.random(1111, 4444))
end

RegisterNetEvent("core:checkMeta", function()
    local src = source 
    local player = GetPlayer(src)
    if not player then return end
    for k,v in pairs(player:getInventaire()) do 
        if v.name and string.find(v.name, "weapon_") then 
            local hasMeta = v.metadatas and v.metadatas.id or nil
            if not hasMeta then 
                if v.metadatas then 
                    v.metadatas.id = GenerateWeaponID()
                else
                    v.metadatas = {id = GenerateWeaponID()}
                end
            end
        end
    end
end)

