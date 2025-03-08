Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:sapinprerequischeck", function(source)
        local boulenoel = DoesPlayerHaveItemCount(source, "boulenoel", 3)
        local girlande = DoesPlayerHaveItemCount(source, "guirlande", 1)
        if boulenoel == true and girlande == true then
            return true, ""
        else
            if girlande == false then
                return false, "guirlande"
            else
                return false, "Boule(s) de Noël"
            end
        end
    end)

    local HasChanged = {}
    RegisterServerCallback("core:hasChangedVetements", function(source)
        local ply = GetPlayer(source)
        local id = ply:getId()
        local toRet = false
        if not HasChanged[id] then
            toRet = false
            HasChanged[id] = true

            for i= 1, 2 do
                for k,v in pairs(ply:getInventaire()) do 
                    --print("v.type", v.name, v.type)
                    if v.type and string.lower(v.type) == "clothes" then 
                        --print(source, v.name, v.count, v.metadatas)
                        local ret = RemoveItemToPlayer(source, v.name, v.count, v.metadatas)
                        --print("ret", ret)
                    else
                        if v.name == "tshirt" or v.name == "mask" or v.name == "pant" or v.name == "hat" or v.name == "bracelet" or v.name == "access" or v.name == "feet" or v.name == "outfit" or v.name == "glasses" then 
                            local ret = RemoveItemToPlayer(source, v.name, v.count, v.metadatas)
                        end
                    end
                end
            end
            ply:setNeedSave(true)

            GiveItemToPlayer(source, "money", 5000)
            TriggerClientEvent("core:SetNewInventory", source, ply:getInventaire())
        else
            toRet = true
        end
        return toRet
    end)
end)
