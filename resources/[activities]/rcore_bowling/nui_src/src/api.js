import * as $ from "jquery";
import store from './store/index'


export function apiClose() {
    store.commit('hideBowling');
    $.post("https://rcore_bowling/close");
}

export function apiRegister(playerName) {
    $.post(
        "https://rcore_bowling/register",
        JSON.stringify({
            name: playerName,
            isTeamGame: store.state.isTeamMode,
            wager: store.state.wagerEnabled ? store.state.wagerAmount : null,
            roundCount: store.state.roundCount,
        })
    );
}

export function apiStart() {
    setTimeout(function() {
        store.commit('hideBowling');
    }, 1500);
    $.post("https://rcore_bowling/start");
}

export function apiRemovePlayer(serverId) {
    $.post(
        "https://rcore_bowling/removePlayer",
        JSON.stringify({
            serverId: serverId,
        })
    );
}

