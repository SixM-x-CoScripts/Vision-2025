var HoldedKeys = [];

$("#bd").on("keyup", function(event) {
    HoldedKeys[event.keyCode] = null;
    OnKeyRelease(event.keyCode)
});

$("#bd").on("keydown", function(event) {
    if(HoldedKeys[event.keyCode] == null){
        HoldedKeys[event.keyCode] = true;
        OnKeyDown(event.keyCode)
    }
});