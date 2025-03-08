<template>
    <div id="app" :class="{'app-closed': !isShown, 'app-visible': isShown}">
        <scoreboard />
    </div>
</template>

<script>
    import Scoreboard from './components/Scoreboard';
    import {apiClose} from './api.js';
    import * as $ from "jquery";
    import {Howl, Howler} from 'howler';

    String.prototype.format = function() {
        var args = arguments;
        return this.replace(/{(\d+)}/g, function(match, number) { 
        return typeof args[number] != 'undefined'
            ? args[number]
            : match
        ;
        });
    };

    function rand(sounds) {
        return sounds[Math.floor(Math.random() * Math.floor(sounds.length))];
    }

    export default {
        name: 'App',
        components: {
            Scoreboard,
        },
        computed: {
            isShown() {
                return this.$store.state.isShown;
            }
        },
        data() {
            return {
                audioPlayer: null,
                rollSounds: {},
            };
        },
        mounted() {
            window.addEventListener("message", this.onEvent);
            // this.show();

            $(window).on("keyup", function(e) {
                if (e.which == 113 || e.which == 27) {
                    e.preventDefault();
                    apiClose();
                }
            });

            
            this.audioPlayer = new Howl({
                src: ["/assets/bowling.ogg"],
                sprite: {
                    small_1: [0, 609],
                    small_2: [1222, 1850 - 1222],
                    small_3: [2241, 3033 - 2241],
                    small_4: [3582, 4160 - 3582],
                    small_5: [4814, 5546 - 4814],
                    small_6: [6268, 7198 - 6268],
                    big_1: [7666, 8233 - 7666],
                    big_2: [8314, 8823 - 8314],
                    big_3: [8907, 9442 - 8907],

                    roll: [9612, 10174 - 9612, true],

                    reset_lowered: [10218, 10829 - 10218],
                    wipe_pins: [10867, 11989 - 10867],
                }
            });

            this.audioPlayer.pannerAttr({
              coneInnerAngle: 360,
              coneOuterAngle: 360,
              coneOuterGain: 0,
              maxDistance: 10000,
              panningModel: 'HRTF',
              refDistance: 0.8,
              rolloffFactor: 0.5,
              distanceModel: 'linear',
            });
        },
        beforeDestroy() {
            window.removeEventListener("message", this.onEvent);
        },
        methods: {
            countdownTimeleft(secs) {
                if(!this.$store.state.timeleft || secs < 30) {
                    this.$store.commit('setTimeleft', secs);

                    if(secs > 1) {
                        setTimeout(() => {
                            this.countdownTimeleft(secs - 1);
                        }, 1000);
                    } else {
                        apiClose();
                    }
                }
            },
            onEvent(event) {
                if (event.data.type == "setupPlayers") {
                    if(!event.data.isTeamGame) {
                        this.$store.commit('setModePlayers');
                    } else {
                        this.$store.commit('setModeTeams');
                    }

                    this.$store.commit('updateState', event.data.data);
                    this.$store.commit('setTranslations', event.data.translations);
                    
                    
                    if(event.data.gameState == 'playing') {
                        this.$store.commit('setEditMode', false);
                    } else if(event.data.gameState == 'finished') {
                        this.countdownTimeleft(30);
                    } else {
                        this.$store.commit('setEditMode', true);
                    }

                    this.$store.commit('setHideStart', false);
                    this.$store.commit('setAllowBets', event.data.allowBets);
                    this.$store.commit('setRoundCount', event.data.roundCount);
                    this.$store.commit('setTimeleft', null);
                    this.$store.commit('setWagerEnabled', false);
                    this.$store.commit('setWagerAmount', null);
                    this.$store.commit('setWagerAmountCommited', event.data.wager);
                    this.$store.commit('setServerId', event.data.serverId);
                    this.$store.commit('setIsOwner', true);
                    this.show();
                } else if(event.data.type == 'update') {
                    this.$store.commit('setHideStart', event.data.hideStart || false);
                    this.$store.commit('setRoundCount', event.data.roundCount);
                    this.$store.commit('updateState', event.data.data);
                    this.$store.commit('setWagerAmountCommited', event.data.wager);
                    this.$store.commit('setWagerAccumulated', event.data.wagerAccumulated);
                    this.$store.commit('setCurrentTurnName', event.data.currentTurnName);

                    if(event.data.gameState == 'playing') {
                        if(this.$store.state.editMode) {
                            setTimeout(() => {
                                apiClose();
                            }, 2000);
                        }

                        this.$store.commit('setEditMode', false);
                    } else if(event.data.gameState == 'finished') {
                        this.countdownTimeleft(30);
                    } else {
                        this.$store.commit('setEditMode', true);
                    }

                } else if(event.data.type == 'openJoin') {
                    if(!event.data.isTeamGame) {
                        this.$store.commit('setModePlayers');
                    } else {
                        this.$store.commit('setModeTeams');
                    }

                    if(event.data.gameState == 'playing') {
                        this.$store.commit('setEditMode', false);
                    } else if(event.data.gameState == 'finished') {
                        this.countdownTimeleft(30);
                    } else {
                        this.$store.commit('setEditMode', true);
                    }

                    this.$store.commit('setHideStart', false);
                    this.$store.commit('setAllowBets', event.data.allowBets);
                    this.$store.commit('setRoundCount', event.data.roundCount);
                    this.$store.commit('setTranslations', event.data.translations);
                    this.$store.commit('setTimeleft', null);
                    this.$store.commit('setWagerAmountCommited', event.data.wager);
                    this.$store.commit('setServerId', event.data.serverId);
                    this.$store.commit('updateState', event.data.data);
                    this.$store.commit('setIsOwner', false);
                    this.show();
                } else if (event.data.type == "showui") {
                    this.show();
                } else if (event.data.type == "hideui") {
                    this.hide();
                } else if (event.data.type == "unsetplayers") {
                    this.$store.commit('updateState', []);
                } else if (event.data.type == "playSound") {
                  var id = this.audioPlayer.play(rand(event.data.sounds));
                  this.audioPlayer.pos(event.data.position.x, event.data.position.y, event.data.position.z, id);
                  this.audioPlayer.volume(event.data.volume, id);
                } else if (event.data.type == "setOrientation") {
                    Howler.orientation(event.data.fwd.x, event.data.fwd.y, event.data.fwd.z, event.data.up.x, event.data.up.y, event.data.up.z);
                    Howler.pos(event.data.coord.x, event.data.coord.y, event.data.coord.z)
                } else if (event.data.type == "playSoundBall") {
                  var rollId = this.audioPlayer.play(rand(event.data.sounds));
                  this.audioPlayer.pos(event.data.position.x, event.data.position.y, event.data.position.z, rollId);
                  this.audioPlayer.volume(event.data.volume, rollId);

                  this.rollSounds[event.data.throwId] = rollId;
                } else if (event.data.type == "stopSoundBall") {
                    this.audioPlayer.stop(this.rollSounds[event.data.throwId]);
                }
            },
            show() {
                this.$store.commit('showBowling');
                // document.body.style.display = "block";
            },
            hide() {
                this.$store.commit('hideBowling');
                // document.body.style.display = "none";
            },
        }
    }
</script>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap');
    

    body {
        background: url('../public/bg.jpg')
    }

    #app {
        user-select: none;
        font-family: 'Fira Sans', sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        margin-top: 60px;
        color: white;
        transition: opacity 0.3s ease-out;
    }

    .app-closed {
        opacity: 0;
    }

    .app-visible {
        opacity: 1;
    }

</style>
