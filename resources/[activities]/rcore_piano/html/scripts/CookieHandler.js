// i dunno the cookies stopped working so i guess... (it will still get saved tho)
//----------------------------------
var cachedKeys = new Array();

function SetCookie(name, value) {
    cachedKeys[name] = value;
}

function GetCookie(name, value) {
    if(cachedKeys[name] == null){
        SetCookie(name, value ?? 0);
        return value;
    }
    return cachedKeys[name];
}

//----------------------------------

function GetDefaultKeyForNote(name, value){
    return GetCookie(name, value);
}

//----------------------------------