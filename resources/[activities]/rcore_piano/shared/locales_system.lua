Locales = {}

-- this is for translation
function _U(str, ...)
    if type(Locales) ~= "table" then
        print(string.format("[%s] the locales is wrong type, it is not a table..", GetCurrentResourceName()))
        return nil
    end
    if not Locales[Config.Locale] then
        print(string.format("[%s] The language does not exists: %s", GetCurrentResourceName(), Config.Locale))
        return nil
    end
    if not Locales[Config.Locale][str] then
        print(string.format("[%s] There isnt such [%s] translation", GetCurrentResourceName(), str))
        return nil
    end
    return string.format(Locales[Config.Locale][str], ...)
end