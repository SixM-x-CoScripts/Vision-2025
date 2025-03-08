RegisterCommand('trailer', function(source, args)
    TriggerClientEvent('videoPlayer:playVideo', source, "https://www.youtube.com/embed/d_0X1Qdj-aE?autoplay=1&controls=0&modestbranding=1")
end, false)

RegisterCommand('skip', function(source, args)
    TriggerClientEvent('videoPlayer:closeVideo', source)
end, false)