var scoreBoard = new Vue({
    el: '#scoreboard',
    data: {
        visible: true,
        playerScoreList: [],
    },
})

function RefreshScoreBoard(){
    scoreBoard.visible = false;
    scoreBoard.playerScoreList = scoreBoard.playerScoreList.sort(function(a, b) {
        return b.score - a.score
    });
    scoreBoard.visible = true;
}

$(function(){
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type === "visible"){
            for(var i = 0; i < scoreBoard.playerScoreList.length; i ++){
                var data = scoreBoard.playerScoreList[i];
                if(data.source == item.source){
                    data.visible = item.status;
                    break;
                }
            }
        }

        if(item.type === "update"){
            var data = scoreBoard.playerScoreList;
            var index = -1;
            var found = false;
            for(var i = 0; i < data.length; i ++){
                if(data[i].source == item.source){
                    index = i;
                    found = true;
                    break;
                }
            }
            if(found){
                scoreBoard.playerScoreList[index] = {
                    name: item.name,
                    score: item.score,
                    you: item.you,
                    source: item.source,
                    visible: true,
                }
                }else{
                scoreBoard.playerScoreList.push({
                    name: item.name,
                    score: item.score,
                    you: item.you,
                    source: item.source,
                    visible: true,
                });
            }
        }

        if(item.type === "refresh"){
            RefreshScoreBoard()
        }

        if(item.type === "clear"){
            scoreBoard.playerScoreList = [];
        }
	})
});