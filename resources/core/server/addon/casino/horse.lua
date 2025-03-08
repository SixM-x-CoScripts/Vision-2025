SWRegisterServCallback("Flozii:casino:GetIRLTime", function(source, cb)
    cb(tonumber(os.date("%H")), tonumber(os.date("%M")), tonumber(os.date("%S")))
end)

SWRegisterServCallback("sunwisecasino:GetNumJetons", function(source, cb)
    local coun = CasinoConfig.GetChipsCount(source)
    cb(coun)
end)

SWRegisterServCallback("Flozii:CanHaveJetons", function(source, cb, jetons)
    local bool = CasinoConfig.CanBuyChips(source, jetons)
    cb(bool)
end)

RegisterNetEvent("sunwise:casino:sellChips", function(jetons)
    local src = source
    CasinoConfig.SellChips(src, jetons)
end)

local SeatTaken = {}

SWRegisterServCallback("sunwisecasino:horse:sitDown", function(source, cb, coords)
    if not SeatTaken[coords] then 
        SeatTaken[coords] = source
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("Flozii:casino:RemoveSeat")
AddEventHandler("Flozii:casino:RemoveSeat", function(coords)
    if SeatTaken[coords] then 
        SeatTaken[coords] = nil
    end    
end)

AddEventHandler('playerDropped',function(source,reason)
    for k, v in pairs(SeatTaken) do
        if v == source then
            SeatTaken[k] = nil
        end
    end
end)


RegisterNetEvent("flozii:casino:remove")
AddEventHandler("flozii:casino:remove", function(f)
    if f then 
        if f < 99999 then 
            local _source = source
            CasinoConfig.RemoveChips(_source, f)
        end
    end
end)    


while RegisterSecurServerEvent == nil do Wait(1) end 

RegisterSecurServerEvent("flozii:casino:win", function(f, e)
    if f and e then 
        if e.z < 0.0 then 
            if f < 99999 then 
                local _source = source
                CasinoConfig.GiveChips(_source, f)
            end
        end
    end
end)    