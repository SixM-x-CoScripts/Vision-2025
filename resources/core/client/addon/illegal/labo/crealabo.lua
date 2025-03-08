local main = RageUI.CreateMenu("Labo", "Menu Creation de labo")
local laboList = RageUI.CreateSubMenu(main, "Labo", "Menu Creation de labo")
local laboLInside = RageUI.CreateSubMenu(laboList, "Labo", "Menu Creation de labo")
local open = false
local index = 1
local index2 = 1
local canCreate = false
local laboVal = {}

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local LocalType = {
    "coke",
    "weed",
    "meth",
    "fentanyl"
}

local Crew = nil
local Crews = {}

local IdSelected = "~r~Aucun" 
local PosEntreShow = "~r~Aucun" 
local PosEntre = nil
local Type = nil

main.Closed = function()
    open = false
end

function CreateLaboratory()
    local allcrews = TriggerServerCallback("core:crew:getAllCrew")
    --print(json.encode(allcrews, {indent = true}))
    --print("allcrews", json.encode(allcrews))
    Wait(200)
    for k,v in pairs(allcrews) do 
        print(v.name)
        table.insert(Crews, v.name)
    end
    Wait(25)
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(laboLInside, function()
                    if laboVal.minutes then 
                        RageUI.Separator("Production en cours")
                        RageUI.Separator("Temps restant : " .. laboVal.minutes)
                    end
                    RageUI.Button("Se TP au laboratoire", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            SetEntityCoords(PlayerPedId(), laboVal.coords.x, laboVal.coords.y, laboVal.coords.z)
                        end 
                    })  
                    RageUI.Button("Supprimer le laboratoire", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                duration = 10,
                                content = "Appuyer sur ~K Y pour ~s accepter"
                            })
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                duration = 10,
                                content = "Appuyer sur ~K N pour ~s ignorer"
                            })
                            local breakable = 1
                            while true do 
                                Wait(1)
                                if IsControlJustPressed(0, 246) then -- Y
                                    TriggerServerEvent("core:labo:deleteLabo", token, laboVal.id)
                                    break
                                end
                                if IsControlJustPressed(0, 306) then -- K
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "~s Vous avez ignoré"
                                    })
                                    break
                                end
                                breakable = breakable + 1
                                if breakable > 600 then 
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "~s Vous avez ignoré"
                                    })
                                    break
                                end
                            end
                        end 
                    })                    
                end)
                RageUI.IsVisible(laboList, function()
                    for k,v in pairs(AllLaboratory) do 
                        RageUI.Button("Laboratoire " .. v.laboType or "?", false, { RightLabel = "~o~" .. v.crew }, true, {
                            onSelected = function()
                                laboVal = v
                            end 
                        }, laboLInside)
                    end
                end)
                RageUI.IsVisible(main, function()
                    --RageUI.Button("ID du crew", false, { RightLabel = IdSelected }, true, {
                    --    onSelected = function()
                    --        IdSelected = KeyboardImput("Choisissez l'ID du crew")
                    --        print("ID : ", IdSelected)
                    --    end
                    --})
                    RageUI.Button("Liste des laboratoires", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, laboList)
                    RageUI.List('Crew : ', Crews, index2, "Sélectionner le type de labo", {}, true, {
                        onListChange = function(i, s)
                            index2 = i;
                            Crew = s
                        end,
                        onSelected = function()
                            Crew = Crews[index2]
                        end
                    })
                    RageUI.List('Type : ', LocalType, index, "Sélectionner le type de labo", {}, true, {
                        onListChange = function(i, s)
                            index = i;
                            Type = s
                        end,
                        onSelected = function()
                            Type = LocalType[index]
                        end
                    })
                    RageUI.Button("Position du labo", false, { RightLabel = PosEntreShow }, true, {
                        onSelected = function()
                            PosEntreShow = "~g~Remplis"
                            PosEntre = GetEntityCoords(PlayerPedId())
                        end
                    })
                    --print(IdSelected, PosEntre, Type)
                    if Crew ~= nil and PosEntre ~= nil and Type ~= nil then
                        canCreate = true
                    end
                    RageUI.Button("Créer le labo", false, { RightLabel = ">>" }, canCreate, {
                        onSelected = function()
                            TriggerServerEvent("core:CreateLaboratory", Crew, PosEntre, Type)
                        end
                    })
                end)
                Wait(0)
            end
        end)
    end
end