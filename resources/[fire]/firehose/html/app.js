var colorInc = 100 / 3;
var currentProgress = 100;
setProgress(currentProgress)

function setProgress(val) {
    if (val >= 0 && val <= 100) {
        //Progress Bar Animation Code From https://codepen.io/junebug12851/pen/mJZNqN
        var valOrig = val;
        currentProgress = val;
        val = 100 - val;

        $(".progress").parent().removeClass();
        $(".progress .water").css("top", val + "%");
        if (valOrig < colorInc * 1)
            $(".progress").parent().addClass("red");
        else if (valOrig < colorInc * 2)
            $(".progress").parent().addClass("orange");
        else
            $(".progress").parent().addClass("green");
    } else {
        $(".progress").parent().removeClass();
        $(".progress").parent().addClass("green");
        $(".progress .water").css("top", 0 + "%");
        $(".progress .percent").text(100 + "%");
        currentProgress = 100;
    }
}

window.addEventListener('message', function(event) {
    if (event.data.action === "openui") {
        var type = event.data.type;
        if (type === "show") {
            $('.mainDiv').show();
        } else if (type === "hide") {
            $('.mainDiv').hide();
        }
    } else if (event.data.action === "updateTank") {
        var type = event.data.type;
        setProgress(type);
    }
});
$('.mainDiv').hide();