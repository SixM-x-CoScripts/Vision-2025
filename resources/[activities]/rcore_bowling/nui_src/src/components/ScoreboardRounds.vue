<template>
    <tr>
        <td class='player-id'></td>
        <td class='player-name'>
            <span class="round-count-label">{{ translations.ROUND_COUNT }}</span>
            <span class="round-change" @click="decrease" v-if="canChangeRoundCount">-</span>
            <span class="round-number">{{ roundCount }}</span>
            <span class="round-change" @click="increase" v-if="canChangeRoundCount">+</span>
        </td>
    </tr>
</template>


<script>
export default {
    computed: {
        translations() {
            return this.$store.state.translations;
        },
        roundCount() {
            return this.$store.state.roundCount;
        },
        canChangeRoundCount() {
            return this.$store.state.bowlingState.length == 0;
        },
    },
    methods: {
        decrease() {
            if(this.$store.state.roundCount > 3) {
                this.$store.commit('decreaseRoundCount');
            }
        },
        increase() {
            if(this.$store.state.roundCount < 10) {
                this.$store.commit('increaseRoundCount');
            }
        }
    }
}
</script>


<style scoped>
    .round-change {
        background: var(--table-accent-lighter);
        border: 1px solid var(--table-accent);
        padding: 1px 5px;
        color: #000;
        margin: 5px;
        cursor: pointer;
    }

    .round-number {
        background: var(--table-header-bg);
        border: 1px solid var(--table-accent);
        color: white;
        padding: 5px 10px;
        width: 16px;
        display: inline-block;
    }

    .player-name {
        padding: 10px 10px;
    }

    .round-count-label {
        padding-right: 47px;
    }
</style>