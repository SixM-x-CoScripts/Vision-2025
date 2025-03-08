AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(props_list) do
            if DoesEntityExist(v.handle) then
                DeleteEntity(v.handle)
            end
        end
    end
end)