local sounds = {
    ["click"] = {"SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
    ["nav"] = {"NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET"}
}


function RubyUI:PlaySound(ref)
    if sounds[ref] ~= nil then
        PlaySoundFrontend(-1, sounds[ref][1], sounds[ref][2], 1)
    end
end