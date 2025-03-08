const PolySynth = new Tone.PolySynth().toDestination();

var Precached = {};

var notes = {
    0: "c",
    1: "d",
    2: "e",
    3: "f",
    4: "g",
    5: "a",
    6: "b",
};

for(var i = 0; i < 7; i ++){
    for(var b = 0; b < 7; b ++){
        var note = notes[b];
        Precached[(i + 1) + "-" + note] = new Howl({ src: [ "./piano/classic/"+ (i + 1) +"-"+ note +".mp3"], preload: true, loop: false, html5: true, autoplay: true, volume: 0.0, format: ['mp3'], });;
        Precached[(i + 1) + "-"+ note +"s"] = new Howl({ src: [ "./piano/classic/"+ (i + 1) +"-"+ note +"s.mp3"], preload: true, loop: false, html5: true, autoplay: true, volume: 0.0, format: ['mp3'], });;
    }
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var data = event.data;
        if(data.type === "playsound"){
            if(data.volume <= 0.01){ return; }

            if(data.typeTone === "poly_synth"){
                var volume = (40 * (data.volume)) - 20;

                PolySynth.volume.value = volume;
                PolySynth.set({ detune: -0 });
                PolySynth.triggerAttackRelease([data.note.replace("s","#") + data.octavia], 0.3);
                return;
            }

            if(data.typeTone === "ele"){
                var url = Synth.generate(0, data.note.replace("s","#"), data.octavia, 2);
                new Howl({
                    src: [url],
                    loop: false,
                    html5: true,
                    autoplay: true,
                    volume: data.volume,
                    format: ['mp3'],
                });
                return;
            }

            var audio = Precached[data.octavia + "-" + data.note.toLowerCase().replace("#","s")];
            audio.volume(data.volume);
            audio.play();
        }

        if(data.type === "ShowManagerUI"){
            $('#test').modal({
                backdrop: 'static',
                keyboard: false
            });
            App.freezeKeys = true;
            App.closeUI = !data.closeUI;
            App.$nextTick(function () {
                for(var i = 0; i < App.instrumentsList.length; i ++){
                    var dt = App.instrumentsList[i];
                    dt.stuff = "--min:0; --max:100; --step:1; --value:"+ data.volume +"; --text-value:"+ data.volume +";width: 100%;";
                    dt.volume = data.volume;
                	$("#" + data.itemName).val(data.volume).trigger("input");
                }
            });
        }

        if(data.type === "add"){
            App.instrumentsList.push({
                prefix: data.prefix,
                itemName: data.itemName,
                volume: data.volume,
                stuff: "--min:0; --max:100; --step:1; --value:"+ data.volume +"; --text-value:"+ data.volume +";width: 100%;",
            });
        }

        if(data.type === "show"){
            App.visible = data.show;
            App.Close();
        }

        if(data.type === "notify"){
            sendAlert(data.message, data.style);
        }

        if(data.type === "UselessCallYeey"){
            $.post('https://rcore_piano/init', JSON.stringify(App.piano));
        }

        if(data.type === "copyclipboard"){
            $("#options_to_do").modal("hide");
            $("#new_name").modal("hide");
            $("#textboard").modal({ backdrop: 'static', keyboard: false});
            $(".textarea").val(data.string);
            App.freezeKeys = true;
        }

        if(data.type === "convertedMusic"){
            pageData = [];
            pageDataOctavia = [];
            pageNoteType = [];

            for (const pageNum in data.convertedMusic) {
                pageData[pageNum] = [];
                for (const noteNum in data.convertedMusic[pageNum]) {
                    pageData[pageNum][noteNum] = data.convertedMusic[pageNum][noteNum];
                }
            }

            for (const pageNum in data.convertedOctavias) {
                pageDataOctavia[pageNum] = [];
                for (const noteNum in data.convertedMusic[pageNum]) {
                    pageDataOctavia[pageNum][noteNum] = data.convertedOctavias[pageNum][noteNum];
                }
            }

            for (const pageNum in data.convertedTones) {
                pageNoteType[pageNum] = [];
                for (const noteNum in data.convertedMusic[pageNum]) {
                    pageNoteType[pageNum][noteNum] = data.convertedTones[pageNum][noteNum];
                }
            }

            App.timingNotes = data.time;
            App.pianoNotesOctaviaRecord = [...pageDataOctavia[0]];
            App.pianoNotesRecord = [...pageData[0]];
            App.pianoNoteTypeRecord = [...pageNoteType[0]]
        }

        if(data.type === "changekey"){
            for(var i = 0; i < App.piano.length; i ++){
                var dt = App.piano[i];
                if(dt.Part == data.part && dt.KeyNote == data.keyNote){
                    dt.BindKeyNote = data.keyCode;
                    SetCookie("piano-"+ data.keyNote +"-" + data.part, data.keyCode);
                    return;
                }
                if(dt.Part == data.part && dt.SharpNote == data.keyNote){
                    dt.BindKeySharpNote = data.keyCode;
                    SetCookie("piano-"+ data.keyNote +"-" + data.part, data.keyCode);
                    return;
                }
            }
        }

        if(data.type === "reset-note-type"){
            App.pianoNotesType = [];
            App.typeTone = "classic";
        }

        if(data.type === "addTone"){
            App.pianoNotesType.push({
                label: data.label,
                name: data.name,
                active: data.active,
                enabled: data.enabled,
            });
        }

        if(data.type === "reset-stored-music"){
            App.pianoPlayList = [];
            App.userSavedList = [];
        }

        if(data.type === "recordedmusic"){
            App.pianoPlayList.push({
                label: data.label,
                name: data.label,
            });
        }

        if(data.type === "reset-saved-notes"){
            App.userSavedList = [];
        }

        if(data.type === "userSavedList"){
            App.userSavedList.push({
                label: data.label,
                name: data.label,
            });
        }

        if(data.type === "resetkeysvisible"){
            for(var i = 0; i < App.piano.length; i ++){
                var dt = App.piano[i];
                dt.Active = false;
                dt.ActiveSharp = false;
            }
        }

        if(data.type === "highlightkey"){
            for(var i = 0; i < App.piano.length; i ++){
                var dt = App.piano[i];
                if(dt.KeyNote === data.note && dt.Part == data.Part){
                    dt.Active = true;
                    break;
                }
                if(dt.SharpNote === data.note && dt.Part == data.Part){
                    dt.ActiveSharp = true;
                    break;
                }
            }
        }
    });
});