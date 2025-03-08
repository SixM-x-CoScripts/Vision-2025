--[[DataTV = {}
local apiURL = 'https://www.googleapis.com/youtube/v3/videos?id=%s&part=contentDetails&key=%s'

local GenerateId = function(length, usecapital, usenumbers)
    local result = ''

    for i = 1, length do
        local randomised = string.char(math.random(97, 122))
        if usecapital then
            if math.random(1, 2) == 1 then
                randomised = randomised:upper()
            end
        end
        if usenumbers then
            if math.random(1, 2) == 1 then
                randomised = tostring(math.random(0, 9))
            end
        end
        result = result .. randomised
    end

    return result
end

local time

RegisterServerEvent('core:tv:add')
AddEventHandler('core:tv:add', function(url, object, coords, scale, offset, volume)
    local src = source
    if volume == nil then volume = 1.0 end
    local id = GenerateId(20, true, true)
    for k, v in pairs(DataTV) do
        if v['Object'] == object and v['Coords'] == coords then -- if it's the same tv, just update the video etc
            id = k -- so we update the same object (if it's the same tv)
        end
    end

    local time = os.time()

    DataTV[id] = {
        ['URL'] = url,
        ['Object'] = object,
        ['Coords'] = coords,
        ['Scale'] = scale,
        ['Offset'] = offset,
        ['Time'] = time,
        ['Volume'] = volume,
    }
    --local checking = false
    --checking = true
    --PerformHttpRequest(apiURL:format(url, 'AIzaSyAtrOhTvRlCp0s29px_K7YuZ_fQjCuLnr0'), function(err, text, headers)
    --    if text then
    --        local decoded = json.decode(text)
    --        if decoded then
    --            if decoded['items'] then
    --                if decoded['items'][1] then
    --                    if decoded['items'][1]['contentDetails'] then
    --                        if decoded['items'][1]['contentDetails']['duration'] then
    --                            local duration = decoded['items'][1]['contentDetails']['duration']
    --                            local found = string.find(duration, 'M')
    --                            local length = 0
    --                            if not found then
    --                                length = length + tonumber(duration:match("PT(.-)S"))
    --                            else
    --                                length = length + (tonumber(duration:match("PT(.-)M")) * 60)
    --                                length = length + tonumber(duration:match("M(.-)S"))
    --                            end
    --                            DataTV[id]['Duration'] = length
    --                            checking = false
    --                        end
    --                    end
    --                end
    --            end
    --        end
    --    else
    --        checking = false
    --    end
    --end, 'GET', '')

    while checking do Wait(0) end

    local tosend = {}
    for k, v in pairs(DataTV) do
        tosend[k] = {
            ['URL'] = v['URL'],
            ['Object'] = v['Object'],
            ['Coords'] = v['Coords'],
            ['Scale'] = v['Scale'],
            ['Offset'] = v['Offset'],
            ['Time'] = v['Time'],
            ['Volume'] = v['Volume'],
        }
        if v['Duration'] then
            tosend[k]['Duration'] = v['Duration']
        end
        tosend[k]['Time'] = (os.time() - tosend[k]['Time'])
    end
    TriggerClientEvent('core:tv:update', -1, tosend, GetPlayerRoutingBucket(src), id, offset)
end)

RegisterServerEvent('core:tv:fetch')
AddEventHandler('core:tv:fetch', function()
    local tosend = {}

    for k, v in pairs(DataTV) do
        tosend[k] = { -- = v will just fuck this shit up im tired ok? (04.00 wtf am i doing up this late)
            ['URL'] = v['URL'],
            ['Object'] = v['Object'],
            ['Coords'] = v['Coords'],
            ['Scale'] = v['Scale'],
            ['Offset'] = v['Offset'],
            ['Time'] = v['Time'],
            ['Volume'] = v['Volume'],
        }
        if v['Duration'] then
            tosend[k]['Duration'] = v['Duration']
        end
        tosend[k]['Time'] = (os.time() - tosend[k]['Time'])
    end

    local src = source
    TriggerClientEvent('core:tv:update', src, tosend)
end)

cooldown = {}

CreateThread(function()
    while true do 
        Wait(1000)
        cooldown = {}
    end
end)

RegisterServerEvent('core:tv:setvolume')
AddEventHandler('core:tv:setvolume', function(id, volume)
    local block = false
    for k,v in pairs(cooldown) do 
        if v and v == id then 
            block = true
        end
    end
    if not block then
        table.insert(cooldown, id)
        if volume >= 0 and volume <= 10 then
            if DataTV[id] then
                DataTV[id]['Volume'] = volume
                TriggerClientEvent('core:tv:updatevolume', -1, id, volume)
            end
        end
    end
end)

RegisterServerEvent('core:tv:destroy')
AddEventHandler('core:tv:destroy', function(id)
    if DataTV[id] then
        DataTV[id] = nil
        TriggerClientEvent('core:tv:delete', -1, id)
    end
end)]]