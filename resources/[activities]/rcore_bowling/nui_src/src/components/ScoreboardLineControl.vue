<template>
    <tr v-if="!hideStart">
        <td class='player-id'></td>
        <td class='player-name'>
            <button v-if="isOwner && canStart" @click='start'>{{ translations.START }}</button>
            <button v-if="isOwner && !canStart" disabled>{{ translations.START }}</button>
            <button @click='close'>{{ translations.CLOSE }}</button>
        </td>
    </tr>
</template>

<script>
    import {apiClose, apiStart} from '../api.js';

    export default {
        props: [],
        methods: {
            close() {
                apiClose();
            },
            start() {
                this.$store.commit('setEditMode', false);
                apiStart();
            }
        },
        computed: {
            hideStart() {
                return this.$store.state.hideStart;
            },
            translations() {
                return this.$store.state.translations;
            },
            canStart: function() {
                return this.$store.state.bowlingState.length > 0;
            },
            isOwner: function() {
                return this.$store.state.isOwner;
            }
        }
    }
</script>

<style scoped>
    .player-name {
        padding: 5px 15px 5px 15px;
    }

    .player-name button:first-child {
        margin-right: 10px;
    }
    .player-name button {
        width: 100px;
        cursor: pointer;
    }

</style>