local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

DriveSchool = {}
DriveSchool.timer = 0
DriveSchool.note = 0
DriveSchool.Answer = {
    ["question1.webp"] = 3,
    ["question2.webp"] = 2,
    ["question3.webp"] = 2,
    ["question4.webp"] = 3,
    ["question5.webp"] = 1,
    ["question6.webp"] = 4,
    ["question7.webp"] = 3,
    ["question8.webp"] = 1,
    ["question9.webp"] = 3,
    ["question10.webp"] = 2,
}
DriveSchool.Question = {
    {
        name = "Dans cette situation :",
        picture = "question1.webp",
        answer = {
            { letter = "A", name = "Je peux avancer", selected = false },
            { letter = "B", name = "Je peux tourner", selected = false },
            { letter = "C", name = "Je dois m'arrêter", selected = false },
            { letter = "D", name = "Je dois accélérer", selected = false },
        },
    },
    {
        name = "Comment puis-je me garer ? :",
        picture = "question2.webp",
        answer = {
            { letter = "A", name = "En créneau", selected = false },
            { letter = "B", name = "En bataille", selected = false },
            { letter = "C", name = "En épis", selected = false },
            { letter = "D", name = "En arrière", selected = false },

        }
    },
    {
        name = "Dans cette situation, est-ce que je peux tourner à gauche  :",
        picture = "question3.webp",
        answer = {
            { letter = "A", name = "Oui", selected = false },
            { letter = "B", name = "Non", selected = false },
            { letter = "C", name = "les 2", selected = false },
            { letter = "D", name = "Peut-être", selected = false },
        }
    },
    {
        name = "Un policier me braque mais le feu est vert, que dois-je faire ? :",
        picture = "question4.webp",
        answer = {
            { letter = "A", name = "J'attends que le piéton passe pour avancer", selected = false },
            { letter = "B", name = "J’écrase les deux individus", selected = false },
            { letter = "C", name = "J’écoute le policier donc je m’arrête", selected = false },
            { letter = "D", name = "J'active les essuie glace", selected = false },

        }
    },
    {
        name = "Quel est l’indice le plus important :",
        picture = "question5.webp",
        answer = {
            { letter = "A", name = "Le feu", selected = false },
            { letter = "B", name = "Le panneau", selected = false },
            { letter = "C", name = "Le groupe de filles a droite", selected = false },
            { letter = "D", name = "La voiture", selected = false }
        }
    },
    {
        name = "Je provoque un accident où je suis le seul en faute car je suis sous cocaïne, que dois-je faire :",
        picture = "question6.webp",
        answer = {
            { letter = "A", name = "Je repars comme si de rien n'était", selected = false },
            { letter = "B", name = "Je reprends un rail de cocaïne pour y voir plus clair", selected = false },
            { letter = "C", name = "Je contacte un mécano pour reprendre ma voiture", selected = false },
            { letter = "D", name = "Je contacte les EMS", selected = false }

        }
    },
    {
        name = "Suis-je bien garé ? :",
        picture = "question7.webp",
        answer = {
            { letter = "A", name = "Oui le poste de secours n’as rien à faire ici", selected = false },
            { letter = "B", name = "Non sur le sable c’est mieux", selected = false },
            { letter = "C", name = "Non", selected = false },
            { letter = "D", name = "Je dois accélérer", selected = false }

        }
    },
    {
        name = "Ça fait 24h que je roule sans arrêt, que dois-je faire :",
        picture = "question8.webp",
        answer = {
            { letter = "A", name = "Faire une petite pause de 2 heures", selected = false },
            { letter = "B", name = "Je mets les warning pour prévenir les autres conducteurs que je risque de m'évanouir",
                selected = false },
            { letter = "C", name = "J’incline mon siège au maximum pour pouvoir conduire et me reposer en même temps",
                selected = false },
            { letter = "D", name = "Je fais une vidéo 24h en voiture", selected = false },

        }
    },
    {
        name = "Un sanglier me bloque la route, quelle décision dois-je prendre :",
        picture = "question9.webp",
        answer = {
            { letter = "A", name = "J’en profite pour le dépecer et me faire de l’argent sur son dos",
                selected = false },
            { letter = "B", name = "J’appelle mon assurance pour me sortir de cette histoire", selected = false },
            { letter = "C", name = "Je le contourne", selected = false },
            { letter = "D", name = "Je fait un barbecue avec le sanglier", selected = false },

        }
    },
    {
        name = "Qu'est-ce que je peux faire dans cette situation :",
        picture = "question10.webp",
        answer = {
            { letter = "A", name = "Prier", selected = false },
            { letter = "B", name = "Appeler les pompiers", selected = false },
            { letter = "C", name = "Appeler les taxis", selected = false },
            { letter = "D", name = "Faire une photo souvenir", selected = false },
        }
    },
}


RegisterNUICallback("autoecole__callback", function(data, cb)

    if data.action == "sendQuestions" then

        local s = true
        local l = false
        for k, v in pairs(data.questions.answer) do
            if v.selected and k ~= DriveSchool.Answer[data.questions.picture] then
                s = false
                break
            elseif not v.selected and k == DriveSchool.Answer[data.questions.picture] then
                s = false
                break
            end

        end

        if s then
            DriveSchool.note = DriveSchool.note + 1
        end

    end

    if data.action == "takeNote" then
        if DriveSchool.note >= 7 then
            TriggerServerEvent("core:addLicence", GetPlayerServerId(PlayerId()), token,
                "traffic_law")

        end
        cb({
            action = "takeNote",
            note = DriveSchool.note
        })


    end

end)
