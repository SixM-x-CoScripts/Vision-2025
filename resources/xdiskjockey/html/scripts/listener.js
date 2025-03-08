/**
 * Return playing song if some playing
 * @returns {null|object}
 */
function getPlayingSong() {
    for (let i = 0; i < app.songs.length; i++) {
        if (app.songs[i].playing) {
            return app.songs[i];
        }
    }
    return null;
}

/**
 * Return song by label
 * @returns {null|number}
 */
function getSongByLabel(label) {
    for (let i = 0; i < app.songs.length; i++) {
        const song = app.songs[i];
        if (song.label == label) {
            return i;
        }
    }
    return null;
}

function sendAlert(msg, style = 'success') {
    $.notify({
        // options
        message: msg,
    }, {
        // settings
        type: style,
        showProgressbar: true,
        newest_on_top: true,
        animate: {
            enter: "animated bounceInRight",
            exit: "animated bounceOutRight",
        }
    });
}

var volume = 0.5;
var soundBoard = false;

function isInBoard() {
    return soundBoard;
}

function setInBoard(result) {
    soundBoard = result;
}

function stopMusic() {
    $.post('https://xdiskjockey/stopMusic', JSON.stringify({}));

    for (var i = 0; i < app.songs.length; i++) {
        app.songs[i].playing = false;
    }
}

function updatePositionVolume() {
    var top = 361;
    var bottom = 218;

    var result = (bottom - top) / 100 * (volume * 100);
    $("#volume_progress").css("top", (top + result) + "px");
}

function isInModal(){
    if(app.inModal){
        return true;
    }
    return false;
}

//Vue instance
var app = new Vue({
    el: '#app',
    data: {
        visible: false,
        page: 'songs', //pult, songs
        songRenderType: 'box', //box, line
        searchQuery: null,
        songs: [],
        inputName: null,
        inputSrc: null,
        editName: null,
        editSrc: null,
        validAddValues: null,
        validEditValues: false,
        editingSong: null,
        deleteSong: null,
        inModal: false,
        volume: 1
    },
    computed: {
        volumeStyle: function(){
            var top = 361;
            var bottom = 218;

            var result = (bottom - top) / 100 * (this.volume * 100);
            return {"top": (top + result) + "px"}
        }
    },
    methods: {
        play: function (song) {
            for (let i = 0; i < app.songs.length; i++) {
                app.songs[i].playing = false;
            }
            song.playing = true;
            $.post('https://xdiskjockey/playMusic', JSON.stringify({song: song.url}));
        },
        pause: function (song) {
            if (song.playing) {
                song.playing = false;
                $.post('https://xdiskjockey/stopMusic', JSON.stringify({}));
            }
        },
        setPage: function (pg) {
            this.page = pg;
            if (pg === "pult") setInBoard(true);
            else setInBoard(false);
        },
        stopMusic: function () {
            stopMusic();
        },
        openAddModal: function () {
            bootstrapValidate('#inputName', 'required|min:3:' + locales.wrongLabel, function (isValid) {
                app.validAddValues = isValid;

            });
            bootstrapValidate('#inputSrc', 'required|url:' + locales.notValidURL, function (isValid) {
                if(app.validAddValues == true){
                    app.validAddValues = isValid;
                }
            });
            this.inModal = true;
            $('#addSong').modal();
        },
        editSongModal: function (song) {
            bootstrapValidate('#editName', 'required|min:3:' + locales.wrongLabel, function (isValid) {
                app.validEditValues = isValid;
            });
            bootstrapValidate('#editSrc', 'required|url:' + locales.notValidURL, function (isValid) {
                app.validEditValues = isValid;
            });
            this.editName = song.label;
            this.editSrc = song.url;
            this.editingSong = song;
            this.inModal = true;
            $('#editSong').modal();
        },
        removeSongModal: function (song) {
            this.deleteSong = song;
            this.inModal = true;
            $('#removeSong').modal();
        },
        closeModal: function(){
            this.inModal = false;
        },
        removeSong: function () {
            const playingSong = getPlayingSong();
            if (playingSong != null) {
                if (playingSong.label === this.deleteSong.label) {
                    sendAlert(locales.songIsPlaying, 'danger')
                    return;
                }
            }

            if (this.deleteSong) {
                const songFind = getSongByLabel(this.deleteSong.label)
                if (songFind !== null) {
                    this.songs.splice(songFind, 1);
                }
            }

            var song = {
                label: this.deleteSong.label,
                url: this.deleteSong.url,
            }
            $.post('https://xdiskjockey/removeMusic', JSON.stringify(song));
            sendAlert(locales.deleted, 'success')
            this.deleteSong = null;
            this.inModal = false;
            $('#removeSong').modal('hide');
        },
        addSong: function () {
            const src = this.inputSrc;
            const name = this.inputName;

            if (this.validAddValues == true) {
                var song = {
                    label: name,
                    url: src,
                    playing: false,
                }

                this.songs.push(song);
                this.inputName = null;
                this.inputSrc = null;
                this.validAddValues = false;
                $.post('https://xdiskjockey/addMusic', JSON.stringify(song));

                sendAlert(locales.added, 'success')
                this.inModal = false;
                $('#addSong').modal('hide');
            } else {
                sendAlert(locales.dataAreNotCorret, 'danger')
                return
            }
        },
        editSong: function () {
            const src = this.editSrc;
            const name = this.editName;

            if (this.validEditValues) {
                var song = {
                    newLabel: this.editName,
                    newUrl: this.editSrc,

                    oldLabel: this.editingSong.label,
                    oldUrl: this.editingSong.url,
                }

                if (this.editingSong) {
                    this.editingSong.label = this.editName;
                    this.editingSong.url = this.editSrc;
                }
                this.editingSong = null;
                this.editName = null;
                this.editSrc = null;
                this.validEditValues = false;
                sendAlert(locales.edited, 'success')
                this.inModal = false;
                $('#editSong').modal('hide');

                $.post('https://xdiskjockey/editMusic', JSON.stringify(song));
            } else {
                sendAlert(locales.dataAreNotCorret, 'danger')
                return
            }
        },
        setRenderType: function (type) {
            this.songRenderType = type;
        },
        updateVolume: function (up) {
            let type = 'minus'
            if (up) {
                type = 'plus'
            }
            $.post('https://xdiskjockey/updateVolume', JSON.stringify({type: type}));
        }
    },
});

$(function () {
    window.addEventListener('message', function (event) {
        var item = event.data;
        if (item.type === "reset") {
            app.songs = [];
        }

        if (item.type === "playing") {
            for (let i = 0; i < app.songs.length; i++) {
                if (app.songs[i].url === item.url) {
                    app.songs[i].playing = true;
                }
            }
            volume = item.volume;
            updatePositionVolume();
        }

        if (item.type === "volume") {
            volume = item.volume;
            app.volume = item.volume;
            updatePositionVolume();
        }

        if (item.type === "add") {
            app.songs.push({
                label: item.label,
                url: item.url,
                playing: false,
            });
        }

        if (item.type === "ui") {
            if (item.status == true) {
                app.visible = true;
                app.setPage("pult")
                setInBoard(true);
            } else {
                app.visible = false;
            }
        }
    })

});

$(document).keyup(function (e) {
    if (e.key === "Escape") {
        if (isInBoard()) {
            $.post('https://xdiskjockey/exit', JSON.stringify({}));
            app.visible = false;
        } else {
            if(!isInModal()){
                setInBoard(true);
                app.setPage("pult")
            }
        }
    }
});
