local needs_save = {}

local LOADED = false

server_variables = {}

function GetVariable(name)
    while LOADED == false do Wait(0) end
    --print("GetVariable", name)
    return server_variables[name]
end

function GetVariables()
    while LOADED == false do Wait(0) end
    return server_variables
end

RegisterNetEvent("core:createVar", function(name, table)
    if not server_variables[name] then 
        SetVariable(name, table)
    end
end)

function UpdateVariables(var)
    server_variables = var
end

function SetVariable(name, value)
    server_variables[name] = value
    table.insert(needs_save, name)
end

-- Pour ajouter par exemple un job dans la variable job
-- ca check si il existe si non ça insert et save en bdd
DefaultEntrepriseVariable = [[{"marge":35,"pos":[{"x":812.0436401367188,"y":-752.01806640625,"z":25.78084182739257},{"x":812.05126953125,"y":-754.3345336914063,"z":25.78084182739257}]}]]
DefaultJobCenterVariable = [[{"location":"Greenwich","limit":"3","position":{"z":13.16157913208007,"y":-2033.916259765625,"x":-1053.1346435546876},"premium":false,"reward":"1750","maxPlayers":"2","thumbnail":"https://assets-vision-fa.cdn.purplemaze.net/https://cdn.sacul.cloud/v2/vision-cdn/JobCenter/pompiste2.webp","instructions":{"3":"Retourne voir Félix pour déposer ton camion-citerne et récupérer ta paye.","2":"Remplir les stations essence de la ville.","1":"Munis toi d'un camion-citerne auprès de Félix."},"available":true,"name":"Pompiste","image":"https://assets-vision-fa.cdn.purplemaze.net/https://cdn.sacul.cloud/v2/vision-cdn/JobCenter/pompiste.webp","duration":"15"}]]
function UpdateInsideVariable(name, nameinsert, toinsert)
    local found = false
    for k,v in pairs(server_variables[name]) do 
        if k == nameinsert then 
            found = true
        end
    end
    if not found then 
        server_variables[name][nameinsert] = toinsert
        table.insert(needs_save, name)
    end
end

CreateThread(function()
    while true do 
        Wait(5*60000)
        for k, v in pairs(needs_save) do
            MySQL.Async.execute(
                'INSERT INTO variables (name, value) VALUES (@name, @value) ON DUPLICATE KEY UPDATE value = @value', 
                {
                    ['@name'] = v,
                    ['@value'] = json.encode(server_variables[v])
                }
            )
        end
    end
end)

MySQL.ready(function()
    local loaded = 0
    MySQL.Async.fetchAll('SELECT * FROM variables', {}, function(result)
        for k, v in pairs(result) do
            loaded += 1
            server_variables[v.name] = json.decode(v.value)
        end
    end)
    LOADED = true
    CorePrint("Loaded "..loaded.." variables")
end)