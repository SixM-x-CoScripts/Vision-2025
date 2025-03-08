--[[ RegisterNetEvent('core:UseIdentityCard')
AddEventHandler("core:UseIdentityCard", function(token, name, firstname, sex, birthday, height, id, target)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:UseIdentityCard", target, name, firstname, sex, birthday, height, id)
    end
end) ]]

RegisterNetEvent('core:UseIdentityCard')
AddEventHandler("core:UseIdentityCard", function(token, dl,
    exp,
    ln,
    fn,
    dob,
    id, class,
    sex,
    hair,
    eyes,
    hgt,
    wgt,
    iss, target)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:UseIdentityCard", target, dl,
        exp,
        ln,
        fn,
        dob,
        id, class,
        sex,
        hair,
        eyes,
        hgt,
        wgt,
        iss)
    end
end)