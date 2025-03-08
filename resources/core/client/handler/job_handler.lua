pJob = ""
pJobGrade = 0
loadedJob = {}
local JobMenu = function()

end

local JobData = {
    ["cardealerSud"] = {
        load = function()
            LoadcardealerSudJob()
            LoadConcessEntreprise()
            LoadConcessHelico()
            LoadConcessBoat()
        end,
        unload = function()
            UnloadcardealerSudJob()
        end,
    },
    ["bennys"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end,
    },
    ["cayogarage"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end,
    },
    ["hayes"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end,
    },
    ["ocean"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end
    },
    ["heliwave"] = {
        load = function()
            LoadHeliwaveJob()
            --LoadConcessEntreprise()
            --LoadConcessHelico()
            --LoadConcessBoat()
        end,
        unload = function()
            UnloadHeliwaveJob()
        end,
    },
    ["beekers"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end,
    },
    ["sunshine"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end
    },
    ["lspd"] = {
        load = function()
            LoadLspdJob()
        end,
        unload = function()
            UnloadLspdJob()
        end
    },
    ["bp"] = {
        load = function()
            LoadBpJob()
        end,
        unload = function()
            UnloadBpJob()
        end
    },
    ["lsfd"] = {
        load = function()
            LoadLsfdJob()
        end,
        unload = function()
            UnloadLsfdJob()
        end
    },
    ["autoecole"] = {
        load = function()
            LoadDrivingSchoolJob()
        end,
        unload = function()
            UnLoadDrivingSchoolJob()
        end
    },
    ["taxi"] = {
        load = function()
            LoadTaxiJob()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadTaxiJob()
        end
    },
    ["weazelnews"] = {
        load = function()
            LoadWeazelNewJob()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadWeazelNewsJob()
        end
    },
    ["lifeinvader"] = {
        load = function()
            LoadLifeInvaderJob()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadLifeInvaderJob()
        end
    },
    ["ems"] = {
        load = function()
            LoadEmsJob()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadEmsJob()
        end
    },
    ["sams"] = {
        load = function()
            LoadEmsJob()
        end,
        unload = function()
            UnLoadEmsJob()
        end
    },
    ["bcms"] = {
        load = function()
            LoadBCMSJob()
        end,
        unload = function()
            UnLoadCayoEMSJob()
        end
    },
    ["realestateagent"] = {
        load = function()
            LoadRealEstateAgent()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadRealEstateAgent()
        end
    },
    ["burgershot"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
	["rexdiner"] = {
        --load = function()
            --LoadRestaurant()
        --end,
        --unload = function()
            --UnloadRestaurant()
        --end
        load = function()
            LoadRex()
        end,
        unload = function()
            UnLoadRex()
        end
    },
	["skyblue"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["tacosrancho"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["lucky"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["athena"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["mostwanted"] = {
        load = function()
            LoadMostWanted()
        end,
        unload = function()
            UnLoadMostWanted()
        end
    },
    ["sushistar"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["bahamas"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["vclub"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["club77"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["unicorn"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["royalhotel"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["ltdsud"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["ltdseoul"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["ltdmirror"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["justice"] = {
        load = function()
            LoadJustice()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadJustice()
        end
    },
    ["avocat"] = {
        load = function()
            LoadAvocat()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadAvocat()
        end
    },
    ["avocat2"] = {
        load = function()
            LoadAvocat2()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadAvocat2()
        end
    },
    ["avocat3"] = {
        load = function()
            LoadAvocat3()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            UnLoadAvocat3()
        end
    },
--[[     ["concessvelo"] = {
        load = function()
            LoadVespucciBike()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
            -- UnLoadJustice()
        end
    }, ]]
    ["pawnshop"] = {
        load = function()
            LoadPawnShopMenu()
        end,
        unload = function()
            UnLoadPawnShop()
        end
    },
    ["gouv"] = {
        load = function()
            LoadGouvJob()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
        end
    },
    ["gouv2"] = {
        load = function()
            LoadGouvJob2()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
        end
    },
    ["irs"] = {
        load = function()
            LoadGouvJob()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
        end
    },
    ["mayansclub"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["concessentreprise"] = {
        load = function()
            LoadConcessEntreprise()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
        end
    },
    ["usss"] = {
        load = function()
            LoadUSSS()
        end,
        unload = function()
            -- UnLoadDrivingSchoolJob()
        end
    },
    ["casse"] = {
        load = function()
            LoadJobCasse()
        end,
        unload = function()
            UnloadCasseJob()
        end
    },
    ["uwu"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["pizzeria"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["pearl"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["upnatom"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["hornys"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["tequilala"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["tattooSud"] = {
        load = function()
            Loadtattoo()
        end,
        unload = function()
            UnLoadtattoo()
        end
    },
    ["tattooNord"] = {
        load = function()
            Loadtattoo()
        end,
        unload = function()
            UnLoadtattoo()
        end
    },
    ["tattooCayo"] = {
        load = function()
            Loadtattoo()
        end,
        unload = function()
            UnLoadtattoo()
        end
    },
    ["amerink"] = {
        load = function()
            Loadtattoo()
        end,
        unload = function()
            UnLoadtattoo()
        end
    },
    ["comrades"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["sultan"] = {
        load = function()
            LoadSultan()
        end,
        unload = function()
            UnLoadSultan()
        end
    },
    ["mirror"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["yellowJack"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["blackwood"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["g6"] = {
        load = function()
            LoadG6Job()
        end,
        unload = function()
            UnloadG6Job()
        end
    },
    ["usmc"] = {
        load = function()
            LoadUSMCJob()
        end,
        unload = function()
            UnloadUSMCJob()
        end
    },
    ["sandybeauty"] = {
        load = function()
            LoadSheNails()
        end,
        unload = function()
            --UnLoadMirror()
        end
    },
    ["barber"] = {
        load = function()
            LoadBarber()
        end,
        unload = function()
            UnLoadBarber()
        end
    },
    --[[["barberNord"] = {
        load = function()
            LoadBarber()
        end,
        unload = function()
            UnLoadBarber()
        end
    },]]
    ["shenails"] = {
        load = function()
            LoadSheNails()
        end,
        unload = function()
            --UnLoadMirror()
        end
    },
    ["rockford"] = {
        load = function()
            LoadLabel()
        end,
        unload = function()
            UnLoadLabel()
        end
    },
    ["emperium"] = {
        load = function()
            LoadLabel()
        end,
        unload = function()
            UnLoadLabel()
        end
    },
    ["lsevent"] = {
        load = function()
            LoadJobConstruc()
        end,
        unload = function()
            UnLoadJobConstruc()
        end
    },
    ["records"] = {
        load = function()
            LoadLabel()
        end,
        unload = function()
            UnLoadLabel()
        end
    },
    ["harmony"] = {
        load = function()
            LoadMecanoJob()
        end,
        unload = function()
            UnloadMechanicJob()
        end,
    },
    ["lssd"] = {
        load = function()
            LoadLssdJob()
        end,
        unload = function()
            UnloadLssdJob()
        end
    },
    ["gcp"] = {
        load = function()
            LoadGCPJob()
        end,
        unload = function()
            UnloadGCPJob()
        end
    },
    ["cardealerNord"] = {
        load = function()
            LoadcardealerNordJob()
        end,
        unload = function()
            UnloadcardealerNordJob()
        end
    },
    ["bayviewLodge"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["bean"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["pops"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["cluckin"] = {
        load = function()
            LoadRestaurant()
        end,
        unload = function()
            UnloadRestaurant()
        end
    },
    ["barber2"] = {
        load = function()
            LoadBarber()
        end,
        unload = function()
            UnLoadBarber()
        end
    },
    ["barbercayo"] = {
        load = function()
            LoadBarber()
        end,
        unload = function()
            UnLoadBarber()
        end
    },
    ["ammunation"] = {
        load = function()
            LoadAmmunation()
        end,
        unload = function()
            UnLoadAmmunation()
        end
    },
    ["vangelico"] = {
        load = function()
            LoadVangelico()
        end,
        unload = function()
            UnLoadVangelico()
        end
    },
    ["don"] = {
        load = function()
            --LoadDon()
        end,
        unload = function()
            --UnLoadDon()
        end
    },
    ["domaine"] = {
        load = function()
            LoadDomaine()
        end,
        unload = function()
            UnLoadDomaine()
        end
    },
    ["postop"] = {
        load = function()
            LoadPostOP()
        end,
        unload = function()
            UnLoadPostOP()
        end
    },
    ["boi"] = {
        load = function()
            LoadBOI()
        end,
        unload = function()
            UnloadBOI()
        end
    },
    ["lst"] = {
        load = function()
            LoadLstJob()
        end,
        unload = function()
            UnLoadLstJob()
        end
    },
}

Citizen.CreateThread(
    function()
        while p == nil do Wait(1000) end
        print(p:getCrew())
        while true do
            Wait(1000)
            if p:getJob() ~= pJob then
                if JobData[pJob] ~= nil then -- Unload de l'ancien job
                    JobData[pJob].unload()
                    JobMenu = function() end
                end
                pJob = p:getJob()
                loadedJob = jobs[pJob]
                if JobData[pJob] ~= nil then -- Load du nouveau job
                    JobData[pJob].load()
                end
                TriggerEvent("core:changeJob")
                print("^3[CLIENT]: ^7job " .. pJob .. " loaded")
            end
            if p:getJobGrade() ~= pJobGrade then
                if JobData[pJob] ~= nil then -- Unload de l'ancien job
                    JobData[pJob].unload()
                    JobMenu = function() end
                end
                pJob = p:getJob()
                loadedJob = jobs[pJob]
                if JobData[pJob] ~= nil then -- Load du nouveau job
                    JobData[pJob].load()
                end
                pJobGrade = p:getJobGrade()
                TriggerEvent("core:changeJob")
                print("^3[CLIENT]: ^7job: ^3" .. pJob .. "^7 ^3grade: ^7" .. pJobGrade .. " ^3loaded^7")
            end
        end
    end
)

RegisterNetEvent("jobs:unloadcurrent")
AddEventHandler("jobs:unloadcurrent", function()
    if JobData[pJob] ~= nil then -- Unload de l'ancien job
        JobData[pJob].unload()
        JobMenu = function() end
    end
end)

function RegisterJobMenu(func)
    JobMenu = func
end

Keys.Register("F1", "F1", "Ouvrir le menu métier", function()
    if not p:getInAction() then
        JobMenu()
    else
        -- ShowNotification("~r~Vous ne pouvez pas faire ça maintenant ...")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous ne pouvez pas faire ça maintenant ..."
        })
    end
end)

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

-- RegisterCommand("annonce", function()
--     local job = p:getJob()
--     if job ~= "aucun" and job ~= "casse" then
--         local service = TriggerServerCallback("core:getOnDuty", token, job)
--         if service ~= nil then
--             for k, v in pairs(service) do
--                 if k == GetPlayerServerId(PlayerId()) then
--                     local annonce = KeyboardImput("Entrez le contenu de l'annonce")
--                     if annonce ~= "" and type(annonce) == "string" then
--                         local maj = string.sub(annonce, 1, 1)
--                         local removedString = string.sub(annonce, 2)
--                         local result = string.upper(maj) .. removedString
--                         TriggerServerEvent("core:makeAnnounceEntreprise", token, result)
--                     else
--                         -- ShowNotification("~r~Veuillez entrer un texte valide")

--                         -- New notif
--                         exports['vNotif']:createNotification({
--                             type = 'ROUGE',
--                             -- duration = 5, -- In seconds, default:  4
--                             content = "~s Veuillez entrer un texte valide"
--                         })

--                     end
--                 end
--             end
--         end
--     elseif job == "casse" then
--         local annonce = KeyboardImput("Entrez le contenu de l'annonce")
--         if annonce ~= "" and type(annonce) == "string" then
--             local maj = string.sub(annonce, 1, 1)
--             local removedString = string.sub(annonce, 2)
--             local result = string.upper(maj) .. removedString
--             TriggerServerEvent("core:makeAnnounceEntreprise", token, result)
--         else
--             -- ShowNotification("~r~Veuillez entrer un texte valide")

--             -- New notif
--             exports['vNotif']:createNotification({
--                 type = 'ROUGE',
--                 -- duration = 5, -- In seconds, default:  4
--                 content = "~s Veuillez entrer un texte valide"
--             })

--         end
--     else
--         -- ShowNotification("~r~Vous n'êtes dans aucune entreprise")

--         -- New notif
--         exports['vNotif']:createNotification({
--             type = 'ROUGE',
--             -- duration = 5, -- In seconds, default:  4
--             content = "~s Vous n'êtes dans aucune entreprise"
--         })

--     end
-- end)
local job = {
    ["lspd"] = {
        name = "LSPD",
        photo = "https://i.imgur.com/SKcGVYZ.webp"
    },
    ["bp"] = {
        name = "Border Patrol",
        photo = "https://i.imgur.com/aNxvie8.webp"
    },
    ["ems"] = {
        name = "EMS",
        photo = "https://i.imgur.com/e83bP1k.webp"
    },
    ["sams"] = {
        name = "SAMS",
        photo = "https://cdn.discordapp.com/attachments/1091869921002147971/1150386551096889385/bcms.webp"
    },
    ["taxi"] = {
        name = "Taxi",
        photo = "https://imgur.com/mlgJ9eG.webp"
    },
    ["cardealerSud"] = {
        name = "Concessionnaire Voiture",
        photo = "https://i.imgur.com/7cclBzn.webp"
    },
    ["realestateagent"] = {
        name = "Dynasty 8",
        photo = "https://media.discordapp.net/attachments/1028821380331999292/1034100603812581396/unknown.webp"
    },
    -- ["ltdsud"] = {
    --     name = "LTD Sud",
    --     photo = "https://imgur.com/WJpZS7v.webp"
    -- },
    -- ["ltdmirror"] = {
    --     name = "LTD Mirror",
    --     photo = "https://imgur.com/WJpZS7v.webp"
    -- },
    ["rexdiner"] = {
        name = "Rex Diner",
        photo = "https://imgur.com/x3ObcgO.webp"
    },
	["skyblue"] = {
        name = "Skyblue",
        photo = "https://imgur.com/x3ObcgO.webp"
    },
	["burgershot"] = {
        name = "BurgerShot",
        photo = "https://imgur.com/x3ObcgO.webp"
    },
    ["bean"] = {
        name = "Bean Machine",
        photo = "https://cdn.discordapp.com/attachments/1091869921002147971/1150386781628403784/bean.webp"
    },
    ["cluckin"] = {
        name = "Cluckin Bell",
        photo = "https://cdn.discordapp.com/attachments/1091869921002147971/1150386958196031518/cluckin.webp"
    },
    ["tacosrancho"] = {
        name = "Tacos Rancho",
        photo = "https://cdn.discordapp.com/attachments/1091869921002147971/1150387098264817674/tacosrancho.webp"
    },
    ["sushistar"] = {
        name = "SushiStar",
        photo = "https://imgur.com/CDNt7A1.webp"
    },
    ["weazelnews"] = {
        name = "Weazel News",
        photo = "https://imgur.com/Ck3qNdz.webp"
    },
    ["bennys"] = {
        name = "Benny's",
        photo = "https://imgur.com/CFSdc9J.webp"
    },
    ["cayogarage"] = {
        name = "El Rey Motors",
        photo = "https://imgur.com/CFSdc9J.webp"
    },
    ["ocean"] = {
        name = "Ocean Garage",
        photo = "https://imgur.com/ZX26bbG.webp"
    },
    ["hayes"] = {
        name = "Hayes Auto",
        photo = ""
    },
    ["beekers"] = {
        name = "Beekers Garage",
        photo = "https://cdn.discordapp.com/attachments/1141654302172119091/1141747724774031370/beekers-garage_534768.webp"
    },
    ["sunshine"] = {
        name = "Sunshine Garage",
        photo = "https://imgur.com/ZX26bbG.webp"
    },
    ["concessvelo"] = {
        name = "SkateShop",
        photo = "https://imgur.com/tdQm9pp.webp"
    },
    ["lucky"] = {
        name = "Lucky Plucker",
        photo = "https://imgur.com/e7ZHlu2.webp"
    },
    ["athena"] = {
        name = "Athena Bar",
        photo = "https://imgur.com/L4Im7J2.webp" 
    },
    ["pawnshop"] = {
        name = "PawnShop",
        photo = "https://imgur.com/ddPoutk.webp"
    },
    ["casse"] = {
        name = "Casse",
        photo = "https://i.imgur.com/KPQABmk.webp"
    },
    ["tequilala"] = {
        name = "Tequilala",
        photo = "https://cdn.discordapp.com/attachments/1027853229754687499/1042087955742851152/tequilala-_Imgur.webp"
    },
    ["uwu"] = {
        name = "UWU Cafe",
        photo = "https://media.discordapp.net/attachments/1044893755204968508/1044948737316880444/t_m_catcafe_logo.webp?width=670&height=670"
    },
    ["pizzeria"] = {
        name = "Pizzeria",
        photo = "https://i.imgur.com/DfA1Lrx.webp"
    },
    ["pearl"] = {
        name = "Pearl",
        photo = "https://i.imgur.com/IHsjPmg.webp"
    },
    ["upnatom"] = {
        name = "Up'n Atom",
        photo = "https://i.imgur.com/8uCVG7z.webp"
    },
    ["hornys"] = {
        name = "Horny's",
        photo = "https://i.imgur.com/d4HJmOp.webp"
    },
    ["comrades"] = {
        name = "Comrades bar",
        photo = "https://images-ext-1.discordapp.net/external/efMrpIqygRc32urHb4ivWMim3xNmg1pO3XABkkPjGFU/https/i.imgur.com/gP5zHAk.webp?width=702&height=702"
    },
    ["vclub"] = {
        name = "V Club",
        photo = "https://media.discordapp.net/attachments/1153604219740377098/1154402076818944063/Design_sans_titre.webp?width=671&height=671"
    },
    ["club77"] = {
        name = "club77",
        photo = "https://media.discordapp.net/attachments/1153604219740377098/1154402076818944063/Design_sans_titre.webp?width=671&height=671"
    },
    ["sultan"] = {
        name = "Sultan's pazar",
        photo = "https://media.discordapp.net/attachments/1063175362193932288/1085612968546418738/SultanPazar1.webp?width=671&height=671"
    },
    ["lst"] = {
        name = "Los Santos Transit",
        photo = "https://i.imgur.com/9NMITDy.webp"
    },
    ["barber"] = {
        name = "Hair Top",
        photo = "https://cdn.discordapp.com/attachments/1151163887933194250/1151163888528789615/image.webp"
    },
    ["barber2"] = {
        name = "O'Sheas Barber",
        photo = "https://cdn.discordapp.com/attachments/1054171163154202777/1141425982444667011/image.psd_3.webp"
    },
    ["barbercayo"] = {
        name = "Barber De CayoPerico",
        photo = "https://cdn.discordapp.com/attachments/1054171163154202777/1141425982444667011/image.psd_3.webp"
    },
    ["heliwave"] = {
        name = "Concessionnaire HeliWave",
        photo = "https://media.discordapp.net/attachments/1144792166640664606/1144792167064285294/Heliwave.webp?width=905&height=905"
    },
    ["tattooSud"] = {
        name = "Tattoo King",
        photo = "https://cdn.discordapp.com/attachments/1151161999519137834/1151162000248942652/King_Tattoo_III.webp"
    }
}

-- RegisterCommand("createAnnonce", function()
--     local phone = TriggerServerCallback("core:GetPhoneNumber")
--     if p:getJob() == "lspd" then phone = "911" end
--     SendNuiMessage(json.encode({
--         type = 'openWebview',
--         name = 'CardNewsSocietyCreate',
--         data = {
--             name_society = job[p:getJob()].name;
--             logo_society = job[p:getJob()].photo;
--             numero_society = phone;
--         }
--     }))
-- end)

RegisterNUICallback("notification_callback", function(data, cb)


    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    local phone = TriggerServerCallback("core:GetPhoneNumber")
    if p:getJob() == "lspd" then phone = "911" end
    TriggerServerEvent("AnnonceSociety", token, p:getJob(), data.message_notification, phone)
end)
RegisterNetEvent("AnnonceSociety")
AddEventHandler("AnnonceSociety", function(jobs, message, phone)
    AnnonceSociety(jobs, message, phone)
end)

function AnnonceSociety(jobs, message, phone)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CardNewsSocietyShow',
        data = {
            name_society = job[jobs].name;
            logo_society = job[jobs].photo;
            phone_society = phone;
            message = message
        }
    }))
    Wait(100)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
end
