RegisterNUICallback('context__callback', function(data, cb)
    _G[data.action](data.args[1])
end)
