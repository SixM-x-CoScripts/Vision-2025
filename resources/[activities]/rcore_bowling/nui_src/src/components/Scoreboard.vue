<template>
    <div class="scoreboard">
        <table>
            <img class='img-black-icon' src="../../public/iconblack.png" />
            <img class='img-blue-icon' src="../../public/iconblue.png" />
            <img class='img-orange-icon' src="../../public/iconorange.png" />
            <img class='img-purple-icon' src="../../public/iconpurple.png" />
            <img class='img-red-icon' src="../../public/iconred.png" />
            <tr>
                <th style="border-right: 0; width: 28px;"></th>
                <th style="border-left: 0; padding: 0 10px; min-width: 100px;">{{ isTeamplay ? translations.TEAM : translations.PLAYER }}</th>

                <template v-if="!editMode">
                    <th v-for="index in roundCount" 
                        :key="index"  
                        :class="{'score-column': true, 'first-column': index == 1, 'last-column': index == roundCount}">
                        {{ index }}
                    </th>
                </template>
                <th v-if="!editMode" class='score-column column-total'>{{ translations.TOTAL }}</th>
            </tr>

            <template v-if="!editMode">
                <scoreboard-line 
                    v-for="(score, idx) in bowlingState"
                    :key="score.Name"
                    :name="score.Name"
                    :score="score.Throws"
                    :id="idx" />
            </template>

            <template v-if="editMode">
                <scoreboard-wager v-if="allowBets" />
                <scoreboard-rounds />
                <scoreboard-line-input 
                    v-for="score in bowlingState"
                    :key="score.Name"
                    :name="score.Name"
                    :server-id="score.ServerId"
                    :is-registered="isRegistered"
                    :players="score.Players" />
            
                <scoreboard-line-input v-if='!isRegistered' :is-teamplay="isTeamplay" />
                <scoreboard-line-control />
            </template>
        </table>

        <div class="result" v-if="secondsTillClose">
            <template v-if="wagerAccumulated && wagerAccumulated > 0">
                {{ translations.MATCH_WHO_WON.format(winnerName, wagerAccumulated) }}<br>{{ translations.MATCH_END.format(secondsTillClose) }}
            </template>
            
            <template v-if="!wagerAccumulated || wagerAccumulated == 0">
                {{ translations.MATCH_END.format(secondsTillClose) }}
            </template>
        </div>
    </div>
</template>

<script>
import ScoreboardLine from './ScoreboardLine.vue';
import ScoreboardLineInput from './ScoreboardLineInput.vue';
import ScoreboardLineControl from './ScoreboardLineControl.vue';
import ScoreboardWager from './ScoreboardWager.vue';
import ScoreboardRounds from './ScoreboardRounds.vue';

export default {
    components: {
        ScoreboardLine,
        ScoreboardLineInput,
        ScoreboardLineControl,
        ScoreboardWager,
        ScoreboardRounds,
    },
    computed: {
        allowBets() {
            return this.$store.state.allowBets;
        },
        translations() {
            return this.$store.state.translations;
        },
        winnerName() {
            let topScore = -1
            let topName = ''

            for(let player of this.$store.state.bowlingState) {
                let curTotalScore = player.Throws[player.Throws.length-1][3]
                if(curTotalScore > topScore) {
                    topScore = curTotalScore
                    topName = player.Name
                }
            }
            return topName;
        },
        wagerAccumulated() {
            return this.$store.state.wagerAccumulated;
        },
        secondsTillClose() {
            return this.$store.state.timeleft;
        },
        isTeamplay() {
            return this.$store.state.isTeamMode;
        },
        editMode() {
            return this.$store.state.editMode;
        },
        bowlingState() {
            return this.$store.state.bowlingState;
        },
        isRegistered() {
            for(let player of this.$store.state.bowlingState) {
                if(player.ServerId) {
                    if(player.ServerId == this.$store.state.serverId) {
                        return true;
                    }
                } else {
                    for(let serverId of player.Players) {
                        if(serverId == this.$store.state.serverId) {
                            return true;
                        }
                    }
                }
            }

            return false;
        },
        roundCount() {
            return this.$store.state.roundCount;
        }
    }
}
</script>

<style>
    .result {
        width: 220px;
        margin: 10px auto 0 auto;
        padding: 10px;
        text-align: center;

        background: var(--table-header-bg);
        border: 2px solid var(--table-border-color);

    }

    .black-icon .scoreboard table > img.img-black-icon {
        display: block;
    }
    
    .blue-icon .scoreboard table > img.img-blue-icon {
        display: block;
    }
    
    .orange-icon .scoreboard table > img.img-orange-icon {
        display: block;
    }
    
    .purple-icon .scoreboard table > img.img-purple-icon {
        display: block;
    }
    
    .red-icon .scoreboard table > img.img-red-icon {
        display: block;
    }

    .scoreboard table {
        position: relative;
    }

    .scoreboard table > img {
        display: none;
        position: absolute;
        top: -30px;
        left: -30px;
        width: 80px;
    }

    .scoreboard table {
        margin: 0 auto;
        border-spacing: 0;
    }

    .scoreboard table {
        background: var(--table-header-bg);
        border: 4px solid var(--table-border-color);
        border-radius: 20px;
    }

    .scoreboard th {
        background: var(--table-header-bg);
    }

    .scoreboard th, td {
        border: 1px solid var(--table-border-color);
    }

    .scoreboard tr th:last-child {
        border-top-right-radius: 20px;
    }

    .scoreboard tr:last-child td:first-child {
        border-bottom-left-radius: 20px;
    }

    .scoreboard tr:last-child td:last-child {
        border-bottom-right-radius: 20px;
    }

    .scoreboard table tr th {
        border-left: 1px solid var(--table-header-border-color);
    }
    
    .scoreboard table tr th:nth-child(3) {
        border-left: 3px solid var(--table-header-border-color);
    }

    .score-column {
        width: 40px;
        height: 40px;
        position: relative;
        background: var(--table-bg);
    }

    .score-column.last-column {
        width: 62px;
        height: 40px;
    }

    .scoreboard table td {
        vertical-align: bottom;
        text-align: center;
    }

    .scoreboard table .window {
        width: 20px;
        height: 20px;
        border-left: 1px solid var(--table-border-color);
        border-bottom: 1px solid var(--table-border-color);
        float: right;
        font-size: 80%;
        line-height: 20px;
        vertical-align: middle;
    }
    
    .scoreboard table .window:nth-child(2) {
        border-left: 0;
        border-bottom: 0;
    }
    
    .scoreboard table .last-column .window:nth-child(2) {
        border-left: 1px solid var(--table-border-color);
        border-bottom: 1px solid var(--table-border-color);
    }
    
    .scoreboard table .last-column .window:nth-child(3) {
        border-left: 0;
        border-bottom: 0;
    }

    .scoreboard table td {
        padding: 0;
    }

    .round-score {
        display: inline-block;
        padding: 5px;
    }

    .first-column {
        border-left: 2px solid var(--table-border-color);
    }

    .scoreboard table tr .column-total {
        vertical-align: middle;
        padding: 5px;
    }

    .scoreboard table tr td.column-total {
        font-size: 140%;
    }


    .player-name {
        min-width: 120px;
        padding: 0 10px 0 10px;
        vertical-align: middle;
        background: var(--table-bg);
    }

    .windows {
        position: absolute;
        top: 0;
        right: 0;
    }


    .score-column.controls-column {
        padding: 5px 15px;
        vertical-align: middle;
    }

    .player-name button {
        height: 40px;
        position: relative;
        top: -1px;
        background: var(--table-header-bg);
        border: 1px solid var(--table-accent);
        color: white;
        padding: 4px 8px;
    }

    .player-name button[disabled] {
        background: rgb(46, 46, 46);
    }

</style>