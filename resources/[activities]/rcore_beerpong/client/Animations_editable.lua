function PlayWinnerPedAnimation()
    ClearPedTasks(PlayerPedId())
    local randomAnim = {
        {
            anim = "clown",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "clown2",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "argue",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "argue",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "dance5",
            clearInTime = 5000, -- 2000 = 2 seconds
        },
        {
            anim = "golfswing",
            clearInTime = 4000, -- 2000 = 2 seconds
        },
        {
            anim = "curtsy",
        },
    }

    CreateThread(function()
        DisableMarker = true
        local finalAnim = randomAnim[math.random(#randomAnim)]
        Animation.Play(finalAnim.anim)
        if finalAnim.clearInTime then
            Wait(finalAnim.clearInTime)
            Animation.ResetAll(PlayerPedId())
        end
        DisableMarker = false
    end)
end

function PlayScorePedAnimation()
    local randomAnim = {
        {
            anim = "twerk",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "bringiton",
        },
        {
            anim = "adjusttie",
        },
        {
            anim = "comeatmebro",
        },
        {
            anim = "damn",
        },
        {
            anim = "flip",
        },
        {
            anim = "flip2",
        },
        {
            anim = "slide3",
        },
    }
    CreateThread(function()
        DisableMarker = true
        local finalAnim = randomAnim[math.random(#randomAnim)]
        Animation.Play(finalAnim.anim)
        if finalAnim.clearInTime then
            Wait(finalAnim.clearInTime)
            Animation.ResetAll(PlayerPedId())
        end
        DisableMarker = false
    end)
end

function PlayPedMissAnimation()
    local randomAnim = {
        {
            anim = "chicken",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "bark",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "argue",
            clearInTime = 2000, -- 2000 = 2 seconds
        },
        {
            anim = "facepalm",
        },
        {
            anim = "facepalm2",
        },
        {
            anim = "facepalm3",
        },
    }

    CreateThread(function()
        DisableMarker = true
        local finalAnim = randomAnim[math.random(#randomAnim)]
        Animation.Play(finalAnim.anim)

        Wait(finalAnim.clearInTime or 2000)
        ClearPedTasks(PlayerPedId())
        Wait(200)
        Wait(33)
        GiveDrunkValue(20)

        local beer = CreateNetworkObject("prop_amb_beer_bottle", GetEntityCoords(PlayerPedId()))
        AttachBeerToHand(beer, PlayerPedId())
        Animation.Play("drink")

        Wait(1500)
        ClearPedTasks(PlayerPedId())
        Wait(450)
        DeleteEntity(beer)
        Animation.ResetAll(PlayerPedId())
        DisableMarker = false
    end)
end
