DestroyedGamesIdentifier =  {}

function CreateGame()
    local beerGame = CreateBeerPongGame()

    beerGame.SetIdentifier(math.random(99999999))

    beerGame.SetAuthor(true)

    beerGame.CreateCupPoint(cupsPoint)

    if chargeMoney then
        beerGame.SetAdmissionMoney(chargeMoney)
    end

    beerGame.CreateStartPoint(startPoint)

    beerGame.SetGameDifficulty(difficultyLevel)

    for k, v in pairs(posObjects) do
        if IsModelACup(v.model) then
            v.model = nil
        end
        beerGame.AddCupInfo(v.model, v.pos)
    end

    beerGame.Create()

    table.insert(GameCache, beerGame)

    TriggerServerEvent(TriggerName("CreateBeerGame"), beerGame.GetTableData())
    TriggerServerEvent(TriggerName("RemoveCupSet"))

    ResetMenuVariables()
    CloseAllOpenedMenu()
end

function FinishGame()
    local index = 0
    local beerPongMenu = CreateMenu("create_beer_game")

    beerPongMenu.SetMenuTitle(_U("start_menu"))

    beerPongMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    index = index + 1
    beerPongMenu.AddItem(index, Config.Framework ~= "0" and _U("start_without_bets") or _U("start_standalone"), function()
        CreateGame()
    end)

    if Config.Framework ~= "0" then
        index = index + 1
        beerPongMenu.AddItem(index, _U("playing_for_money"), function()
            local moneyMenu = CreateInputMenu("put_input")

            moneyMenu.SetMenuTitle(_U("money_to_bet"))

            moneyMenu.OnInputText(function(text)
                local number = tonumber(text)
                if number then
                    chargeMoney = number
                    moneyMenu.Close()
                    CreateGame()
                    ShowHelpNotification(_U("new_admission_set"))
                else
                    ShowHelpNotification(_U("wrong_format"), "danger")
                end
            end)

            moneyMenu.Open()
        end)
    end

    index = index + 1
    beerPongMenu.AddItem(index, _U("exit"), function()
        CloseAllOpenedMenu()
        ResetMenuVariables()
    end)

    beerPongMenu.OnExitEvent(function()
        ResetMenuVariables()
    end)

    beerPongMenu.Open()
end

function DifficultyPongGame()
    local beerPongMenu = CreateMenu("create_beer_game")

    beerPongMenu.SetMenuTitle(_U("how_hard"))

    beerPongMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    local chooseDifficulty = function(diff)
        CloseAllOpenedMenu()
        difficultyLevel = diff
        PickLocationForCups()
    end

    beerPongMenu.AddItem(1, _U("easy"), function()
        chooseDifficulty(DifficultyType.Easy)
    end)

    beerPongMenu.AddItem(2, _U("medium"), function()
        chooseDifficulty(DifficultyType.Medium)
    end)

    beerPongMenu.AddItem(3, _U("hard"), function()
        chooseDifficulty(DifficultyType.Hard)
    end)

    beerPongMenu.AddItem(4, _U("nightmare"), function()
        chooseDifficulty(DifficultyType.Nightmare)
    end)

    beerPongMenu.AddItem(5, _U("exit"), function()
        CloseAllOpenedMenu()
        ResetMenuVariables()
    end)

    beerPongMenu.OnExitEvent(function()
        ResetMenuVariables()
    end)

    beerPongMenu.Open()
end

function OpenPrefabCupsMenu()
    local beerPongMenu = CreateMenu("create_beer_game")

    beerPongMenu.SetMenuTitle(_U("scheme"))

    beerPongMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    local index = 0
    for k, v in pairs(Config.GameSetups) do
        index = index + 1
        beerPongMenu.AddItem(v.Order, v.Label, function()
            CloseAllOpenedMenu()
            cupsPositions = v.Cups
            tableHash = v.PropTable
            DifficultyPongGame()
        end)
    end

    beerPongMenu.AddItem(index + 1, _U("exit"), function()
        CloseAllOpenedMenu()
        ResetMenuVariables()
    end)

    beerPongMenu.OnExitEvent(function()
        ResetMenuVariables()
    end)

    beerPongMenu.Open()
end

function OpenThrowPositionMenu()
    local beerPongMenu = CreateMenu("create_beer_game")

    beerPongMenu.SetMenuTitle(_U("where_throw"))

    beerPongMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    beerPongMenu.AddItem(1, _U("here"), function()
        CloseAllOpenedMenu()
        OpenPrefabCupsMenu()

        startPoint = GetEntityCoords(PlayerPedId())
    end)

    beerPongMenu.AddItem(2, _U("exit"), function()
        CloseAllOpenedMenu()
        ResetMenuVariables()
    end)

    beerPongMenu.OnExitEvent(function()
        ResetMenuVariables()
    end)

    beerPongMenu.Open()
end

function OpenCupsPositionMenu()
    local beerPongMenu = CreateMenu("create_beer_game")

    beerPongMenu.SetMenuTitle(_U("location_cup"))

    beerPongMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    beerPongMenu.AddItem(1, _U("here"), function()
        CloseAllOpenedMenu()
        OpenThrowPositionMenu()

        cupsPoint = GetEntityCoords(PlayerPedId())
    end)

    beerPongMenu.AddItem(2, _U("exit"), function()
        CloseAllOpenedMenu()
        ResetMenuVariables()
    end)

    beerPongMenu.OnExitEvent(function()
        ResetMenuVariables()
    end)

    beerPongMenu.Open()
end

function OpenMenuToDestroyGame(self)
    local beerPongMenu = CreateMenu("create_beer_game")

    beerPongMenu.SetMenuTitle(_U("remove_game"))

    beerPongMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    beerPongMenu.AddItem(1, _U("yes"), function()
        BeerPongInventory = BeerPongInventory + 1
        TriggerServerEvent(TriggerName("EndGame"), self.GetIdentifier())
        CloseAllOpenedMenu()
        DestroyedGamesIdentifier[self.GetIdentifier()] = true
    end)

    beerPongMenu.AddItem(2, _U("exit"), function()
        CloseAllOpenedMenu()
    end)

    beerPongMenu.Open()
end