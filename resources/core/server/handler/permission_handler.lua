local function GetPlayerPermission(source)
    return GetPlayer(source) ~= nil and GetPlayer(source):getPermission() or 0
end

local function GetPlayerSubscription(source)
    return GetPlayer(source) ~= nil and GetPlayer(source):getSubscription() or 0
end

function HasPermission(source, permToCheck)
    if source == 0 then return true end
    
	return GetPlayer(source):getPermission() >= permToCheck
end

CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(100)
    end
    RegisterServerCallback("core:getPermAdmin", function(source, target)
        -- return GetPlayerPermission(target)
        local perm = target ~= nil and GetPlayerPermission(target) or 0
        local sub = target ~= nil and GetPlayerSubscription(target) or 0
        local fullname = target ~= nil and GetPlayer(target):getFullName() or nil

        return {perm = perm, sub = sub, fullname = fullname}
    end)
end)