local VUI = exports["VUI"]
local token = nil
local inVeh = false

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local function Keybind(key, command, name, callback)
    RegisterCommand("+emotes_" .. command, callback, false)
    RegisterKeyMapping("+emotes_" .. command, name, "keyboard", key)
end

local menu = VUI:CreateMenu("Emotes", "animations", true)
local emotes = VUI:CreateSubMenu(menu, "Animations", "animations", true)
local walk = VUI:CreateSubMenu(menu, "Démarches", "animations", true)
local aim = VUI:CreateSubMenu(menu, "Style de visée", "animations", true)
local mood = VUI:CreateSubMenu(menu, "Humeurs", "animations", true)
local favorite = VUI:CreateSubMenu(menu, "Favoris", "animations", true)

local activites = VUI:CreateSubMenu(emotes, "Activités", "animations", true)
local dances = VUI:CreateSubMenu(emotes, "Danses", "animations", true)
local gestures = VUI:CreateSubMenu(emotes, "Gestes", "animations", true)
local props = VUI:CreateSubMenu(emotes, "Objets", "animations", true)
local positions = VUI:CreateSubMenu(emotes, "Position", "animations", true)
local sante = VUI:CreateSubMenu(emotes, "Santé", "animations", true)
local sports = VUI:CreateSubMenu(emotes, "Sports", "animations", true)
local gang = VUI:CreateSubMenu(emotes, "Gangs", "animations", true)
local animals = VUI:CreateSubMenu(emotes, "Animaux", "animations", true)
local shared = VUI:CreateSubMenu(emotes, "Partagées", "animations", true)
local other = VUI:CreateSubMenu(emotes, "Autres", "animations", true)
local research = VUI:CreateSubMenu(emotes, "Rechercher", "animations", true)

--[[ local function PreviewEmotesCallback(_menu, list)
    _menu.OnIndexChange(function(index, item)
        DestroyCloneAttachedProps()
        for _, emote in pairsByKeys(list) do
            if emote[3] == item.props.title then
                print("preview emote" .. json.encode(emote))
                menu.Footer("/e " .. emote[2], index)
                preview_emote = emote
                return
            end
        end
    end)
    _menu.OnClose(function()
        preview_emote = nil
        menu.Footer("")
    end)
end ]]

local TitlesAnims = {}
local InRecherche = false

local function CreateEmoteSubMenu(submenu, list)

    --emotes.Button(submenu.title, nil, nil, "chevron", false, function()end, submenu)
    table.insert(TitlesAnims, submenu)
    
    --PreviewEmotesCallback(submenu, list)
    
    --submenu.Button("Rechercher", nil, nil, "search", false, function()
    --    submenu.removeFilter()
    --    if submenu.isFiltered() then
    --        Wait(0)
    --        local search = exports["core"]:KeyboardImput("Rechercher", "")
    --        submenu.filter(function(item)
    --            if search == nil or search == "" then
    --                submenu.Get(1).Update({ title = "Rechercher" })
    --                return true
    --            end
    --            submenu.Get(1).Update({ title = search })
    --            return item.props.title:lower():find(search:lower(), 1, true) or item.props.icon == "search"
    --        end)
    --    else
    --        local search = exports["core"]:KeyboardImput("Rechercher", "")
    --        submenu.filter(function(item)
    --            if search == nil or search == "" then 
    --                return true 
    --            end
    --            submenu.Get(1).Update({ title = search })
    --            return item.props.title:lower():find(search:lower(), 1, true) or item.props.icon == "search"
    --        end)
    --    end
    --end)

    submenu.SearchInput("Rechercher", false)

    submenu.AddHelpButton("X", "Arrêter l'emote")
    submenu.AddHelpButton("U", "Copier l'animation")
    submenu.AddHelpButton("O", "Favoris")

    for _, emote in pairsByKeys(list) do
        submenu.Button(emote[3], nil, nil, nil, false, function()
            PlayEmote(emote)
        end)
    end
    
    local function findInlist(emotename)
        for k, emote in pairsByKeys(list) do
            if emote[3] == emotename then 
                return k
            end
        end
        return nil
    end

    submenu.OnIndexChange(function(index, item)
        local emote = findInlist(item.props.title)
        submenu.Footer(emote and "/e " .. emote or nil)
    end)
end



menu.OnOpen(function()
    --UpdateOrCreateClone()
    menu.Button("🎬 Animation", nil, nil, "chevron", false, function()end, emotes)
    menu.Button("🚶 Démarche", nil, nil, "chevron", false, function()end, walk)
    menu.Button("🔫 Style de visée", nil, nil, "chevron", false, function()end, aim)
    menu.Button("😜 Humeur", nil, nil, "chevron", false, function()end, mood)
    menu.Button("🌟 Favoris", nil, nil, "chevron", false, function()end, favorite)

    menu.AddHelpButton("X", "Arrêter l'emote")
    menu.AddHelpButton("U", "Copier l'animation")
end)

walk.OnOpen(function()
    if InRecherche then return end
    walk.SearchInput("Rechercher", false)
    for k, walkStyle in pairsByKeys(EmotesList.Walks) do
        walk.Button(walkStyle[2] or k, nil, nil, nil, false, function()
            RequestWalking(walkStyle[1])
            SetPedMovementClipset(GetPlayerPed(-1), walkStyle[1], 0.2)
            SetResourceKvp('demarcheVision',tostring(walkStyle[1]))
        end)
    end

    local function findInlist(emotename)
        for k, walkStyle in pairsByKeys(EmotesList.Walks) do
            if walkStyle[2] == emotename or k == emotename then 
                return k
            end
        end
        return nil
    end
    
    walk.OnIndexChange(function(index, item)
        local emote = findInlist(item.props.title)
        walk.Footer(emote and "/walk " .. emote or nil)
    end)
end)

mood.OnOpen(function()
    if InRecherche then return end
    mood.SearchInput("Rechercher", false)
    for _, expression in pairsByKeys(EmotesList.Expressions) do
        mood.Button(expression[2], nil, nil, nil, false, function()
            SetFacialIdleAnimOverride(GetPlayerPed(-1), expression[1])
        end)
    end
end)

favorite.OnOpen(function()
    if InRecherche then return end
    favorite.SearchInput("Rechercher", false)

    for _, anim in pairsByKeys(FavoritesEmotes) do
        favorite.Button(AllEmotes[anim][3], nil, nil, nil, false, function()
            PlayEmote(AllEmotes[anim])
        end)
    end
        
    local function findInlist(emotename)
        for k, emote in pairsByKeys(AllEmotes) do
            if emote[3] == emotename then 
                return k
            end
        end
        return nil
    end

    favorite.OnIndexChange(function(index, item)
        local emote = findInlist(item.props.title)
        favorite.Footer(emote and "/e " .. emote or nil)
    end)
end)

research.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(research, AllEmotes)
end)

dances.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(dances, EmotesList.Dances)
end)

activites.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(activites, EmotesList.ActivitesEmotes)
end)

gestures.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(gestures, EmotesList.GestesEmotes)
end)

props.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(props, EmotesList.PropEmotes)
end)

positions.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(positions, EmotesList.PositionsEmotes)
end)

sante.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(sante, EmotesList.SanteEmotes)
end)

sports.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(sports, EmotesList.SportEmotes)
end)

gang.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(gang, EmotesList.GangEmotes)
end)

animals.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(animals, EmotesList.AnimalEmotes)
end)

emotes.OnOpen(function()
    emotes.Button("Danses", nil, nil, "chevron", false, function()end, dances)
    emotes.Button("Activités", nil, nil, "chevron", false, function()end, activites)
    emotes.Button("Gestes", nil, nil, "chevron", false, function()end, gestures)
    emotes.Button("Objets", nil, nil, "chevron", false, function()end, props)
    emotes.Button("Positions", nil, nil, "chevron", false, function()end, positions)
    emotes.Button("Santé", nil, nil, "chevron", false, function()end, sante)
    emotes.Button("Sports", nil, nil, "chevron", false, function()end, sports)
    emotes.Button("Gang", nil, nil, "chevron", false, function()end, gang)
    emotes.Button("Animaux", nil, nil, "chevron", false, function()end, animals)
    emotes.Button("Autres", nil, nil, "chevron", false, function()end, other)
    emotes.Button("Partagées", nil, nil, "chevron", false, function()end, shared)
    emotes.AddHelpButton("X", "Arrêter l'emote")
    emotes.AddHelpButton("U", "Copier l'animation")
end)

aim.OnOpen(function()
    aim.Button("Normal", nil, nil, nil, false, function()
        HillbillyAS = false
        GangsterAS = false
    end)
    aim.Button("Gangster", nil, nil, nil, false, function()
        HillbillyAS = false
        GangsterAS = true
    end)
    aim.Button("Hilly Billy", nil, nil, nil, false, function()
        HillbillyAS = true
        GangsterAS = false
    end)
end)

--PreviewEmotesCallback(shared, EmotesList.Shared)

shared.OnOpen(function()
    if InRecherche then return end
    for _, emote in pairsByKeys(EmotesList.Shared) do
        shared.Button(emote[3], nil, nil, nil, false, function()
            local player = exports["core"]:ChoicePlayersInZone(3.0, false)
            if player ~= nil then
                TriggerServerEvent("emotes:AskForSharedEmote", GetPlayerServerId(player), emote)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "~s Aucun joueur à proximité !"
                })
            end
        end)
    end
    
    local function findInlist(emotename)
        for k, emote in pairsByKeys(EmotesList.Shared) do
            if emote[3] == emotename then 
                return k
            end
        end
        return nil
    end
    
    shared.OnIndexChange(function(index, item)
        local emotee = findInlist(item.props.title)
        shared.Footer(emotee and "/nearby " .. emotee or nil)
    end)
end)

other.OnOpen(function()
    if InRecherche then return end
    CreateEmoteSubMenu(other, EmotesList.AutresEmotes)
end)

Keybind("F4", "open", "Ouvrir / Fermer le menu d'animations", function()
    menu.toggle()
end)

Keybind("X", "cancel", "Annuler l'animation", function()
    StopEmote()
end)

Keybind("U", "clone", "Copier l'animation", function()
    CloneEmoteNearestPlayer()
end)

Keybind("O", "favorite2", "Animation favorite", function()
    RegisterFavoriteEmote()
end)

-- Thread for aiming styles
CreateThread(function()
    while true do
        Wait(80)

        inVeh = IsPedInVehicle(PlayerPedId(-1), GetVehiclePedIsIn(PlayerPedId(-1), false), false)
        
        if GangsterAS == true then
            local ped = PlayerPedId(), DecorGetInt(PlayerPedId())
            local _, hash = GetCurrentPedWeapon(ped, 1)
            if not inVeh then
                loadAnimDict2("combat@aim_variations@1h@gang")
                if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                        TaskPlayAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(ped, true)
                    end
                elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@gang", "aim_variation_a", 3) then
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                end
            end
        elseif HillbillyAS == true then
            local ped = PlayerPedId(), DecorGetInt(PlayerPedId())
            local _, hash = GetCurrentPedWeapon(ped, 1)
            if not inVeh then
                loadAnimDict2("combat@aim_variations@1h@hillbilly")
                if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if not IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                        TaskPlayAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                        SetEnableHandcuffs(ped, true)
                    end
                elseif IsEntityPlayingAnim(ped, "combat@aim_variations@1h@hillbilly", "aim_variation_a", 3) then
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                end
            end
        end
    end
end)