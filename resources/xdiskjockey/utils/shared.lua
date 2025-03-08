function _T(str, ...)
    local text = Locales[str]
    return string.format(text, ...)
end

function Debug(...)
    if Config.Debug then
        print(...)
    end
end

function GetEsxObject()
    local promise_ = promise:new()
    local obj
    xpcall(function()
        obj = exports['es_extended']['getSharedObject']()
        promise_:resolve(obj)
    end, function(error)
        TriggerEvent(Config.ESX or "esx:getSharedObject", function(module)
            obj = module
            promise_:resolve(obj)
        end)
    end)

    Citizen.Await(obj)
    return obj
end
