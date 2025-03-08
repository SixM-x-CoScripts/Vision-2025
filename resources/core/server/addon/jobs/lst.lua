RegisterNetEvent('giveMoneyLst', function()
    local source = source
    local ply = GetPlayer(source)
    if ply:getJob() == 'lst' then
        AddMoneyToSociety(300, 'lst')
    else
        SunWiseKick(source, "Tried exec giveMoneyLst")
    end
end)

RegisterNetEvent('lstDiscordLog', function(ligne, startTime, stopTime)

    local playeridentity = GetPlayer(source):getFirstname() .. " " .. GetPlayer(source):getLastname()
    local playerdiscord = GetDiscord(source)


    local discord_webhook = {
        url = 'https://discord.com/api/webhooks/1115333984344350892/uQ5hXsRRjZ1jjNVmcYjntpIoBgj_REQTBAfbfWEn3202IJyMB-s9a5brLPbx3hjCVYnZ'
    }

    local embeds = {
          {
            ["title"] = 'LST Log',
            ["description"] = playeridentity..' à fini la ligne '..ligne..'.\nDébut: '..startTime..'\nFin: '..stopTime,
            ['color'] = 16755740,
            ["footer"] = {
                ["text"] = os.date("%Y/%m/%d %X"),
                ["icon_url"] = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.webp",

            },
          }
        }

    PerformHttpRequest(discord_webhook.url, 
    function(err, text, header) end, 
    'POST', 
    json.encode({username = 'LST LOG', embeds = embeds, avatar_url = 'https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.webp'}),
   {['Content-Type'] = 'application/json'})

end)