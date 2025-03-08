function string.capitalize(str)
    if str=="" then return end
    local first = str:sub(1,1)
    local last = str:sub(2)
    return first:upper()..last:lower()
end