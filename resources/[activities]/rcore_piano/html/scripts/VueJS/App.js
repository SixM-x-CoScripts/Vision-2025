var BlockKeyPiano = false;
var BlockColorKey = false;
var noteIndex = -1;
var newIndex = -1;
var TimerForPlayingMusic;
var page = -1;
var cachedPage = 0;
var MusicLabelFromClick = "";

var pageData = [];
var pageDataOctavia = [];
var pageNoteType = [];

var App = new Vue({
	el: '.container',
	data: {
		visible: "nothing",
		typeTone: "classic",
		selectedMusic: "",

        lang: lang["en"],

        closeUI: false,

        freezeKeys: false,

		keybindSettings: false,

        // dont use, wont work the way you think it will.
		debug: false,

		pageEx: 0,

		ActiveOctave: 1,

		octaviaList: [
		    {
		        octavia: 1,
		        active: true,
		    },
		    {
		        octavia: 2,
		        active: false,
		    },
		    {
		        octavia: 3,
		        active: false,
		    },
		    {
		        octavia: 4,
		        active: false,
		    },
		    {
		        octavia: 5,
		        active: false,
		    },
		    {
		        octavia: 6,
		        active: false,
		    },
		    {
		        octavia: 7,
		        active: false,
		    },
		],

		timingNotes: 300,

		pianoNotesType: [],

		pianoPlayList: [],

		userSavedList: [],

		instrumentsList: [],

		pianoNotesRecord: [],
		pianoNotesOctaviaRecord: [],
		pianoNoteTypeRecord: [],

		playingNoteFromRecord: [],

		isRecordedMusicPlaying: false,

        keyNotes: WhiteKeys,

        keySharpNotes: BlackKeys,

		piano: GetKeys(5, 6, 7),
    },
    mounted: function () {
        this.$nextTick(function () {
            for(var i = 0; i < 2; i ++) this.NextPage();
            for(var i = 0; i < 10; i ++) this.PrevPage();
            App.visible = "nothing";
        })
    },

	methods: {
	    UpOctave: function(){
	        this.ActiveOctave ++;
	        if(this.ActiveOctave == 2){
	            this.ActiveOctave = 1;
	        }

	        this.UpdateKeys(this.ActiveOctave);
	    },

	    DownOctave: function(){
	        this.ActiveOctave --;
	        if(this.ActiveOctave == -1){
	            this.ActiveOctave = 0;
	        }

	        this.UpdateKeys(this.ActiveOctave);
	    },

        UpdateKeys: function(number){
            if(number == 0){
                this.piano = GetKeys(2,3,4);
            }
            if(number == 1){
                this.piano = GetKeys(5,6,7);
            }
        },

	    ChangeVolume: function(){
            $.post('https://rcore_piano/showVolume', JSON.stringify({}));
	    },

	    UpdateText: function(selector, quantity){
            App.$nextTick(function () {
	            $("#" + selector).val(quantity).trigger("input");
            });
	    },

	    CloseFromVolumeManager: function(){
            $("#test").modal("hide");
            App.freezeKeys = false;
            if(this.closeUI == true){
	            $.post('https://rcore_piano/hide', JSON.stringify({}));
	        }
	        for (const val of this.instrumentsList) {
	            $.post('https://rcore_piano/setVolumeMusic', JSON.stringify({
	                name: val.itemName,
	                volume: parseInt($("#" + val.itemName).val()),
	            }));
            }
	    },

	    PickOctavia: function(data){
	        for(var i = 0; i < App.octaviaList.length; i ++){
	            App.octaviaList[i].active = false;
	        }
            data.active = true;
	    },

	    PickTypeTone: function(data){
	        for(var i = 0; i < App.pianoNotesType.length; i ++){
	            App.pianoNotesType[i].active = false;
	        }
            data.active = true;
	    },

	    Close: function(){
            App.freezeKeys = false;
            $("#options_to_do").modal("hide");
            $("#new_name").modal("hide");
            $("#textboard").modal("hide");
            $("#jsontext").modal("hide");
            $("#confirm_to_delete").modal("hide");
	    },

        ChangeName: function(){
            if($("#new_name_input").val().length >= 3){
                $.post('https://rcore_piano/changeName', JSON.stringify({
                    oldName: MusicLabelFromClick,
                    newName: $("#new_name_input").val(),
                }));
                this.Close();
                sendAlert(this.lang["changed_name_succ"]);
                }else{
                sendAlert(this.lang["minimum_letters"]);
            }
        },

        OpenModalForDelete: function(){
            $("#options_to_do").modal("hide");
            $("#confirm_to_delete").modal({ backdrop: 'static', keyboard: false});
        },

	    PickSavedMusic: function(piano){
	        this.selectedMusic = piano;
	        MusicLabelFromClick = piano;
	        $("#options_to_do").modal({ backdrop: 'static', keyboard: false});
	        App.freezeKeys = true;
	    },

        ClipboardLuaTableSheet: function(){
            $.post('https://rcore_piano/copycode', JSON.stringify({
                name: MusicLabelFromClick,
            }));
            App.freezeKeys = true;
        },

        ClipboardJsonTableSheet: function(){
            $.post('https://rcore_piano/copyjson', JSON.stringify({
                name: MusicLabelFromClick,
            }));
            App.freezeKeys = true;
        },

	    PlaySavedMusic: function(){
            $.post('https://rcore_piano/playPlayBack', JSON.stringify({
                music: MusicLabelFromClick,
            }));

            $("#options_to_do").modal("hide");
            App.freezeKeys = false;
            sendAlert(this.lang["changed_name_succ"].formatUnicorn(MusicLabelFromClick));
	    },

	    DeleteSavedMusic: function(){
            $.post('https://rcore_piano/deleteSavedMusic', JSON.stringify({
                musicName: MusicLabelFromClick,
            }));

            $("#options_to_do").modal("hide");
            $("#confirm_to_delete").modal("hide");
            App.freezeKeys = false;
	    },

        LoadJsonSheet: function(){
            $('#jsontext').on('hidden.bs.modal', function () {
                $.post('https://rcore_piano/loadMusicJson', JSON.stringify({
                    jsonSheet: $(".jsonarea").val(),
                }));
                App.visible = "record";
                App.$nextTick(function () {
                    App.freezeKeys = false;
                    $(".record_container").show();
                });
            });

            $("#jsontext").modal({ backdrop: 'static', keyboard: false});
            App.freezeKeys = true;
        },

	    EditSavedMusic: function(){
	        App.ScrapTemplate();
            $('#options_to_do').on('hidden.bs.modal', function () {
                App.visible = "record";
                App.$nextTick(function () {
                    App.freezeKeys = false;
                    $(".record_container").show();
                    $("#sheet_name").val(MusicLabelFromClick);
                });
            });
            App.freezeKeys = false;
            $("#options_to_do").modal("hide");
            App.StopPlayBack();

            $.post('https://rcore_piano/loadMusic', JSON.stringify({
                musicName: MusicLabelFromClick,
            }));
	    },

	    RenameSavedMusic: function(){
	        $("#options_to_do").modal("hide");
            $("#new_name").modal({ backdrop: 'static', keyboard: false});
            App.freezeKeys = true;
	    },

	    ChooseNote: function(PutNote, sharp, fast){
	        if(PutNote.active == true){
	            PutNote.active = false;
	            return;
	        }

	        if(fast != null){
                if(sharp){
                    SetKeyToPaper("", PutNote.Note);
                }else{
                    SetKeyToPaper(PutNote.Note, "");
                }
                $("#put_a_note").modal("hide");
                RefreshRecorder();
	            return;
	        }

	        if(sharp){
                for(var i = 0; i < this.keyNotes.length; i ++) this.keyNotes[i].active = false;
	        }else{
                for(var i = 0; i < this.keySharpNotes.length; i ++) this.keySharpNotes[i].active = false;
	        }

	        PutNote.active = true;
	    },

	    RemoveNoteFromRecorder: function(){
            SetKeyToPaper("", "");
            $("#put_a_note").modal("hide");
            RefreshRecorder();
	    },

	    EditRecordedNote: function(note){
	        noteIndex = note;
	        if(App.pianoNotesRecord[note] != null){
                for(var i = 0; i < this.keyNotes.length; i ++) this.keyNotes[i].active = false;
                for(var i = 0; i < this.keySharpNotes.length; i ++) this.keySharpNotes[i].active = false;
                for(var i = 0; i < this.pianoNotesType.length; i ++) App.pianoNotesType[i].active = false;
                for(var i = 0; i < this.octaviaList.length; i ++) App.octaviaList[i].active = false;

                var note = App.pianoNotesRecord[note] ?? "";
                var stripedNote = note.split(" ");

                if(note[0] != null){
                    stripedNote[0] = stripedNote[0].replace(" ", "");
                    for(var i = 0; i < this.keySharpNotes.length; i ++){
                        if(this.keySharpNotes[i].Note === stripedNote[0]){
                            this.keySharpNotes[i].active = true;
                            break;
                        }
                    }
                }

                if(note[1] != null){
                    stripedNote[1] = stripedNote[1].replace(" ", "");
                    for(var i = 0; i < this.keyNotes.length; i ++){
                        if(this.keyNotes[i].Note === stripedNote[1]){
                            this.keyNotes[i].active = true;
                            break;
                        }
                    }
                }

                for(var i = 0; i < App.pianoNotesType.length; i ++){
                    if(App.pianoNotesType[i].name === App.pianoNoteTypeRecord[noteIndex]){
                        App.pianoNotesType[i].active = true;
                        break;
                    }
                }

                for(var i = 0; i < App.octaviaList.length; i ++){
                    if(App.octaviaList[i].octavia == App.pianoNotesOctaviaRecord[noteIndex]){
                        App.octaviaList[i].active = true;
                        break;
                    }
                }
            }
	        $("#put_a_note").modal({ backdrop: 'static', keyboard: false});
	        App.freezeKeys = true;
	    },

        PutNote: function(){
            SetKeyToPaper();

	        RefreshRecorder();
	        $("#put_a_note").modal("hide");
        },

        SaveTemplate: function(){
            if($("#sheet_name").val().length >= 3){
                this.NextPage();
                this.PrevPage();

                $.post('https://rcore_piano/saveMusic', JSON.stringify({
                    notes: pageData,
                    octavia: pageDataOctavia,
                    noteType: pageNoteType,
                    time: App.timingNotes,
                    name: $("#sheet_name").val(),
                }));
                sendAlert(this.lang["template_saved"]);
                }else{
                sendAlert();
            }
        },

        ScrapTemplate: function(){
            ResetTemplate();
        },

        StopRecordedMusic: function(){
            if(TimerForPlayingMusic != null){
                clearInterval(TimerForPlayingMusic);
                newIndex = -1;
                cachedPage = 0;
            }
            this.isRecordedMusicPlaying = false;
            HideGreenNotes();
            RefreshRecorder();
        },

        PlayRecordedMusic: function(){
            var octavia = 1
            var numbers = 25
            var OctaviaNumber = 100 * octavia + (numbers * octavia)

            if(TimerForPlayingMusic != null){
                clearInterval(TimerForPlayingMusic);
            }

            this.isRecordedMusicPlaying = true;


            TimerForPlayingMusic = setInterval(function(){
                newIndex ++;
                HideGreenNotes();

                if(newIndex == numbers){
                    cachedPage ++;
                    newIndex = -1;

                    if(pageData[cachedPage] == null){
                        clearInterval(TimerForPlayingMusic);
                        newIndex = -1;
                        cachedPage = 0;

                        RefreshRecorder();
                        return;
                    }else{
                        App.NextPage(true);
                    }
                    RefreshRecorder();
                }

                PlayNoteFromPaper(numbers, newIndex)
                PlayNoteFromPaper(numbers, newIndex, 125)

                RefreshRecorder();
            }, App.timingNotes);

             RefreshRecorder();
        },

        NextPage: function(skipTimer){
            if(TimerForPlayingMusic != null && skipTimer == null){
                clearInterval(TimerForPlayingMusic);
                HideGreenNotes();
            }

            if(skipTimer == null){
                this.isRecordedMusicPlaying = false;
            }

            page++;
            if (pageData[page] == null)
            {
                if(page <= 0) {
                    pageData[page] = [...this.pianoNotesRecord];
                    pageDataOctavia[page] = [...this.pianoNotesOctaviaRecord];
                    pageNoteType[page] = [...this.pianoNoteTypeRecord];
                } else {
                    pageData[page - 1] = [...this.pianoNotesRecord];
                    pageDataOctavia[page - 1] = [...this.pianoNotesOctaviaRecord];
                    pageNoteType[page - 1] = [...this.pianoNoteTypeRecord];
                }
                this.pianoNotesRecord = [];
                this.pianoNotesOctaviaRecord = [];
                this.pianoNoteTypeRecord = [];
            }
            else
            {
                pageData[page - 1] = [...this.pianoNotesRecord];
                pageDataOctavia[page - 1] = [...this.pianoNotesOctaviaRecord];
                pageNoteType[page - 1] = [...this.pianoNoteTypeRecord];

                this.pianoNotesRecord = [...pageData[page]];
                this.pianoNotesOctaviaRecord = [...pageDataOctavia[page]];
                this.pianoNoteTypeRecord = [...pageNoteType[page]];
            }

            this.pageEx = page;
            RefreshRecorder();
        },

        PrevPage: function(){
            this.isRecordedMusicPlaying = false;
            if(TimerForPlayingMusic != null){
                clearInterval(TimerForPlayingMusic);
                HideGreenNotes();
            }

            if (page == -1 && page == 0) return;
            pageData[page] = [...this.pianoNotesRecord];
            pageDataOctavia[page] = [...this.pianoNotesOctaviaRecord];
            pageNoteType[page] = [...this.pianoNoteTypeRecord];

            page --;
            if(page <= 0) {
                page = 0;
            }
            this.pianoNotesRecord = [...pageData[page]];
            this.pianoNotesOctaviaRecord = [...pageDataOctavia[page]];
            this.pianoNoteTypeRecord = [...pageNoteType[page]];
            this.pageEx = page;

            RefreshRecorder();
        },

        BackToPiano: function(){
            App.visible = "none";
            if(TimerForPlayingMusic != null){
                clearInterval(TimerForPlayingMusic);
                HideGreenNotes();
            }
            this.$nextTick(() => {
                App.visible = "piano";
                $("#piano-bg").show();
            });
        },

        RecordMusic: function(){
            ResetTemplate();
            App.StopPlayBack();

            App.visible = "none";
            App.visible = "record";
            this.$nextTick(() => {
                RefreshRecorder();
                $(".record_container").show();
                App.freezeKeys = false;
            });
        },

	    StopPlayBack: function(){
            $.post('https://rcore_piano/stopPlayBack', JSON.stringify({}));
            for(var i = 0; i < App.piano.length; i ++){
                var data = App.piano[i];
                data.Active = false;
                data.ActiveSharp = false;
            }
            //sendAlert(this.lang["stop_playing_music"]);
            RefreshPiano();
	    },

	    PlayPlayback: function(name){
	        sendAlert(this.lang["started_playing"].formatUnicorn(name));
            $.post('https://rcore_piano/playPlayBack', JSON.stringify({
                music: name,
            }));
	    },

	    SetNewKeyBind: function(index, isSharp){
	        for(var i = 0; i < App.piano.length; i ++){
	            var data = App.piano[i];

	            data.RecordingKey = false;
                data.RecordingSharpKey = false;
	        }

            var data = App.piano[index];
            if(isSharp){
                data.RecordingSharpKey = true;
                }else{
                data.RecordingKey = true;
            }
	    },

        ChangeBindKeys: function(){
	        for(var i = 0; i < App.piano.length; i ++){
	            var data = App.piano[i];

	            data.RecordingKey = false;
                data.RecordingSharpKey = false;
	        }

            App.keybindSettings = !App.keybindSettings;
        },

		ChangeNoteSound: function(data){
		    App.typeTone = data.name;

		    for(var i = 0; i < this.pianoNotesType.length; i ++){
		        this.pianoNotesType[i].enabled = false;
		    }

		    data.enabled = true;
            $.post('https://rcore_piano/changeTypeTone', JSON.stringify({
                typeTone: data.name,
            }));
		},

        GetNoteFromLetter: function(note, octavia){
            for(var i = 0; i < App.piano.length; i ++){
                var data = App.piano[i];
                if(note === data.KeyNote && octavia == data.Part){
                    return i;
                }
                if(note === data.SharpNote && octavia == data.Part){
                    return i;
                }
            }
            return null;
        },

        SetNoteColorActive: function(index, value){
            if(BlockColorKey) return;
            var data = App.piano[index];
            data.Active = value;
            data.ActiveSharp = false;
        },

        SetSharpNoteColorActive: function(index, value){
            BlockColorKey = value;
            var data = App.piano[index];
            data.ActiveSharp = value;
            data.Active = false;
        },

		PlayPianoNote: function(index, octavia, toneType){
		    if(App.keybindSettings || this.freezeKeys) return;
			if(BlockKeyPiano == true){
				BlockKeyPiano = false;
				return;
			}

			var data = App.piano[index];

            if(App.debug){
                var audio = new Audio('./piano/classic/' + (octavia ?? data.Part) + "-" + (index ?? data.KeyNote)  + '.mp3');
                audio.volume = 0.1;
                audio.play();
                }else{
                if(data){
                    $.post('https://rcore_piano/playTone', JSON.stringify({
                         note: data.KeyNote,
                         typeTone: toneType ?? App.typeTone,
                         Octavia: data.Part,
                    }));
                }else{
                    $.post('https://rcore_piano/playTone', JSON.stringify({
                         note: index,
                         typeTone: toneType ?? App.typeTone,
                         Octavia: octavia,
                    }));
                }
            }
		},

		PlayPianoSharpNote: function(index, octavia, toneType){
		    if(App.keybindSettings || this.freezeKeys) return;
			var data = App.piano[index];
			BlockKeyPiano = true

            if(App.debug){
                var audio = new Audio('./piano/' + App.typeTone + '/' + (data.SharpNote.replace("#", "s")) + "_" + data.Part + '.wav');
                audio.play();
                }else{
                if(data){
                    $.post('https://rcore_piano/playTone', JSON.stringify({
                         note: data.SharpNote.replace("#", "s"),
                         typeTone: toneType ?? App.typeTone,
                         Octavia:  data.Part,
                    }));
                }else{
                    $.post('https://rcore_piano/playTone', JSON.stringify({
                         note: index.replace("#", "s"),
                         typeTone: toneType ?? App.typeTone,
                         Octavia: octavia,
                    }));
                }
            }
		},
	},
});