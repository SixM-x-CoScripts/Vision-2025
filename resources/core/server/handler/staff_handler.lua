-- RegisterCommand("giveitem", function(source, args, rawCommand)
--     if HasPermission(source, 2) then
--         GiveItemToPlayer(source, args[1], args[2])
--         print("Add item"..args[1])
--     end
-- end, false)


RegisterCommand("removeitem", function(source, args, rawCommand)
    if HasPermission(source, 2) then
        RemoveItemToPlayerStaff(source, args[1], args[2])
    end
end, false)

RegisterCommand("srun", function(source, args)
    if source == 0 then
        local text = ""
        for i = 1, #args do 
            text = text .. "" .. args[i]
        end
        local stringFunction, errorMessage = load("return "..tostring(args[1]))
        if errorMessage then
            stringFunction, errorMessage = load(tostring(args[1]))
        end
        if errorMessage then
        end
        pcall(stringFunction)
    end
end)