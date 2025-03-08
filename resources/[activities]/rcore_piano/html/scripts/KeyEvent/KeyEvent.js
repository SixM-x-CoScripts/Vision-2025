function OnKeyDown(keyCode){
    if(App.keybindSettings) {
		for(var i = 0; i < App.piano.length; i ++){
			var data = App.piano[i];
			if(data.RecordingKey == true){
				data.BindKeyNote = keyCode;
                $.post('https://rcore_piano/saveBind', JSON.stringify({
                     KeyNote: data.KeyNote,
                     Part: data.Part,
                     keyCode: keyCode,
                }));
                SetCookie("piano-" + data.KeyNote + "-" + data.Part, keyCode);
				App.ChangeBindKeys();
			    return;
			}
			if(data.RecordingSharpKey == true){
                data.BindKeySharpNote = keyCode;
                $.post('https://rcore_piano/saveBind', JSON.stringify({
                     KeyNote: data.SharpNote,
                     Part: data.Part,
                     keyCode: keyCode,
                }));
                SetCookie("piano-"+ data.KeyNote +"-" + data.Part, keyCode);
                App.ChangeBindKeys();
			    return;
			}
		}
        return;
    }

	if(App.visible === "piano" && !App.freezeKeys){
		for(var i = 0; i < App.piano.length; i ++){
			var data = App.piano[i];
			if(keyCode == data.BindKeyNote){
				App.PlayPianoNote(i);
				BlockKeyPiano = false;
				data.Active = true;
				break;
			}
			if(keyCode == data.BindKeySharpNote){
				App.PlayPianoSharpNote(i);
				BlockKeyPiano = false;
				data.ActiveSharp = true;
				break;
			}
		}
	}
}

function OnKeyRelease(keyCode){
    if(keyCode == 27){
        if(App.freezeKeys == false){
            if(App.visible !== "piano"){
                App.visible = "piano";
                return;
            }
            $.post('https://rcore_piano/hidenui', JSON.stringify({}));
            App.Close();
        }
        return;
    }
    if(keyCode == 37){ // left arrow
        App.DownOctave();
        return;
    }
    if(keyCode == 39){ // right arrow
        App.UpOctave();
        return;
    }
	if(App.visible === "piano"){
		for(var i = 0; i < App.piano.length; i ++){
			var data = App.piano[i];
			if(keyCode == data.BindKeyNote){
                data.Active = false;
                SendDataNoteReleased(data);
				break;
			}
			if(keyCode == data.BindKeySharpNote){
                data.ActiveSharp = false;
                SendDataNoteReleased(data);
				break;
			}
		}
	}
}

function SendDataNoteReleased(data){
    $.post('https://rcore_piano/onKeyReleased', JSON.stringify({
        note: data.KeyNote,
        typeTone: App.typeTone,
        Octavia: data.Part,
    }));
}