<template>

    <tr>
        <td class='player-id'>{{ id + 1 }}</td>
        <td class='player-name'><span class='current-turn' v-if="currentTurnName == name">&gt;</span> {{ name }}</td>
        <td v-for="(item, index) in computedScore" 
            :key="index + '_' + (item[0] ? item[0] : '-1') + '_' + (item[1] ? item[1] : '-1') + (item[2] ? item[2] : '-1')" 
            :class="{'score-column': true, 'first-column': index == 0, 'last-column': index == roundCountIndex}"
        >
            <div class="windows">
                <template v-if="index == roundCountIndex">
                    <div class="window">
                        {{ finalThrowFormat(item, 2) }}
                    </div>
                    <div class="window">
                        {{ finalThrowFormat(item, 1) }}
                    </div>
                    <div class="window">
                        {{ finalThrowFormat(item, 0) }}
                    </div>
                </template>
                <template v-else>
                    <div class="window">
                        {{ formatSecondThrow(item) }}
                    </div>
                    <div class="window">
                        {{ formatFirstThrow(item) }}
                    </div>

                </template>
                <div style="clear: both"></div>
            </div>

            <span class='round-score'>
                {{ item[3] !== undefined ? item[3] : ''}}
            </span>
        </td>
        
        <td class='score-column column-total'>
            {{ (computedScore[roundCountIndex] && computedScore[roundCountIndex][3] !== undefined) ? computedScore[roundCountIndex][3] : '' }}
        </td>
    </tr>
</template>

<script>
export default {
    props: ['name', 'score', 'id'],
    methods: {
        formatFirstThrow(item) {
            if(item[0] === undefined) {
                return '';
            }

            if(item[0] == 10) {
                return '';
            }

            return item[0];
        },
        formatSecondThrow(item) {
            if(item[0] === undefined || item[0] === null) {
                return '';
            }

            if(item[1] === undefined || item[1] === null) {
                if(item[0] == 10) {
                    return 'x';
                }

                return '';
            }

            if((item[0] + item[1]) == 10) {
                return '/';
            }

            return item[1];
        },
        finalThrowFormat(input, idx) {
            if(input[idx] === undefined) {
                return '';
            }

            if(idx == 1 && (input[idx] + input[idx-1]) == 10) {
                return '/';
            }

            if(input[idx] == 10) {
                return 'x';
            }

            return input[idx];

        }
    },
    computed: {
        currentTurnName() {
            return this.$store.state.currentTurnName;
        },
        computedScore() {
            let finalScore = this.score;

            for(let i = 0; i < this.$store.state.roundCount; i++) {
                if(!finalScore[i]) {
                    finalScore.push([]);
                }
            }

            return finalScore;
        },
        roundCountIndex() {
            return this.$store.state.roundCount - 1;
        }
    }
}
</script>

<style scoped>
    .player-id {
        text-align: center;
        vertical-align: middle;
        background: var(--table-bg);
    }
    .player-name {
        vertical-align: middle;
    }

    .current-turn {
        font-size: 30px;
        position: relative;
        line-height: 0px;
        top: 4px;
    }
</style>