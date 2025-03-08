local globalSender = 0
local globalTarget = 0
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

-- Evénement pour déclencher la création de papiers
--@param typeBill : Type de papier
-- 1 pour le certificat médical
-- 2 pour la facture
-- 3 pour le contrat
-- 4 pour la déposition

RegisterNetEvent("nuiPapier:createCustomFacture", function(price, sourceName, plyName, description, job, sender)
  globalSender = sender
  SendNuiMessage(json.encode({
      type = 'openWebview',
      name = 'Papier',
      data = {
        type = "facture",
        callbackName= 'Papiers',
        state= 'toBeSigned',
        overrideImage = nil,
        signature1 = sourceName,
        values = {
          player1 = plyName,
          player2 = sourceName,
          society = job,
          value = price,
          name = job,
          info = description
        },
      }
  }))
end)

RegisterNetEvent("nuiPapier:client:startCreation")
AddEventHandler("nuiPapier:client:startCreation", function(typeBill, image)


  local player1
  local player2

  local format = "facture"
  if typeBill == 1 then

    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))

    format = "certificat"
    player1 = p:getFirstname() .. " " .. p:getLastname()
    player2 = nameTarget
  elseif typeBill == 2 then

    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))


    format = "facture"
    player1 = p:getFirstname() .. " " .. p:getLastname()
    player2 = nameTarget
  elseif typeBill == 3 then

    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))


    format = "contrat"
    player1 = p:getFirstname() .. " " .. p:getLastname()
    player2 = nameTarget
  elseif typeBill == 4 then

    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))



    format = "deposition"
    player2 = nameTarget
  elseif typeBill == 5 then

    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))


    format = "convocation"
    player1 = nameTarget
    player2 = p:getFirstname() .. " " .. p:getLastname()

  elseif typeBill == 6 then
    local player

    local format = "DemandeCI"
    player = p:getFirstname() .. " " .. p:getLastname()
    datenaissance = p:getAge()
    lieuxnaissance = "Los Santos"
    --Ouverture du NUI
    SendNuiMessage(json.encode({
      type = 'openWebview',
      name = 'Papier',
      data = {
        type = "DemandeCI",
        callbackName= 'Papiers',
        state= 'creation',
        overrideImage = image,
        values = {
          name = 'Carte d\'Identité',
          player = player,
          datenaissance = datenaissance,
          lieuxnaissance = "Los Santos"
        },
      }
    }))
    return
  elseif typeBill == 7 then

    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerJobArea",  GetPlayerServerId(closestPlayer))


    format = "factureToEntreprise"
    player1 = p:getFirstname() .. " " .. p:getLastname()

    local plrsociety = jobs[nameTarget].label

    player2 = plrsociety
  elseif typeBill == 8 then
    globalTarget = 0

    InPapierBadge = true
    local closestPlayer = ChoicePlayersInZone(5.0, true)

    if closestPlayer == nil then
      InPapierBadge = false
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))

    format = "policeBadge"
    player1 = p:getFirstname() .. " " .. p:getLastname()
    player2 = nameTarget

    SendNuiMessage(json.encode({
      type = 'openWebview',
      name = 'Papier',
      data = {
        type = "policeBadge",
        callbackName= 'Papiers',
        state= 'creation',
        values = {
          service = p:getJob(),
          name = player2,
          player1 = player1,
          player2 = player2,
        },
      }
    }))
    return
  elseif typeBill == 9 then
    globalTarget = 0
    -- Conversation du type de format en nom
    --Récupération du joueur le plus proche
    InPapierPPA = true
    local closestPlayer = ChoicePlayersInZone(5.0, true)
    if closestPlayer == nil then
      InPapierPPA = false
      return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    --Récupération du nom du joueur
    local nameTarget = TriggerServerCallback("core:GetPlayerAreaName",  GetPlayerServerId(closestPlayer))


    format = "PapierPPA"
    player1 = nameTarget
    player2 = p:getFirstname() .. " " .. p:getLastname()

    SendNuiMessage(json.encode({
      type = 'openWebview',
      name = 'Papier',
      data = {
        type = "PapierPPA",
        callbackName= 'Papiers',
        state= 'creation',
        values = {
          service = p:getJob(),
          name = player2,
          issuer = player1,          
          player1 = player1,
          player2 = player2,
        },
      }
    }))
    return
  end
    --Ouverture du NUI
    local society = p:getJob()
    SendNuiMessage(json.encode({
      type = 'openWebview',
      name = 'Papier',
      data = {
        type = format,
        callbackName= 'Papiers',
        state= 'creation',
        overrideImage = image,
        values = {
          player1 = player1,
          player2 = player2,
          society = society
        },
      }
    }))

end)

-- Evénement pour déclencher la signature du papier
--@param sender : Joueur qui a créé la facture
--@param data : data retournée par le NUI lors de la création
RegisterNetEvent("nuiPapier:client:signature")
AddEventHandler("nuiPapier:client:signature", function(sender, data)
  globalSender = sender --Sauvegarde du joueur qui a envoyé la facture

  SendNuiMessage(json.encode({
    type = 'closeWebview',
  }))
  
  Wait(200)

  SendNuiMessage(json.encode({
    type = 'openWebview',
    name = 'Papier',
    data = {
      type = data.type,
      callbackName = "Papiers",
      state = "toBeSigned",
      overrideImage = data.image,
      signature1 = data.signature1,
      values = data.values
    }
  }))
end)

-- Evénement pour créer l'item dans l'inventaire
--@param id : ID du papier dans la base de donnée
RegisterNetEvent("nuiPapier:client:createItem")
AddEventHandler("nuiPapier:client:createItem", function(id)
  TriggerSecurGiveEvent("core:addItemToInventory", token, "papier", 1, {id = id})
end)

-- Evénement pour réouvrir un papier
--@param data : valeur fourni par la base de donnée
RegisterNetEvent("nuiPapier:client:openPapier")
AddEventHandler("nuiPapier:client:openPapier", function(data)
  SendNuiMessage(json.encode({
    type = 'closeWebview',
  }))
  
  Wait(200)
  
  SendNuiMessage(json.encode({
    type = 'openWebview',
    name = 'Papier',
    data = {
      type = data.type,
      callbackName = "Papiers",
      state = "signed",
      overrideImage = data.image,
      signature1 = data.signature1,
      signature2 = data.signature2,
      values = data.values
    }
  }))
end)

invoiceRate = {
  ["realestateagent"] = 10,
  ["bennys"] = 10,
  ["cayogarage"] = 10,
  ["ocean"] = 10,
  ["beekers"] = 10,
  ["reyes"] = 10,
  ["harmony"] = 10,
  ["sunshine"] = 10,
  ["ammunation"] = 8,
  ["vangelico"] = 20,
}

-- Evénement de retour du NUI
--@param data : Valeur envoyé par le NUI
--@param cb : fonction de retour
RegisterNUICallback("Papiers", function(data,cb)
  --Retour pour éviter les erreurs dans la console
  cb('ok')
  if data.state == "creation" then
    if data.type == 'DemandeCI' then

      local sold = false
      for k, v in pairs(p:getInventaire()) do
        if v.name == "money" then
            if v.count >= 10 then

                local tablepermis = nil 

                sold = true
                local id = math.random(100000, 999999)
                local year --[[ integer ]], month --[[ integer ]], day = GetLocalTime(year, month, day)
                -- print(day, month+6, year)
                local serverId = p:getId()
                --[[ print(token) ]]
                --print(serverId)
                local driving = TriggerServerCallback("core:getLicenseInPlayer", token, 'driving')

                local moto = TriggerServerCallback("core:getLicenseInPlayer", token, 'moto')

                local camion = TriggerServerCallback("core:getLicenseInPlayer", token, 'camion')

                local bateau = TriggerServerCallback("core:getLicenseInPlayer", token, 'bateau')

                local helico = TriggerServerCallback("core:getLicenseInPlayer", token, 'helico')

                local AllLicenses = {}

                if driving then
                  table.insert(AllLicenses, 'D')
                end

                if moto then
                  table.insert(AllLicenses, 'M')
                end

                if camion then
                  table.insert(AllLicenses, 'C')
                end

                if bateau then
                  table.insert(AllLicenses, 'B')
                end

                if helico then
                  table.insert(AllLicenses, 'H')
                end

                if driving or moto or camion or bateau or helico then
                  tablepermis = table.concat(AllLicenses, ", ")
                end

                --[[ print(tablepermis) ]]

                if tablepermis == nil then
                  tablepermis = "Aucun"
                end
        
                --[[  exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Permis possédé : ~s" .. (tablepermis=="" and "Aucun" or tablepermis)
                }) ]]
                local haircolor
                if GetPedHairColor(PlayerPedId(token)) == -1 then
                    haircolor = 'Non'
                elseif GetPedHairColor(PlayerPedId(token)) == 0 or GetPedHairColor(PlayerPedId(token)) ==  1 or GetPedHairColor(PlayerPedId(token)) == 2 or GetPedHairColor(PlayerPedId(token)) == 3 or GetPedHairColor(PlayerPedId(token)) == 4 then
                    haircolor = 'Brun'
                elseif GetPedHairColor(PlayerPedId(token)) == 5 or GetPedHairColor(PlayerPedId(token)) == 6 or GetPedHairColor(PlayerPedId(token)) == 17 then
                    haircolor = 'Roux'
                elseif GetPedHairColor(PlayerPedId(token)) == 7 or GetPedHairColor(PlayerPedId(token)) == 8 or GetPedHairColor(PlayerPedId(token)) == 9 then
                    haircolor = 'Chatain'
                elseif GetPedHairColor(PlayerPedId(token)) == 10 or GetPedHairColor(PlayerPedId(token)) == 11 or GetPedHairColor(PlayerPedId(token)) == 12 or GetPedHairColor(PlayerPedId(token)) == 13 or GetPedHairColor(PlayerPedId(token)) == 14 or GetPedHairColor(PlayerPedId(token)) == 15 or GetPedHairColor(PlayerPedId(token)) == 16 then
                    haircolor = 'Blond'
                elseif GetPedHairColor(PlayerPedId(token)) == 18 or GetPedHairColor(PlayerPedId(token)) == 19 or GetPedHairColor(PlayerPedId(token)) == 20 or GetPedHairColor(PlayerPedId(token)) == 21 then
                    haircolor = 'Rouge'
                elseif GetPedHairColor(PlayerPedId(token)) == 22 or GetPedHairColor(PlayerPedId(token)) == 23 or GetPedHairColor(PlayerPedId(token)) == 24 or GetPedHairColor(PlayerPedId(token)) == 25 or GetPedHairColor(PlayerPedId(token)) == 48 or GetPedHairColor(PlayerPedId(token)) == 49 or GetPedHairColor(PlayerPedId(token)) == 50 or GetPedHairColor(PlayerPedId(token)) == 51 then
                    haircolor = 'Orange'
                elseif GetPedHairColor(PlayerPedId(token)) == 26 or GetPedHairColor(PlayerPedId(token)) == 27 then
                    haircolor = 'Gris'
                elseif GetPedHairColor(PlayerPedId(token)) == 28 or GetPedHairColor(PlayerPedId(token)) == 29 then
                    haircolor = 'Blanc'
                elseif GetPedHairColor(PlayerPedId(token)) == 30 or GetPedHairColor(PlayerPedId(token)) == 31 then
                    haircolor = 'Violet'
                elseif GetPedHairColor(PlayerPedId(token)) == 32 or GetPedHairColor(PlayerPedId(token)) == 33 or GetPedHairColor(PlayerPedId(token)) == 34 or GetPedHairColor(PlayerPedId(token)) == 35 then
                    haircolor = 'Rose'
                elseif GetPedHairColor(PlayerPedId(token)) == 36 or GetPedHairColor(PlayerPedId(token)) == 37 or GetPedHairColor(PlayerPedId(token)) == 38 then
                    haircolor = 'Bleu'
                elseif GetPedHairColor(PlayerPedId(token)) == 39 or GetPedHairColor(PlayerPedId(token)) == 40 or GetPedHairColor(PlayerPedId(token)) == 41 or GetPedHairColor(PlayerPedId(token)) == 42 or GetPedHairColor(PlayerPedId(token)) == 43 or GetPedHairColor(PlayerPedId(token)) == 44 then
                    haircolor = 'Vert'
                elseif GetPedHairColor(PlayerPedId(token)) == 45 or GetPedHairColor(PlayerPedId(token)) == 46 or GetPedHairColor(PlayerPedId(token)) == 47 then
                    haircolor = 'Jaune'
                elseif GetPedHairColor(PlayerPedId(token)) == 52 or GetPedHairColor(PlayerPedId(token)) == 53 or GetPedHairColor(PlayerPedId(token)) == 54 then
                    haircolor = 'Rouge'
                elseif GetPedHairColor(PlayerPedId(token)) == 55 or GetPedHairColor(PlayerPedId(token)) == 56 or GetPedHairColor(PlayerPedId(token)) == 57 or GetPedHairColor(PlayerPedId(token)) == 58 or GetPedHairColor(PlayerPedId(token)) == 59 or GetPedHairColor(PlayerPedId(token)) == 60 then
                    haircolor = 'Brun'
                elseif GetPedHairColor(PlayerPedId(token)) == 61 then
                    haircolor = 'Noir'
                elseif GetPedHairColor(PlayerPedId(token)) == 62 or GetPedHairColor(PlayerPedId(token)) == 63 then
                    haircolor = 'Blond'
                end
                -- local pedEyeColour = GetPedEyeColor(PlayerPedId(token))
                TriggerSecurGiveEvent("core:addItemToInventory", token, "identitycard", 1, {
                    identity = {
                        dl = p:getId(),
                        exp = day ..'/'.. month+6 ..'/'.. year,
                        ln = p:getLastname(),
                        fn = p:getFirstname(),
                        dob = p:getAge(),
                        class = (tablepermis==nil and "Aucun" or tablepermis),
                        sex = p:getSex(),
                        hair = haircolor,
                        eyes = data.values.yeux,
                        hgt = data.values.taille,
                        wgt = data.values.poids,
                        iss = day ..'/'.. month ..'/'.. year+10
                    }
                })
                TriggerServerEvent("core:removeItemToInventory", token, "money", 1, v.metadatas)
                -- ShowNotification("~g~Vous avez acheté votre carte d'identité")
                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s acheté ~c votre ~s carte d'identité"
                })
                exports['tuto-fa']:GotoStep(4)
            end
        end
      end
    elseif data.type == 'policeBadge' and (data.values.service == nil or data.values.service == "" or data.values.name == nil or data.values.name == "" or data.values.matricule == nil or data.values.matricule == "" or data.values.grade == nil or data.values.grade == "" or data.values.divisions == nil or data.values.divisions == "") then
      exports['vNotif']:createNotification({
          type = 'ROUGE',
          content = "Veuillez remplir tous les champs !"
      })
      InPapierBadge = false
      SendNuiMessage(json.encode({
        type = 'closeWebview',
      }))
      return
    elseif data.type == 'PapierPPA' and (data.values.residence == nil or data.values.residence == "" or data.values.address == nil or data.values.address == "" or data.values.occupation == nil or data.values.occupation == "" or data.values.business == nil or data.values.business == "" or data.values.issuer == nil or data.values.issuer == "") then
      exports['vNotif']:createNotification({
          type = 'ROUGE',
          content = "Veuillez remplir tous les champs !"
      })
      InPapierPPA = false
      SendNuiMessage(json.encode({
        type = 'closeWebview',
      }))
      return
    elseif data.type ~= 'DemandeCI' then
      --Envoi du papier au joueur ciblé
      TriggerServerEvent("nuiPapier:server:getInformation", globalTarget, data)
    end
    
  elseif data.state == "toBeSigned" then
    --Sauvegarde du papier

    if data.type == 'factureToEntreprise' then
      if invoiceRate[data.values.society] then data.values.value = tonumber(data.values.value)*invoiceRate[data.values.society]/100 end
      local payed = TriggerServerCallback("core:SendMoneyFromEnterpriseToEntreprise", data.values.society, tonumber(data.values.value), globalSender)
      if payed then
        if data.values.receipt then
          exports['vNotif']:createNotification({
              type = 'JAUNE',
              content = "Vous avez récupéré ~s une " .. data.type
          })
          TriggerServerEvent("nuiPapier:server:save",globalSender,data)
        end
      end
    elseif data.type == 'policeBadge' then
      local result = exports["loaf_headshot"]:getBase64(PlayerPedId())
      TriggerServerEvent("core:sendHeadshot", token, json.encode(result.base64), data.values, p:getFirstname() .. " " .. p:getLastname())
    elseif data.type == 'PapierPPA' then
      local result = exports["loaf_headshot"]:getBase64(PlayerPedId())
      TriggerServerEvent("core:sendPPAHeadshot", token, json.encode(result.base64), data.values, p:getFirstname() .. " " .. p:getLastname())
    elseif data.type == "facture" then
      data.values.value = all_trim(tostring(data.values.value))
      local payed = TriggerServerCallback("core:BillingAccept", data.values.society, tonumber(data.values.value), data.values.info, globalSender)
      if payed then
        if data.values.receipt then
          exports['vNotif']:createNotification({
              type = 'JAUNE',
              content = "Vous avez récupéré ~s une " .. data.type
          })
          TriggerServerEvent("nuiPapier:server:save",globalSender,data)
        end
        if data.values.society == 'lspd' then TriggerServerEvent("core:penalty", tonumber(data.values.value), data.values.info, globalSender, p:getPos(), 'acceptée') end
      end
    else
      if data.values.receipt then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Vous avez récupéré ~s " .. data.type
        })
        TriggerServerEvent("nuiPapier:server:save",globalSender,data)
      end
    end
  end

  --close NUI
  SendNuiMessage(json.encode({
      type = 'closeWebview',
  }))
end)

RegisterNetEvent("nuiPapier:client:openBlocnote", function(title, content)
  SendNuiMessage(json.encode({
    type = 'closeWebview',
  }))
  
  Wait(200)
  
  SendNuiMessage(json.encode({
    type = 'openWebview',
    name = 'BlocNote',
    data = {
      content = content,
      readOnlyTitle = title
    }
  }))
end)

RegisterNUICallback("BlocNote", function(data,cb)
  --Retour pour éviter les erreurs dans la console
  cb('ok')
  --close NUI
  SendNuiMessage(json.encode({
      type = 'closeWebview',
  }))
end)