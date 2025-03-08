import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        isTeamMode: false,
        isOwner: false,
        serverId: null,
        editMode: true,
        totalRounds: 5,
        isShown: false,
        timeleft: null,
        wagerEnabled: false,
        wagerAmount: null,
        wagerAmountCommited: null,
        wagerAccumulated: null,
        currentTurnName: null,
        roundCount: 10,
        hideStart: false,
        allowBets: true,
        translations: {
            TOTAL: "Total",
            MATCH_END: "Match ends in {0} seconds",
            MATCH_WHO_WON: "{0} won ${1}",
            START: "Start",
            CLOSE: "Close",
            JOIN: "Join",
            REGISTER: "Register",
            WAGER: "Wager",
            WAGER_SET_TO: "Wager is set to <b>${0}</b>"
        },
        bowlingState: [
            // {
            //     Name: 'John',
            //     ServerId: 1,
            //     Throws: [
            //         [2, 4],
            //         [4, 6],
            //         [1, 4],
            //         [10],
            //         [2, 2]
            //     ]
            // },
        ]
    },
    mutations: {
        setAllowBets(state, s) {
            Vue.set(state, 'allowBets', s);
        },
        setHideStart(state, s) {
            Vue.set(state, 'hideStart', s);
        },
        increaseRoundCount(state) {
            Vue.set(state, 'roundCount', state.roundCount + 1);
        },
        decreaseRoundCount(state) {
            Vue.set(state, 'roundCount', state.roundCount - 1);
        },
        setRoundCount(state, c) {
            Vue.set(state, 'roundCount', c);
        },
        setTranslations(state, t) {
            Vue.set(state, 'translations', t);
        },
        setTimeleft(state, time) {
            Vue.set(state, 'timeleft', time);
        },
        setCurrentTurnName(state, name) {
            Vue.set(state, 'currentTurnName', name);
        },
        setWagerEnabled(state, en) {
            Vue.set(state, 'wagerEnabled', en);
        },
        setWagerAmount(state, amt) {
            Vue.set(state, 'wagerAmount', amt);
        },
        setWagerAmountCommited(state, amt) {
            Vue.set(state, 'wagerAmountCommited', amt);
        },
        setWagerAccumulated(state, amt) {
            Vue.set(state, 'wagerAccumulated', amt);
        },
        setModePlayers(state) {
            Vue.set(state, 'isTeamMode', false);
        },
        setModeTeams(state) {
            Vue.set(state, 'isTeamMode', true);
        },
        setIsOwner(state, isOwner) {
            Vue.set(state, 'isOwner', isOwner);
        },
        setServerId(state, serverId) {
            Vue.set(state, 'serverId', serverId)
        },
        naiveAddPlayer(state, playerName) {
            state.bowlingState.push({
                Name: playerName,
                ServerId: state.serverId,
                Throws: []
            })
        },
        updateState(state, data) {
            Vue.set(state, 'bowlingState', data);
        },
        removePlayer(state, serverId) {
            Vue.set(state, 'bowlingState', state.bowlingState.filter((score) => {
                return score.ServerId != serverId;
            }))
        },
        setEditMode(state, editMode) {
            Vue.set(state, 'editMode', editMode);
        },
        showBowling(state) {
            Vue.set(state, 'isShown', true);
        },
        hideBowling(state) {
            Vue.set(state, 'isShown', false);
        },
    },
    actions: {
    },
    modules: {
    }
})
