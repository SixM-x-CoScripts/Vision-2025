local Papiers = {}

-- Evénement pour l'envoi du papier à une cible
--@param target : serverID de la cible
--@param data : data retournée par le NUI

RegisterServerEvent("nuiPapier:server:getInformation")
AddEventHandler("nuiPapier:server:getInformation", function(target, data)
  local source = source
  local player = GetPlayer(source)
  data.signature1 = player:getLastname() .. " " .. player:getFirstname()
  --Envoi au joueur cible
  TriggerClientEvent("nuiPapier:client:signature",target,source,data)
end)

-- Evénement pour sauvegarder en BDD le papier
-- @sender : serverID du joueur qui a créé la facture
-- @param data : data retournée par le NUI
RegisterServerEvent("nuiPapier:server:save")
AddEventHandler("nuiPapier:server:save", function(sender, data)
  local source = source -- serverID du joueur qui a reçu la facture
  local player2 = GetPlayer(source)
  data.signature2 = player2:getLastname() .. " " .. player2:getFirstname()
  
  if data.receipt then
    TriggerClientEvent("__atoshi::createNotification", sender, {
        type = 'ROUGE',
        content = "Vous avez récupéré ~s une " .. data.type
    })
  end

  --sauvegarde en base de donnée
  MySQL.Async.insert('INSERT INTO papiers (type, data) VALUES (?,?)',{data.type,json.encode(data.values)}, function(id)
    Papiers[id] = data
    Papiers[id].type = data.type
    TriggerClientEvent("nuiPapier:client:createItem",sender,id)
    TriggerClientEvent("nuiPapier:client:createItem",source,id)
  end)
end)

-- Evénement pour ouvrir le papier après signature
--@target : serverID du joueur qui veut ouvrir le papier
--@id : id du papier
RegisterServerEvent("nuiPapier:server:openPapier")
AddEventHandler("nuiPapier:server:openPapier", function(target,id)
  if Papiers[id] ~= nil then
    TriggerClientEvent("nuiPapier:client:openPapier",target,Papiers[id])
  else
    MySQL.Async.fetchAll('SELECT type,data FROM papiers WHERE id = ?',{id}, function(papier)
      if next(papier) then
        Papiers[id] = {}
        Papiers[id].values = json.decode(papier[1].data)
        Papiers[id].type = papier[1].type
        TriggerClientEvent("nuiPapier:client:openPapier",target,Papiers[id])
      end
    end)
  end
end)

RegisterNetEvent("core:sendFactureCustom", function(player, price, products)
    local src = source 
    local nameSource = GetPlayer(src):getFirstname() .. " " .. GetPlayer(src):getLastname() 
    local namePly = GetPlayer(player):getFirstname() .. " " .. GetPlayer(player):getLastname() 
    local job = jobs[GetPlayer(src):getJob()].label
    TriggerClientEvent("nuiPapier:createCustomFacture", player, price, nameSource, namePly, products, job, src)
end)