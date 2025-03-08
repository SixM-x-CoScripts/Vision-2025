function PlayNoteFromPaper(paperIndex, line, fromStart = 0){
    var octavia = 1;
    for(var i = 0; i < 5; i ++){
        var indexKey = (paperIndex * i) + fromStart + newIndex;
        var note = App.pianoNotesRecord[indexKey];
        App.playingNoteFromRecord[indexKey] = true;
        octavia = App.pianoNotesOctaviaRecord[indexKey];
        var toneType = App.pianoNoteTypeRecord[indexKey];
        if(note != null){
            var stripedNote = note.replace(" ","");
            if(stripedNote.length == 1){
                App.PlayPianoNote(stripedNote, octavia, toneType);
                BlockKeyPiano = false;
                continue;
            }

            if(stripedNote.length == 2){
                App.PlayPianoSharpNote(stripedNote, octavia, toneType);
                BlockKeyPiano = false;
                continue;
            }

            note = note.split(" ");
            if(note[0] != null && note[0] !== ''){
                App.PlayPianoSharpNote(note[0], octavia, toneType);
                BlockKeyPiano = false;
            }

            if(note[1] != null && note[1] !== ''){
                App.PlayPianoNote(note[1], octavia, toneType);
                BlockKeyPiano = false;
            }
        }
    }
}

function HideGreenNotes(){
    for(var i = 0; i < 250; i ++){App.playingNoteFromRecord[i] = false;}
}

function SetKeyToPaper(SharpKey, Key){
    if(Key == null){
        Key = "";
        for(var i = 0; i < App.keyNotes.length; i ++) {
            if(App.keyNotes[i].active){
                Key = App.keyNotes[i].Note;
            }
        }
    }

    if(SharpKey == null){
        SharpKey = "";
        for(var i = 0; i < App.keySharpNotes.length; i ++){
            if(App.keySharpNotes[i].active){
                SharpKey = App.keySharpNotes[i].Note;
            }
        }
    }

    for(var i = 0; i < App.octaviaList.length; i ++){
        var data = App.octaviaList[i];
        if(data.active){
            App.pianoNotesOctaviaRecord[noteIndex] = data.octavia;
            break;
        }
    }

    for(var i = 0; i < App.pianoNotesType.length; i ++){
        var data = App.pianoNotesType[i];
        if(data.active){
            App.pianoNoteTypeRecord[noteIndex] = data.name;
            break;
        }
    }

    App.pianoNotesRecord[noteIndex] = SharpKey + " " + Key
    App.freezeKeys = false;
}

function ResetTemplate(){
    noteIndex = -1;
    newIndex = -1;
    page = -1;
    cachedPage = 0;
    pageData = [];

    App.pageEx = 0;
    App.pianoNotesRecord = [];

    HideGreenNotes();

    for(var i = 0; i < 2; i ++) App.NextPage();
    for(var i = 0; i < 4; i ++) App.PrevPage();

    if(TimerForPlayingMusic != null){
        clearInterval(TimerForPlayingMusic);
    }
    TimerForPlayingMusic = null;
}

function sendAlert(msg, style = 'success') {
    $.notify( { message: msg,}, {
        type: style,
        showProgressbar: false,
        newest_on_top: true,
        animate:
        {
            enter: "animated bounceInRight",
            exit: "animated bounceOutRight",
        }
    });
}

function RefreshRecorder(){
    App.visible = "none";
    App.visible = "record";
}

function RefreshPiano(){
    App.visible = "none";
    App.visible = "piano";
}

// stolen from
// https://stackoverflow.com/questions/610406/javascript-equivalent-to-printf-string-format
String.prototype.formatUnicorn = String.prototype.formatUnicorn ||function () {
    "use strict";
    var str = this.toString();
    if (arguments.length) {
        var t = typeof arguments[0];
        var key;
        var args = ("string" === t || "number" === t) ?
            Array.prototype.slice.call(arguments)
            : arguments[0];

        for (key in args) {
            str = str.replace(new RegExp("\\{" + key + "\\}", "gi"), args[key]);
        }
    }

    return str;
};