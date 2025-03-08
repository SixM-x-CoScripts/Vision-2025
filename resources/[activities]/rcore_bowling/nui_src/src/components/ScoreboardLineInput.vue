<template>

    <tr>
        <td class='player-id'></td>
        <td class='player-name' v-if="name">
            <button @click="joinTeam(name)" class="join-team" v-if="!isRegistered && isTeamGame">{{ translations.JOIN }}</button>

            {{ name }}

            <template v-if="serverId">
                #{{ serverId }}
                <button v-if="isOwner && serverId != ownerServerId" @click="removePlayer(serverId)" class="remove-player">x</button>
            </template>
            
            <span v-if="players" style="font-size: 80%">
                (<span v-for="(serverId,index) in players" :key="serverId">#{{ serverId }}<span v-if="index != players.length - 1">, </span><button v-if="isOwner && serverId != ownerServerId" @click="removePlayer(serverId)" class="remove-player">x</button></span>)
            </span>
            
        </td>
        <td class='player-name' v-if="!name">
            <input :placeholder="isTeamplay ? translations.TEAM_NAME : translations.YOUR_NAME" v-model="inputName"/>
            <button @click="register" :disabled="isDisabled">{{ translations.REGISTER }}</button>

        </td>
    </tr>
</template>

<script>
    import {apiRegister, apiRemovePlayer} from '../api.js';

    export default {
        props: ['name', 'isTeamplay', 'serverId', 'players', 'isRegistered'],
        data() {
            return {
                inputName: '',
            }
        },
        computed: {
            translations() {
                return this.$store.state.translations;
            },
            isDisabled() {
                for(let player of this.$store.state.bowlingState) {
                    if(player.name == this.inputName) {
                        return true;
                    }
                }

                return this.inputName.trim().length == 0;
            },
            ownerServerId() {
                return this.$store.state.serverId
            },
            isOwner() {
                return this.$store.state.isOwner;
            },
            isTeamGame() {
                return this.$store.state.isTeamMode;
            }
        },
        methods: {
            register() {
                if(this.inputName.trim().length > 0) {
                    this.$store.commit('naiveAddPlayer', this.inputName);
                    apiRegister(this.inputName);
                }
            },
            joinTeam(name) {
                apiRegister(name);
            },
            removePlayer(serverId) {
                this.$store.commit('removePlayer', serverId);
                apiRemovePlayer(serverId)
            }
        }
    }
</script>

<style scoped>
    .player-name {
        padding: 5px 15px 5px 15px;
    }

    .player-name input {
        font-size: 16px;
        padding: 10px;
        outline: 0;
        background: var(--table-accent-lighter);
        border: 1px solid var(--table-accent);
        border-radius: 5px;
        border-right: 0;
        border-top-right-radius: 0;
        border-bottom-right-radius: 0;
    }


    button.remove-player {
        background: rgb(167, 18, 18);
        color: white;
        width: auto;
        height: 23px;
        width: 20px;
        line-height: 20px;
        padding: 0;
    }
    
    button.join-team {
        background: var(--table-header-bg);
        border: 1px solid var(--table-accent);
        color: white;
        width: auto;
        height: 23px;
        line-height: 20px;
        padding: 0 5px;
    }

    button {
        cursor: pointer;
    }
</style>