local isServer = IsDuplicityVersion();
local currentRequestId = 0;
local handlers = {};
---@type table<number, PendingRPC>
local pendings = {};

---@param eventName string
---@param source number
---@vararg any
local function triggerNet(eventName, source, ...)
    if (isServer) then
        TriggerClientEvent(eventName, source, ...);
    else
        TriggerServerEvent(eventName, ...);
    end
end

---@param v any
---@return boolean
local function isFunction(v)
    return type(v) == "function"
        or type(v) == "table" and rawget(v, "__cfx_functionReference");
end

---@param eventName string
---@param handlerFn fun(...: any): void
local function createProxyHandler(eventName, handlerFn)
    return function(source, ...)
		if (isServer) then
			return handlerFn(source, ...);
		end
        return handlerFn(...);
    end;
end

---@param requestId number
local function createTimeout(requestId)
    SetTimeout(15000, function()
        if (pendings[requestId]) then
            print(("Event '%s' was not resolved in time."):format(pendings[requestId].eventName));
            pendings[requestId].promise:resolve(nil);
            pendings[requestId] = nil;
        end
    end);
end

---@param eventName string
---@param handlerFn fun(src: number, ...: any): void
local function register(eventName, handlerFn)
    assert(type(eventName) == "string", ("Invalid argument at index #1, expected string, got '%s'"):format(type(eventName)));
    assert(isFunction(handlerFn), ("Invalid argument at index #2, expected function, got '%s'"):format(type(handlerFn)));
    assert(not handlers[eventName], ("Attempt to register a callback that already exists: '%s'"):format(eventName));
    handlers[eventName] = createProxyHandler(eventName, handlerFn);
end

---@param eventName string
---@param source number
---@vararg any
local function trigger(eventName, source, ...)
    assert(type(eventName) == "string", ("Invalid argument at index #1, expected string, got '%s'"):format(type(eventName)));
    assert((isServer and type(source) == "number") or true, ("Invalid argument at index #2, expected number, got '%s'"):format(type(source)));
    if (currentRequestId >= 65535) then
        currentRequestId = 0;
    end
    currentRequestId = currentRequestId + 1;
    local p = promise.new();
    pendings[currentRequestId] = {
        source = source,
        promise = p,
		eventName = eventName,
    };
    createTimeout(currentRequestId);
    triggerNet("vision:callback:request", source, eventName, currentRequestId, ...);
	return Citizen.Await(p);
end

RegisterNetEvent('vision:callback:request', function(eventName, requestId, ...)
    local src = source;
    if (handlers[eventName]) then
        local result = handlers[eventName](src, ...);
        triggerNet('vision:callback:response', src, requestId, result);
        return;
    end
    print(("Attempt to trigger an unregistered event: '%s'"):format(eventName));
end);

RegisterNetEvent('vision:callback:response', function(requestId, result)
    local src = source;
    if (type(pendings[requestId]) == "table") then
        if (pendings[requestId].promise) then
			if (isServer and pendings[requestId].source ~= src) then
				print('Attempt to resolve request from invalid source: ', json.encode({
					source = src,
					expected = pendings[requestId].source,
					requestId = requestId,
					eventName = pendings[requestId].eventName,
				}));
				return;
			end
            pendings[requestId].promise:resolve(result);
            pendings[requestId] = nil;
        end
    end
end);

if (isServer) then

	---@param eventName string
	---@param handlerFn fun(src: number, ...: any): void
	function RegisterServerCallback(eventName, handlerFn)
		return register(eventName, handlerFn);
	end

	---@param source number
	---@param eventName string
	---@vararg any
	---@return any
	function TriggerClientCallback(source, eventName, ...)
		return trigger(eventName, source, ...);
	end

else

	---@param eventName string
	---@param handlerFn fun(...: any): void
	---@return void
	function RegisterClientCallback(eventName, handlerFn)
		return register(eventName, handlerFn);
	end

	---@param eventName string
	---@vararg any
	function TriggerServerCallback(eventName, ...)
		return trigger(eventName, nil, ...);
	end

    exports("TriggerServerCallback", function(eventName, ...)
        return TriggerServerCallback(eventName, ...)
    end)

end
