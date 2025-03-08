window.addEventListener('message', function (event) {
    switch (event.data.action) {
        case 'updateStatusHud':
            $("body").css("display", event.data.show ? "block" : "none");
            $("#boxSetHealth").css("width", event.data.health + "%");
            $("#boxSetArmour").css("width", event.data.armour + "%");
            $("#boxSetOxygen").css("width", event.data.oxygen + "%");
            $(".barArmour").css("width", "100%");


            //widthHeightSplit(event.data.oxygen, $("#boxSetOxygen"));

            if (event.data.health <= 33) {
                $('#boxSetHealth').css('background', 'linear-gradient(180deg, rgba(224, 31, 31, 0.9) 0%, rgba(194, 26, 32, 0.9) 100%)')
                return;
            }
            if (event.data.health <= 66) {
                $('#boxSetHealth').css('background', 'linear-gradient(180deg, rgba(251, 188, 4, 0.9) 0%, rgba(248, 148, 39, 0.9) 100%)')
                return;
            }
            $('#boxSetHealth').css('background', 'linear-gradient(180deg, rgba(30, 180, 90, 0.729) 0%, rgba(49, 255, 68, 0.702) 100%)')
            if (event.data.armour <= 1) {
                $('#boxSetArmour').css('background', 'rgba(0, 0, 0, 0)')
                $('.barArmour').css('background', 'rgba(0, 0, 0, 0)')
                return;
            }
            $('#boxSetArmour').css('background', 'linear-gradient(180deg, rgba(19, 81, 117, 0.729) 0%, rgba(10, 121, 186, 0.702) 100%)')
            $('.barArmour').css('background', 'rgba(0, 0, 0, 0.4)')
            break;
        case 'updateAdminOverlay':
            updateAdminOverlay(event.data);
            break;
        case 'updateJobOverlay':
            updateJobOverlay(event.data);
            break;
        case 'displayWeazelAnnounce':
            displayWeazelAnnounce(event.data);
            break;
        case 'toggleHotkeys':
            toggleHotkeys(event.data.state);
            break;
        case 'toggleSafeZoneIndicator':
            toggleSafeZoneIndicator(event.data.state);
            break;
        case 'toggleScreamer':
            toggleScreamer();
            break;
        case 'ambiantHalloween':
            ambiantHalloween();
            break;
        case 'toggleVehicleInTry':
            toggleVehiculeInTry(event.data);
            break;
        case 'toggleXPBar':
            toggleXPBar(event.data);
            break;
        case 'toggleElections':
            toggleElections(event.data);
            break;
        case 'toggleLimitedActions':
            toggleLimitedActions(event.data);
            break;
    }
});

function widthHeightSplit(value, ele) {
    let width = 25.0;
    let eleHeight = (value / 107) * width;

    ele.css("width", eleHeight + "px");
};

function Left(value, ele) {
    let height = 25.0;
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.css("right", eleHeight + "px");
    ele.css("right", leftOverHeight + "px");
};

const grades = {
    1: {
        name: "Game Master",
        color: "#15803d"
    },
    2: {
        name: "Modérateur",
        color: "#C40155"
    },
    3: {
        name: "Support",
        color: "#d97706"
    },
    4: {
        name: "Responsable",
        color: "#3b82f6"
    },
    5: {
        name: "Staff",
        color: "#fb7185"
    },
}

const colors = [
    "#10b981",  // green
    "#ca8a04", // yellow
    "#f97316", // orange
    "#dc2626", // red
]

const getColor = (activeReports) => {
    if (activeReports >= 10) return colors[3];
    if (activeReports >= 5) return colors[2];
    if (activeReports >= 3) return colors[1];
    return colors[0];
}

const updateAdminOverlay = (data) => {
    const { show, activeReports, activePlayers } = data;

    document.querySelector(".AdminOverlay").style.display = show ? "flex" : "none";
    document.querySelector(".AdminOverlay>#activeReports>span").innerText = activeReports || 0;
    document.querySelector(".AdminOverlay>#activePlayers>span").innerText = activePlayers || 0;
    document.querySelector(".AdminOverlay>#activeReports>span").style.color = getColor(activeReports);
    //document.getElementById("mcdonalds-noises");
    //document.getElementById("mcdonalds-noises").load();

    if (activeReports >= 10) {
        document.querySelector(".AdminOverlay").style.borderRadius = "5px 5px 0px 0px";
        document.querySelector(".AdminOverlayAlert").style.display = show ? "flex" : "none";

        document.querySelector(".AdminOverlay").classList.add("shakeAnim");
        document.querySelector(".AdminOverlayAlert").classList.add("shakeAnim");
        document.querySelector(".AdminOverlayAlert").classList.add("appearFromTop");

        // reset audio in case it's already playing or paused
        //document.getElementById("mcdonalds-noises").currentTime = 0;
        //document.getElementById("mcdonalds-noises").play();
    } else {
        document.querySelector(".AdminOverlay").style.borderRadius = "5px";
        document.querySelector(".AdminOverlayAlert").style.display = "none";

        document.querySelector(".AdminOverlayAlert").classList.remove("appearFromTop");
        document.querySelector(".AdminOverlay").classList.remove("shakeAnim");
        document.querySelector(".AdminOverlayAlert").classList.remove("shakeAnim");

        //document.getElementById("mcdonalds-noises").pause();
    }
};

const toggleSafeZoneIndicator = (state) => {
    document.querySelector("#SafeZoneIndicator").style.visibility = state ? "visible" : "hidden";
}

/* const updateJobOverlay = (data) => {
    const { show, data } = data;

    document.querySelector(".AdminOverlay").style.display = show ? "flex" : "none";
    document.querySelector(".AdminOverlay>#activeReports>span").innerText = activeReports || 0;
    document.querySelector(".AdminOverlay>#activePlayers>span").innerText = activePlayers || 0;
    document.querySelector(".AdminOverlay>#activeReports>span").style.color = getColor(activeReports);

    if (activeReports >= 10) {
        document.querySelector(".AdminOverlay").style.borderRadius = "5px 5px 0px 0px";
        document.querySelector(".AdminOverlayAlert").style.display = show ? "flex" : "none";
        document.querySelector(".AdminOverlayAlert").classList.add("appearFromTop");
    } else {
        document.querySelector(".AdminOverlay").style.borderRadius = "5px";
        document.querySelector(".AdminOverlayAlert").classList.remove("appearFromTop");
        document.querySelector(".AdminOverlayAlert").style.display = "none";
    }
}; */

const displayWeazelAnnounce = (data) => {
    const { content } = data;

    document.querySelector(".WeazelAnnounce").style.display = "flex";
    document.querySelector(".WeazelAnnounce>.text>p").innerText = content;
    setTimeout(() => {
        document.querySelector(".WeazelAnnounce").style.display = "none";
    }, 20000);
};

const toggleHotkeys = (state) => {

    if (state) {
        document.querySelector(".PlayersSelectionHotkeys").classList.add("appearFromLeft");
        document.querySelector(".PlayersSelectionHotkeys").style.display = "flex";
    } else {
        document.querySelector(".PlayersSelectionHotkeys").classList.remove("appearFromLeft");
        document.querySelector(".PlayersSelectionHotkeys").classList.add("disappearToLeft");

        setTimeout(() => {
            document.querySelector(".PlayersSelectionHotkeys").style.display = "none";
            document.querySelector(".PlayersSelectionHotkeys").classList.remove("disappearToLeft");
        }, 500);
    }
};

const ambiantHalloween = () => {
    const audio = new Audio("https://sacul.cloud/img/vision/ambiantHalloween.mp3");
    audio.volume = 1;
    audio.play();
}

const toggleScreamer = () => {
    const img = new Image();
    img.src = "https://sacul.cloud/img/vision/adil-screamer.png";
    const audio = new Audio("https://sacul.cloud/img/vision/screamer.mp3");

    document.body.style.backgroundImage = `url(${img.src})`;
    audio.volume = 1;
    audio.play();

    setTimeout(() => {
        document.body.style.backgroundImage = "none";
        audio.pause();
    }, 4000);
}

let interval;
const VehicleInTryCountdown = (state) => {
    const UI = document.querySelector("#VehicleInTry");
    const Countdown = UI.querySelector(".Time");

    if (state) {
        let time = 120;
        let minutes = 0;
        let seconds = 0;

        interval = setInterval(() => {
            minutes = Math.floor(time / 60);
            seconds = time % 60;

            Countdown.innerText = `${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;

            if (time <= 0) {
                clearInterval(interval);
                Countdown.innerText = "00:00";
                toggleVehiculeInTry({ show: false });
            }

            time--;
        }, 1000);
    } else {
        clearInterval(interval);
        Countdown.innerText = "00:00";
    }
};

const LimitedActionsCountdown = () => {
    const UI = document.querySelector(".LimitedActionsOverlay");
    const Countdown = UI.querySelector(".time");

    // couldown of 15 minutes (15:00)
    let time = 900;
    let minutes = 0;
    let seconds = 0;

    interval = setInterval(() => {
        minutes = Math.floor(time / 60);
        seconds = time % 60;

        Countdown.innerText = `${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;

        if (time <= 0) {
            clearInterval(interval);
            Countdown.innerText = "00:00";
            toggleLimitedActions({ state: false });
        }

        time--;
    }, 1000);
};

const toggleVehiculeInTry = (data) => {
    const UI = document.querySelector("#VehicleInTry");

    if (data.state) {
        UI.style.visibility = "visible";
        UI.querySelector(".Vehicle").innerText = data.model;
        VehicleInTryCountdown(true);
    } else {
        UI.style.visibility = "hidden";
        VehicleInTryCountdown(false);
    }
};

const toggleLimitedActions = (data) => {
    const UI = document.querySelector(".LimitedActionsOverlay");

    if (data.state) {
        UI.style.visibility = "visible";
        UI.classList.add("appearFromTop");
        LimitedActionsCountdown();
    } else {
        UI.classList.remove("appearFromTop");
        UI.classList.add("disappearToTop");

        setTimeout(() => {
            UI.style.visibility = "hidden";
            UI.classList.remove("disappearToTop");
            clearInterval(interval);
        }, 500);
    }
}

const toggleElections = (data) => {
    const UI = document.querySelector("#Elections");

    const { candidate_1, candidate_2 } = data;

    UI.classList.add("appearFromTop");
    UI.style.visibility = "visible";

    // Bars
    UI.querySelector(".Bar-1").style.width = `${candidate_1}%`;
    UI.querySelector(".Bar-2").style.width = `${candidate_2}%`;

    // Text
    UI.querySelector(".prc1").innerText = `${candidate_1}%`;
    UI.querySelector(".prc2").innerText = `${candidate_2}%`;

    // 5secs later, remove and add disappear animation and hide the UI
    setTimeout(() => {
        UI.classList.remove("appearFromTop");
        UI.classList.add("disappearToTop");

        setTimeout(() => {
            UI.style.visibility = "hidden";
            UI.classList.remove("disappearToTop");
        }, 500);
    }, 5000);
};

/* window.onload = () => {
    toggleXPBar({
        show: true,
        crewName: "Vagos Gang",
        crewColor: "#3b82f6",
        value: 50,
        level: 5,
        rank: "C"
    });
}; */

const toggleXPBar = (data) => {
    function hexToRgbA(hex) {
        let c;
        if (/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)) {
            c = hex.substring(1).split("");
            if (c.length == 3) {
                c = [c[0], c[0], c[1], c[1], c[2], c[2]];
            }
            c = "0x" + c.join("");
            return [(c >> 16) & 255, (c >> 8) & 255, c & 255].join(",");
        }
        throw new Error("Bad Hex");
    }

    const r = document.querySelector(":root");
    const UI = document.querySelector("#xp-bar");

    const { show, crewName, crewColor, barValue, level, rank } = data;

    UI.style.visibility = show ? "visible" : "hidden";


    r.style.setProperty("--crewcolor", crewColor);
    r.style.setProperty("--crewcolor-rgb", hexToRgbA(crewColor));

    UI.classList.add("appearFromTop");

    UI.querySelector("#bar-crew").innerText = crewName;

    UI.querySelector("#bar-value").style.width = `${barValue}%`;
    UI.querySelector("#bar-text").innerText = `Level ${level}`;

    UI.querySelector("bar-subtex").innerHTML = `Rang <span class="rank">${rank}</span>`;
};
