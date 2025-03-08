<template>
    <tr v-if="wagerAmountCommited || canSetWager">
        <td class='player-id'></td>
        <td class='player-name'>
            <div class="wager-left" v-if="!wagerAmountCommited">
                <label class="custom-checkbox">
                <input type="checkbox" @input="wagerEnabledChange">
                <span></span>
                <div class="wager-label">{{ translations.WAGER }}</div>
                </label>
                
            </div>
            <div class="wager-right" :style="{'visibility': wagerEnabled ? 'visible' : 'hidden'}" v-if="!wagerAmountCommited">
                $<input class="wager-amount" :value="wagerAmount" @input="wagerAmountChange" type="number" />
            </div>

            <div class="wager-center" v-if="wagerAmountCommited">
                <span v-html="translations.WAGER_SET_TO.format(wagerAmountCommited)"></span>
            </div>
        </td>
    </tr>
</template>


<script>
export default {
    computed: {
        translations() {
            return this.$store.state.translations;
        },
        canSetWager() {
            return this.$store.state.bowlingState.length == 0;
        },
        wagerEnabled() {
            return this.$store.state.wagerEnabled;
        },
        wagerAmount() {
            return this.$store.state.wagerAmount;
        },
        wagerAmountCommited() {
            return this.$store.state.wagerAmountCommited;
        }
    },
    methods: {
        wagerEnabledChange(e) {
            this.$store.commit('setWagerEnabled', e.target.checked);
            if(!e.target.checked) {
                this.$store.commit('setWagerAmount', null);
            }
        },
        wagerAmountChange(e) {
            this.$store.commit('setWagerAmount', e.target.value);
        }
    }
}
</script>


<style scoped>

    .wager-center {
        margin: 10px;
    }
    
    .wager-center span {
        border-bottom: 4px dashed var(--table-accent)
    }

    .wager-left {
        float: left;
        width: 100px;
        padding-left: 10px;
        position: relative;
    }


    .custom-checkbox {
        margin: 8px;
        position: absolute;
        left: 10px;
        top: 6px;
    }
    .custom-checkbox input {
        display: none;
    }

    .custom-checkbox span {
        background: var(--table-accent-lighter);
        border: 1px solid var(--table-accent);
        height: 20px;
        width: 20px;
        border-radius: 5px;
        cursor: pointer;
        display: flex;
        justify-content: center;
        align-items: center;
        color: black;
    }
    .wager-label {
        position: absolute;
        top: 2px;
        left: 25px;
    }

    .custom-checkbox input:checked + span:before {
    content: "✔";
    }

    .wager-right {
        float: right;
        width: 140px;
        font-size: 25px;
        margin-right: 5px;
        margin-top: 8px;
        margin-bottom: 8px;
    }

    .wager-right input {
        width: 100px;
        font-size: 25px;
        
        background: var(--table-accent-lighter);
        border: 1px solid var(--table-accent);
        margin-left: 3px;
        outline: none;
    }
    .wager-right input:focus {
        border: 1px solid #000000;

    }
</style>>