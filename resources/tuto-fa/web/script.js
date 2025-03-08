const helper = document.querySelector('#helper');
const helperKey = document.querySelector('#helper-key');
const form = document.querySelector('#tuto-form');

const yesButton = form.querySelector('#yes');
const noButton = form.querySelector('#no');

let currentStep = 0;

const SpecialSteps = [
    {
        title: "Braquage d'ATM",
        desc: "Frappe l'ATM avec ton arme blanche pour faire sortir l'argent",
    },
    {
        title: "Racket",
        desc: "Braque avec ton couteau pour faire peur à la personne",
    },
    {
        title: "Racket",
        desc: "Rattrape la personne et plante là pour la mettre au sol",
    },
    {
        title: "Racket",
        desc: "Défends toi et plante la personne pour la mettre au sol",
    },
]

const steps = [
    {
        title: 'Téléphone',
        desc: 'Pour utiliser ton téléphone, appuie sur la touche <strong>W</strong>',
    },
    {
        title: 'Véhicule de location',
        desc: 'Récupère un véhicule pour pouvoir te déplacer',
    },
    {
        title: 'Permis de conduire',
        desc: 'Passe ton permis de conduire pour être en règle',
    },
    {
        title: 'Pièce d\'identité',
        desc: 'Récupère ta pièce d\'identité et ton permis au poste de police',
    },
    {
        title: 'Magasin de vêtements',
        desc: 'Rends-toi au binco pour te faire une tenue de travail',
    },
    {
        title: 'Épicerie',
        desc: 'Procure toi à boire et à manger au LTD le plus proche',
    },
    {
        title: 'Job Center',
        desc: 'Rends-toi au job center pour commencer à travailler',
    },
    {
        title: 'Tutotiel terminé',
        desc: 'Tu peux désormais jouer librement sur le serveur',
    }
]

const updateNotification = (title, desc, visible) => {
    if (helperKey.style.display === 'block') {
        handleIKey();
    };

    helper.classList.remove('slideFromLeft');
    helper.classList.add('slideToLeft')
    setTimeout(() => {
        helper.querySelector('h2').innerText = title;
        helper.querySelector('p').innerHTML = desc;
        if (visible) {
            helper.classList.remove('slideToLeft');
            helper.classList.add('slideFromLeft');
        }
        helper.style.display = visible ? 'block' : 'none';
    }, 500);

    setTimeout(() => {
        handleIKey();
    }, 10000);
}

const toggleForm = (visible) => {
    form.style.display = visible ? 'flex' : 'none';
}

const triggerNuiCallback = (action, data = {}) => {
    // Trigger NUI callback
    fetch(`http://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        body: JSON.stringify(data),
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
    });
}

yesButton.addEventListener('click', () => {
    toggleForm(false);
    triggerNuiCallback('disableFocus');
    triggerNuiCallback('startTuto');
    updateNotification(steps[0].title, steps[0].desc, true);
    setTimeout(() => {
        updateNotification(steps[1].title, steps[1].desc, true);
        currentStep = 1;
    }, 5000);
});

noButton.addEventListener('click', () => {
    toggleForm(false);
    triggerNuiCallback('disableFocus');
});

const handleIKey = () => {
    if (!helper.querySelector('h2').innerText) return;

    if (helper.style.display === 'block') {
        helper.classList.remove('slideFromLeft');
        helper.classList.add('slideToLeft')
        setTimeout(() => {
            helper.classList.remove('slideToLeft');
            helper.classList.add('slideFromLeft');
            helper.style.display = 'none';
            helperKey.style.display = 'block';
        }, 300);
    } else {
        helper.classList.remove('slideToLeft');
        helper.classList.add('slideFromLeft');
        helper.style.display = 'block';
        helperKey.style.display = 'none';
    }

}

window.addEventListener('message', (event) => {
    switch (event.data.action) {
        case 'openForm':
            toggleForm(true);
            break;
        case 'hideStep':
            updateNotification("", "", false);
            break;
        case 'openStep':
            updateNotification(SpecialSteps[event.data.step].title, SpecialSteps[event.data.step].desc, true);
            break;
        case 'openStepCustom':
            updateNotification(event.data.title, event.data.desc, true);
            break;
        case 'gotoStep':
            if (steps[event.data.step]) {
                if (event.data.step !== currentStep + 1) {
                    return;
                }
                currentStep = event.data.step;
                updateNotification(steps[event.data.step].title, steps[event.data.step].desc, true);
                if (event.data.step === steps.length - 1) {
                    setTimeout(() => {
                        updateNotification("", "", false);
                    }, 5000);
                }
            }
            break;
        case 'hideNotif':
            handleIKey();
            break;
    }
});

/* updateNotification("Braquage Vangelico", "Brise les vitres, vole la caisse et les tableaux", true)

setTimeout(() => {
    updateNotification("Braquage Vangelico", "détale ta mère y'a les flics", true)
}, 12500) */
