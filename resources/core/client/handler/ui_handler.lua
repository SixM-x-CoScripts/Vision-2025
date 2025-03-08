RegisterNUICallback(
    "focusOut",
    function(data, cb)
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false, false)
        cb({})
    end
)
