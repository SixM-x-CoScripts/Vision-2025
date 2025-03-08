Modules.Loader = {}
Modules.Loader.NewPlayer = false
Modules.Loader.ThingsToLoad = 0
Modules.Loader.LoadedCount = 0
Modules.Loader.CurrentLoading = ""
Modules.Loader.dictToLoadFirst = {
    {"identity"},
}
Modules.Loader.dictToLoad = { -- Maybe used in the futur
    {"identity"},
    {"auto_ecole"},
    {"coma"},
    {"vocal"},
    {"interact"},
}
Modules.Loader.fontToLoad = {
    {},
}

Modules.Loader.ModelsToLoad = {
    {}
}

function Modules.Loader.Run()
    -- Modules.Sound.PlaySound(math.random(1,999999), "musics/loading", true, 0.07)
    Modules.Loader.ThingsToLoad = 0
    Modules.Loader.LoadedCount = 0

    for k, v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k, v in pairs(Modules.Loader.dictToLoad) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k, v in pairs(Modules.Loader.fontToLoad) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k, v in pairs(Modules.Loader.ModelsToLoad) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end
   
    for k, v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.UI.LoadStreamDict(v[1])
        Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    end

    -- Modules.UI.SetPageActive("loading_screen")
    -- if Config.devmod then
    --     Modules.UI.SetFullscreenLoaderActive(false)
    -- end

    -- for k, v in pairs(Modules.Loader.fontToLoad) do
    --     Modules.Loader.CurrentLoading = v[2]
    --     Modules.UI.LoadFont(v)
    --     Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    -- end

    for k, v in pairs(Modules.Loader.dictToLoad) do
        Modules.Loader.CurrentLoading = v[1]
        Modules.UI.LoadStreamDict(v[1])
        Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    end
    -- for k,v in pairs(Modules.Loader.ModelsToLoad) do
    --     Modules.Loader.CurrentLoading = v[1]
    --     Modules.World.LoadModel(v[1])
    --     Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    -- end


    -- while true do

    --     Wait(1)
    -- end
    -- Modules.Sound.StopAllNormalSounds()
    -- Modules.UI.SetFullscreenLoaderActive(true)
    -- DoScreenFadeOut(500)
    -- Modules.Utils.RealWait(1000)
    -- Modules.UI.SetPageInactive("loading_screen")

end
