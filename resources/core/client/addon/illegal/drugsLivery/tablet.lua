local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local receivedLastinfo = false
--print('tablet')
ArmesMaxStock = {
    ["pf"] = {
        ["weapon_bat"] = 10,
        ["weapon_bottle"] = 10,
        ["weapon_crowbar"] = 10,
        ["weapon_golfclub"] = 10, 
        ["weapon_hatchet"] = 10,
        ["weapon_knuckle"] = 10,
        ["weapon_machete"] = 10,
        ["weapon_nightstick"] = 10,
        ["weapon_wrench"] = 10,
        ["weapon_knife"] = 10,
        ["weapon_switchblade"] = 10,
        ["weapon_battleaxe"] = 10,
        ["weapon_poolcue"] = 10,
        ["weapon_canette"] = 10,
        ["weapon_bouteille"] = 10,
        ["weapon_pelle"] = 10,
        ["weapon_pickaxe"] = 10,
        ["weapon_sledgehammer"] = 10,
        ["weapon_dagger"] = 10,
        ["serflex"] = 8,
        ["plate"] = 6,
    },
    ["gang"] = {
        --arme blanche
        ["weapon_bat"] = 10,
        ["weapon_bottle"] = 10,
        ["weapon_crowbar"] = 10,
        ["weapon_golfclub"] = 10, 
        ["weapon_hatchet"] = 10,
        ["weapon_knuckle"] = 10,
        ["weapon_machete"] = 10,
        ["weapon_nightstick"] = 10,
        ["weapon_wrench"] = 10,
        ["weapon_knife"] = 10,
        ["weapon_switchblade"] = 10,
        ["weapon_battleaxe"] = 10,
        ["weapon_poolcue"] = 10,
        ["weapon_canette"] = 10,
        ["weapon_pelle"] = 10,
        ["weapon_bouteille"] = 10,
        ["weapon_pickaxe"] = 10,
        ["weapon_vintagepistol"] = 4,
        ["weapon_snspistol"] = 4,
        ["weapon_sledgehammer"] = 10,
        ["weapon_dagger"] = 10,
        ["serflex"] = 8,
        ["plate"] = 6,
    },
    ["mc"] = {
        ["weapon_pistol"] = 6,
        ["weapon_vintagepistol"] = 4,
        ["weapon_snspistol"] = 4,
        ["weapon_dbshotgun"] = 4,
        ["weapon_molotov"] = 3,
        ["weapon_sawnoffshotgun"] = 2,
        ["pincecoupante"] = 8,
    },
    ["orga"] = {
        ["weapon_katana"] = 2,
        ["weapon_pistol"] = 6,
        ["weapon_combatpistol"] = 6,
        ["weapon_heavypistol"] = 4,
        ["weapon_revolver"] = 4,
        ["weapon_doubleaction"] = 4,
        ["weapon_pistol50"] = 4,

        ["weapon_microsmg"] = 2,
        ["weapon_machinepistol"] = 2,
        ["weapon_minismg"] = 2,

        ["weapon_assaultshotgun"] = 2,
        ["weapon_pumpshotgun"] = 2, 
        
    },
    ["mafia"] = {
        ["weapon_heavyshotgun"] = 2,
        ["weapon_autoshotgun"] = 2,
        ["weapon_combatshotgun"] = 2, 
        ["weapon_compactrifle"] = 2, 
        ["weapon_assaultrifle"] = 2,
        ["weapon_gusenberg"] = 2,
        ["weapon_smg"] = 2,
        ["weapon_carbinerifle"] = 2,
        ["weapon_specialcarbine"] = 2,
        ["weapon_pistol"] = 6,
        ["weapon_combatpistol"] = 6,
    },
}

pfWeapon = {
    {
        id = 7,
        price = 5000,
        name = 'Plaque illegal',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/plate.webp',
        stock = ArmesMaxStock.pf["plate"],
        spawnName = "plate",
        type = "weapons",
        level = 1
    },
    {
        id = 1,
        price = 576,
        name = 'Batte de baseball',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_bat.webp',
        stock = ArmesMaxStock.pf["weapon_bat"],
        spawnName = "weapon_bat",
        type = "weapons",
        level = 3
    },
    { 
        id = 2,
        price = 576,
        name = 'Pied de Biche',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_crowbar.webp',
        stock = ArmesMaxStock.pf["weapon_crowbar"],
        spawnName = "weapon_crowbar",
        type = "weapons",
        level = 3
    },
    { 
        id = 3,
        price = 576,
        name = 'Club de Golf',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_golfclub.webp',
        stock = ArmesMaxStock.pf["weapon_golfclub"],
        spawnName = "weapon_golfclub",
        type = "weapons",
        level = 3
    },
    { 
        id = 4,
        price = 672,
        name = 'Clé anglaise',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_wrench.webp',
        stock = ArmesMaxStock.pf["weapon_wrench"],
        spawnName = "weapon_wrench",
        type = "weapons",
        level = 3
    },
    { 
        id = 6,
        price = 768,
        name = 'Bouteille en verre',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_bottle.webp',
        stock = ArmesMaxStock.pf["weapon_bottle"],
        spawnName = "weapon_bottle",
        type = "weapons",
        level = 3
    },
    { 
        id = 10,
        price = 1344,
        name = 'Poing américain',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_knuckle.webp',
        stock = ArmesMaxStock.pf["weapon_knuckle"],
        spawnName = "weapon_knuckle",
        type = "weapons",
        level = 3
    },
    { 
        id = 14,
        price = 960,
        name = 'Pelle',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pelle.webp',
        stock = ArmesMaxStock.pf["weapon_pelle"],
        spawnName = "weapon_pelle",
        type = "weapons",
        level = 3
    },
    { 
        id = 15,
        price = 1344,
        name = 'Pioche',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pickaxe.webp',
        stock = ArmesMaxStock.pf["weapon_pickaxe"],
        spawnName = "weapon_pickaxe",
        type = "weapons",
        level = 3
    },
    { 
        id = 16,
        price = 1728,
        name = 'Masse',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_sledgehammer.webp',
        stock = ArmesMaxStock.pf["weapon_sledgehammer"],
        spawnName = "weapon_sledgehammer",
        type = "weapons",
        level = 3
    },
}

pf = {
    name = "pf",
    drogues = {
    },
    armes = {
    },
    autre = {
        {
            id = 1,
            price = 1200,
            name = 'Ordinateur',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/ordinateur_portable.webp',
            spawnName = "laptop",
            type = "utils"
        }
    }
}

gangWeapon = {
    {
        id = 1,
        price = 5000,
        name = 'Plaque illegal',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/plate.webp',
        stock = ArmesMaxStock.pf["plate"],
        spawnName = "plate",
        type = "weapons",
        level = 1
    },
    { 
        id = 2,
        price = 960,
        name = 'Couteau',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_knife.webp',
        stock = ArmesMaxStock.gang["weapon_knife"],
        spawnName = "weapon_knife",
        type = "weapons",
        level = 3
    },
    { 
        id = 3,
        price = 1248,
        name = 'Dague Antique',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_dagger.webp',
        stock = ArmesMaxStock.gang["weapon_dagger"],
        spawnName = "weapon_dagger",
        type = "weapons",
        level = 3
    },
    { 
        id = 4,
        price = 1152,
        name = 'Couteau à cran d arrêt',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_switchblade.webp',
        stock = ArmesMaxStock.gang["weapon_switchblade"],
        spawnName = "weapon_switchblade",
        type = "weapons",
        level = 3
    },
    { 
        id = 5,
        price = 1728,
        name = 'Hachette',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_hatchet.webp',
        stock = ArmesMaxStock.gang["weapon_hatchet"],
        spawnName = "weapon_hatchet",
        type = "weapons",
        level = 3
    },
    { 
        id = 6,
        price = 2208,
        name = 'Machette',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_machete.webp',
        stock = ArmesMaxStock.gang["weapon_machete"],
        spawnName = "weapon_machete",
        type = "weapons",
        level = 3
    }, 
    { 
        id = 7,
        price = 3456,
        name = 'Hache de guerre',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_battleaxe.webp',
        stock = ArmesMaxStock.gang["weapon_battleaxe"],
        spawnName = "weapon_battleaxe",
        type = "weapons",
        level = 3
    },
    { 
        id = 8,
        price = 8640,
        name = 'Glock 26',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_snspistol.webp',
        stock = ArmesMaxStock.gang["weapon_snspistol"],
        spawnName = "weapon_snspistol",
        type = "weapons",
        level = 4
    },
    { 
        id = 9,
        price = 7200,
        name = 'Glock 41 gen4',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_vintagepistol.webp',
        stock = ArmesMaxStock.gang["weapon_vintagepistol"],
        spawnName = "weapon_vintagepistol",
        type = "weapons",
        level = 4
    },
    
    {
        id = 10,
        price = 576,
        name = 'Batte de baseball',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_bat.webp',
        stock = ArmesMaxStock.pf["weapon_bat"],
        spawnName = "weapon_bat",
        type = "weapons",
        level = 3
    },
    { 
        id = 11,
        price = 576,
        name = 'Pied de Biche',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_crowbar.webp',
        stock = ArmesMaxStock.pf["weapon_crowbar"],
        spawnName = "weapon_crowbar",
        type = "weapons",
        level = 3
    },
    { 
        id = 12,
        price = 576,
        name = 'Club de Golf',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_golfclub.webp',
        stock = ArmesMaxStock.pf["weapon_golfclub"],
        spawnName = "weapon_golfclub",
        type = "weapons",
        level = 3
    },
    { 
        id = 13,
        price = 672,
        name = 'Clé anglaise',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_wrench.webp',
        stock = ArmesMaxStock.pf["weapon_wrench"],
        spawnName = "weapon_wrench",
        type = "weapons",
        level = 3
    },
    { 
        id = 14,
        price = 768,
        name = 'Bouteille en verre',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_bottle.webp',
        stock = ArmesMaxStock.pf["weapon_bottle"],
        spawnName = "weapon_bottle",
        type = "weapons",
        level = 3
    },
    { 
        id = 15,
        price = 1344,
        name = 'Poing américain',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_knuckle.webp',
        stock = ArmesMaxStock.pf["weapon_knuckle"],
        spawnName = "weapon_knuckle",
        type = "weapons",
        level = 3
    },
    { 
        id = 16,
        price = 960,
        name = 'Pelle',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pelle.webp',
        stock = ArmesMaxStock.pf["weapon_pelle"],
        spawnName = "weapon_pelle",
        type = "weapons",
        level = 3
    },
    { 
        id = 17,
        price = 1344,
        name = 'Pioche',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pickaxe.webp',
        stock = ArmesMaxStock.pf["weapon_pickaxe"],
        spawnName = "weapon_pickaxe",
        type = "weapons",
        level = 3
    },
    { 
        id = 18,
        price = 1728,
        name = 'Masse',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_sledgehammer.webp',
        stock = ArmesMaxStock.pf["weapon_sledgehammer"],
        spawnName = "weapon_sledgehammer",
        type = "weapons",
        level = 3
    },
}

gang = {
    name = "gang",
    drogues = {
        {
            id = 1,
            price = 20,
            name = 'Weed',
            image = "https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Drogues/weed.webp",
            spawnName = "weed",
            type = "drugs"
        }, 
        --{
        --    id = 1,
        --    price = 30,
        --    name = 'Engrais',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/engrais.webp",
        --            spawnName = "engrais",
        --            type = "drugs"
        --        },
        --        {
        --            id = 2,
        --            price = 30,
        --            name = 'Fertilisant',
        --            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fertilisant.webp",
        --            spawnName = "fertilisant",
        --            type = "drugs"
        --       },
        --        {
        --           id = 3,
        --           price = 5,
        --           name = 'Graine de cannabis',
        --           image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/grainecannabis.webp",
        --           spawnName = "grainecannabis",
        --           type = "drugs"
        --        },
    },
    armes = {
    },
    autre = {
        {
            id = 1,
            price = 1200,
            name = 'Ordinateur',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/ordinateur_portable.webp',
            spawnName = "laptop",
            type = "utils"
        },
        {
            id = 2,
            price = 28,
            name = 'Outils de crochetage',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/Outils_crochetage.webp',
            spawnName = "crochet",
            type = "utils"
        },
        {
            id = 3,
            price = 30,
            name = 'Serflex',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/Serflex.webp',
            spawnName = "serflex",
            type = "utils"
        }
    }
}

mcWeapon = {
    -- { 
    --     id = 1,
    --     price = 14000,
    --     name = 'Beretta 92 FS',
    --     image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pistol.webp',
    --     stock = ArmesMaxStock.mc["weapon_pistol"],
    --     spawnName = "weapon_pistol",
    --     type = "weapons",
    --     level = 3
    -- },
    { 
        id = 2,
        price = 7200,
        name = 'Glock 41 gen4',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_vintagepistol.webp',
        stock = ArmesMaxStock.mc["weapon_vintagepistol"],
        spawnName = "weapon_vintagepistol",
        type = "weapons",
        level = 3
    },
    { 
        id = 3,
        price = 8640,
        name = 'Glock 26',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_snspistol.webp',
        stock = ArmesMaxStock.mc["weapon_snspistol"],
        spawnName = "weapon_snspistol",
        type = "weapons",
        level = 3
    },
    { 
        id = 4,
        price = 48960,
        name = 'Double Canon',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_dbshotgun.webp',
        stock = ArmesMaxStock.mc["weapon_dbshotgun"],
        spawnName = "weapon_dbshotgun",
        type = "weapons",
        level = 4
    },
    { 
        id = 10,
        price = 61920,
        name = 'Mossberg 500',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_sawnoffshotgun.webp',
        stock = ArmesMaxStock.mc["weapon_sawnoffshotgun"],
        spawnName = "weapon_sawnoffshotgun",
        type = "weapons",
        level = 4
    },
    { 
        id = 5,
        price = 9842,
        name = 'Cocktail Molotov',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_molotov.webp',
        stock = ArmesMaxStock.mc["weapon_molotov"],
        spawnName = "weapon_molotov",
        type = "weapons",
        level = 3
    },
}

mc = {
    name = "mc",
    drogues = {
        {
            id = 1,
            price = 50,
            name = 'Cocaine',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Drogues/cocaine.webp',
            spawnName = "coke",
            type = "drugs"
        },
        --{
        --    id = 1,
        --    price = 5,
        --    name = 'Pavot somnifère',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/pavosomnifere.webp",
        --    spawnName = "pavosomnifere",
        --    type = "drugs"
        --},
        --{
        --    id = 2,
        --    price = 28,
        --    name = 'Chlorure Ammonium',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/chlorureammonium.webp",
        --    spawnName = "chlorureammonium",
        --    type = "drugs"
        --},
        --{
        --    id = 3,
        --    price = 30,
        --    name = 'Anhydride Acétique',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/anhydrideacetique.webp",
        --    spawnName = "anhydrideacetique",
        --    type = "drugs"
        --},
    },
    armes = {
    },
    autre = {
        {
            id = 2,
            price = 800,
            name = 'Meuleuse',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/Meuleuse.webp',
            spawnName = "meuleuse",
            type = "utils"
        },
        {
            id = 3,
            price = 800,
            name = 'Perceuse',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/Perceuse.webp',
            spawnName = "drill",
            type = "utils"
        },
        {
            id = 4,
            price = 600,
            name = 'Munition de fusil a pompe',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ammobox_shotgun.webp',
            spawnName = "ammobox_shotgun",
            type = "utils"
        },
        {
            id = 5,
            price = 190,
            name = 'Pince coupante',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Utils/Pince_coupante.webp',
            spawnName = "pincecoupante",
            type = "utils"
        },
    }
}

orgaWeapon = {
    { 
        id = 3,
        price = 17280,
        name = 'Colt M45A1',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_heavypistol.webp',
        stock = ArmesMaxStock.orga["weapon_heavypistol"],
        spawnName = "weapon_heavypistol",
        type = "weapons",
        level = 3
    },
    { 
        id = 4,
        price = 22320,
        name = 'Taurus Raging Bull',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_revolver.webp',
        stock = ArmesMaxStock.orga["weapon_revolver"],
        spawnName = "weapon_revolver",
        type = "weapons",
        level = 3
    },
    { 
        id = 5,
        price = 24480,
        name = 'Colt M1892',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_doubleaction.webp',
        stock = ArmesMaxStock.orga["weapon_doubleaction"],
        spawnName = "weapon_doubleaction",
        type = "weapons",
        level = 3
    },
    { 
        id = 6,
        price = 23400,
        name = 'IMI UZI',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_microsmg.webp',
        stock = ArmesMaxStock.orga["weapon_microsmg"],
        spawnName = "weapon_microsmg",
        type = "weapons",
        level = 4
    },
    { 
        id = 7,
        price = 28200,
        name = 'Intratec TEC-DC9',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_machinepistol.webp',
        stock = ArmesMaxStock.orga["weapon_machinepistol"],
        spawnName = "weapon_machinepistol",
        type = "weapons",
        level = 4
    },
    { 
        id = 8,
        price = 31200,
        name = 'Škorpion Vz. 61',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_minismg.webp',
        stock = ArmesMaxStock.orga["weapon_minismg"],
        spawnName = "weapon_minismg",
        type = "weapons",
        level = 4
    },
    { 
        id = 9,
        price = 153360,
        name = 'UTAS UTS-15',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_assaultshotgun.webp',
        stock = ArmesMaxStock.orga["weapon_assaultshotgun"],
        spawnName = "weapon_assaultshotgun",
        type = "weapons",
        level = 4
    },
    { 
        id = 10,
        price = 20160,
        name = 'Desert Eagle .50',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pistol50.webp',
        stock = ArmesMaxStock.orga["weapon_pistol50"],
        spawnName = "weapon_pistol50",
        type = "weapons",
        level = 3
    },
    { 
        id = 11,
        price = 66960,
        name = 'Remington 870E',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pumpshotgun.webp',
        stock = ArmesMaxStock.orga["weapon_pumpshotgun"],
        spawnName = "weapon_pumpshotgun",
        type = "weapons",
        level = 4
    },
    { 
        id = 13,
        price = 4768,
        name = 'Katana',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_katana.webp',
        stock = ArmesMaxStock.orga["weapon_katana"],
        spawnName = "weapon_katana",
        type = "weapons",
        level = 3
    },
}

orga = {
    name = "orga",
    drogues = {
        {
            id = 1,
            price = 70,
            name = 'Methamphetamine',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Drogues/methamphetamine.webp',
            spawnName = "meth",
            type = "drugs"
        },
        --{
        --    id = 1,
        --    price = 5,
        --    name = 'Feuille de Coca',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/feuilledecoca.webp",
        --    spawnName = "feuilledecoca",
        --    type = "drugs"
        --},
        --{
        --    id = 2,
        --    price = 40,
        --    name = 'Acide Sulfurique',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/acidesulfurique.webp",
        --    spawnName = "acidesulfurique",
        --    type = "drugs"
        --},
        --{
        --    id = 3,
        --    price = 40,
        --    name = 'Kerosene',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kerosene.webp",
        --    spawnName = "kerosene",
        --    type = "drugs"
        --},
    },
    armes = {
    },
    autre = {
        {
            id = 2,
            price = 200,
            name = 'Munition d\'Arme de poing',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ammobox_pistol.webp',
            spawnName = "ammobox_pistol",
            type = "utils"
        },
        {
            id = 3,
            price = 400,
            name = 'Munition de mitraillette & mitrailleuse légère',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ammobox_sub.webp',
            spawnName = "ammobox_sub",
            type = "utils"
        }
    }
}

mafiaWeapon = {
    { 
        id = 2,
        price = 171360,
        name = 'Armsel Striker',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_autoshotgun.webp',
        stock = ArmesMaxStock.mafia["weapon_autoshotgun"],
        spawnName = "weapon_autoshotgun",
        type = "weapons",
        level = 4
    },
    { 
        id = 3,
        price = 187920,
        name = 'Franchi SPAS-12',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_combatshotgun.webp',
        stock = ArmesMaxStock.mafia["weapon_combatshotgun"],
        spawnName = "weapon_combatshotgun",
        type = "weapons",
        level = 4
    },
    { 
        id = 4,
        price = 127400,
        name = 'AKS-74u',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_compactrifle.webp',
        stock = ArmesMaxStock.mafia["weapon_compactrifle"],
        spawnName = "weapon_compactrifle",
        type = "weapons",
        level = 3
    },
    { 
        id = 5,
        price = 157950,
        name = 'AK-47',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_assaultrifle.webp',
        stock = ArmesMaxStock.mafia["weapon_assaultrifle"],
        spawnName = "weapon_assaultrifle",
        type = "weapons",
        level = 4
    },
    { 
        id = 6,
        price = 106730,
        name = 'M1928A1 Thompson',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_gusenberg.webp',
        stock = ArmesMaxStock.mafia["weapon_gusenberg"],
        spawnName = "weapon_gusenberg",
        type = "weapons",
        level = 4
    },
    { 
        id = 7,
        price = 101400,
        name = 'H&K MP5A5',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_smg.webp',
        stock = ArmesMaxStock.mafia["weapon_smg"],
        spawnName = "weapon_smg",
        type = "weapons",
        level = 3
    },
    { 
        id = 8,
        price = 163605,
        name = 'M4A1',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_carbinerifle.webp',
        stock = ArmesMaxStock.mafia["weapon_carbinerifle"],
        spawnName = "weapon_carbinerifle",
        type = "weapons",
        level = 4
    },
    { 
        id = 9,
        price = 172250,
        name = 'H&K G36C',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_specialcarbine.webp',
        stock = ArmesMaxStock.mafia["weapon_specialcarbine"],
        spawnName = "weapon_specialcarbine",
        type = "weapons",
        level = 4
    },
    { 
        id = 10,
        price = 9240,
        name = 'Beretta 92 FS',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_pistol.webp',
        stock = ArmesMaxStock.mafia["weapon_pistol"],
        spawnName = "weapon_pistol",
        type = "weapons",
        level = 3
    },
    { 
        id = 11,
        price = 12820,
        name = 'Glock 17',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_combatpistol.webp',
        stock = ArmesMaxStock.mafia["weapon_combatpistol"],
        spawnName = "weapon_combatpistol",
        type = "weapons",
        level = 3
    },
    { 
        id = 12,
        price = 136080,
        name = 'Saiga 12K',
        image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Armes/weapon_heavyshotgun.webp',
        stock = ArmesMaxStock.mafia["weapon_heavyshotgun"],
        spawnName = "weapon_heavyshotgun",
        type = "weapons",
        level = 4
    },
}

mafia = {
    name = "mafia",
    drogues = {
        {
            id = 1,
            price = 70,
            name = 'Methamphetamine',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/Drogues/methamphetamine.webp',
            spawnName = "meth",
            type = "drugs"
        },
        --{
        --    id = 1,
        --    price = 35,
        --    name = 'Methylamine',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/methylamine.webp",
        --    spawnName = "methylamine",
        --    type = "drugs"
        --},
        --{
        --    id = 2,
        --    price = 70,
        --    name = 'Ephédrine',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ephedrine.webp",
        --    spawnName = "ephedrine",
        --    type = "drugs"
        --},
        --{
        --    id = 3,
        --    price = 35,
        --    name = 'Phenylacetone',
        --    image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/phenylacetone.webp",
        --    spawnName = "phenylacetone",
        --    type = "drugs"
        --},
    },
    armes = {
    },
    autre = {
        --GPB
        {
            id = 4,
            price = 8520,
            name = 'Kevlar Léger 1',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville1.webp',
            spawnName = "keville1",
            type = "utils"
        },
        {
            id = 5,
            price = 8520,
            name = 'Kevlar Léger 2',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville2.webp',
            spawnName = "keville2",
            type = "utils"
        },
        {
            id = 6,
            price = 8520,
            name = 'Kevlar Léger 3',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville3.webp',
            spawnName = "keville3",
            type = "utils"
        },
        {
            id = 7,
            price = 8520,
            name = 'Kevlar Léger 4',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville4.webp',
            spawnName = "keville4",
            type = "utils"
        },

        {
            id = 8,
            price = 10500,
            name = 'Kevlar Moyen 1',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville9.webp',
            spawnName = "keville9",
            type = "utils"
        },
        {
            id = 9,
            price = 10500,
            name = 'Kevlar Moyen 2',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville10.webp',
            spawnName = "keville10",
            type = "utils"
        },
        {
            id = 10,
            price = 10500,
            name = 'Kevlar Moyen 3',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville11.webp',
            spawnName = "keville11",
            type = "utils"
        },
        {
            id = 11,
            price = 10500,
            name = 'Kevlar Moyen 4',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville12.webp',
            spawnName = "keville12",
            type = "utils"
        },

        {
            id = 12,
            price = 12870,
            name = 'Kevlar Lourd 1',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville5.webp',
            spawnName = "keville5",
            type = "utils"
        },
        {
            id = 13,
            price = 12870,
            name = 'Kevlar Lourd 2',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville6.webp',
            spawnName = "keville6",
            type = "utils"
        },
        {
            id = 14,
            price = 12870,
            name = 'Kevlar Lourd 3',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville7.webp',
            spawnName = "keville7",
            type = "utils"
        },
        {
            id = 15,
            price = 12870,
            name = 'Kevlar Lourd 4',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Tablette/GPB/keville8.webp',
            spawnName = "keville8",
            type = "utils"
        },
        {
            id = 16,
            price = 200,
            name = 'Munition d\'arme de poing',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ammobox_pistol.webp',
            spawnName = "ammobox_pistol",
            type = "utils"
        },
        {
            id = 17,
            price = 700,
            name = 'Munition de fusil d\'assaut',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ammobox_rifle.webp',
            spawnName = "ammobox_rifle",
            type = "utils"
        },
        {
            id = 18,
            price = 800,
            name = 'Munition d\'arme lourde',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/ammobox_heavy.webp',
            spawnName = "ammobox_heavy",
            type = "utils"
        }
    }
}

Drugs.crew = {
    {name = "TEST CREW", typeCrew = mc, wp = mcWeapon},
    {name = "NHH  NG", typeCrew = pf, wp = pfWeapon},
    {name = "Bayshore", typeCrew = pf, wp = pfWeapon},
    {name = "Brokers", typeCrew = pf, wp = pfWeapon},
    {name = "Shift Lock", typeCrew = pf, wp = pfWeapon},
    {name = "United Neihgboor Hood", typeCrew = pf, wp = pfWeapon},
    {name = "Punk Not Dead", typeCrew = pf, wp = pfWeapon},
    {name = "ZT-Summerhouse", typeCrew = pf, wp = pfWeapon},
    {name = "Totoro", typeCrew = pf, wp = pfWeapon},
    {name = "Les Enfants Perdus", typeCrew = pf, wp = pfWeapon},
    {name = "Inmates Guardian's", typeCrew = pf, wp = pfWeapon},
    {name = "701ST", typeCrew = pf, wp = pfWeapon},
    {name = "50 BOYZ", typeCrew = gang, wp = gangWeapon},
    {name = "Families ", typeCrew = gang, wp = gangWeapon},
    {name = "Les Rednecks", typeCrew = gang, wp = gangWeapon},
    {name = "90s Ballas Boyz", typeCrew = gang, wp = gangWeapon},
    {name = "Los Santos Vagos", typeCrew = gang, wp = gangWeapon},
    {name = "NSL18 AZTECAS", typeCrew = gang, wp = gangWeapon},
    {name = "Marabunta Grande", typeCrew = gang, wp = gangWeapon},
    {name = "Crimsons Gang", typeCrew = gang, wp = gangWeapon},
    {name = "F4L gang", typeCrew = gang, wp = gangWeapon},
    {name = "Road Dogs", typeCrew = mc, wp = mcWeapon},
    {name = "Sylvans", typeCrew = mc, wp = mcWeapon},
    {name = "Sons Of A narchy", typeCrew = mc, wp = mcWeapon},
    {name = "Grim Bastards", typeCrew = mc, wp = mcWeapon},
    {name = "Angels of Death", typeCrew = mc, wp = mcWeapon},
    {name = "Mayans MC", typeCrew = mc, wp = mcWeapon},
    {name = "DEVIL'S TRIBE MC", typeCrew = mc, wp = mcWeapon},
    {name = "Los Sicarios", typeCrew = orga, wp = orgaWeapon},
    {name = "Cartel de Coban", typeCrew = orga, wp = orgaWeapon},
    {name = "Patriots", typeCrew = orga, wp = orgaWeapon},
    {name = "Clan Holaho", typeCrew = orga, wp = orgaWeapon},
    {name = "Evan's Family", typeCrew = orga, wp = orgaWeapon},
    {name = "Reagan's Family", typeCrew = orga, wp = orgaWeapon},
    {name = "Black Mafia Family", typeCrew = orga, wp = orgaWeapon},
    {name = "BANDA CALDERON", typeCrew = orga, wp = orgaWeapon},
    {name = "Original Reynolds Family", typeCrew = mafia, wp = mafiaWeapon},
    {name = "Santa Blanca", typeCrew = mafia, wp = mafiaWeapon},
    {name = "McReary", typeCrew = mafia, wp = mafiaWeapon},
}

Drugs.cooldown = {
    --24h = 86400
    --pf
    ["plate"] = 432000,
    --gang
    ["weapon_bat"] = 172800,
    ["weapon_bottle"] = 172800,
    ["weapon_crowbar"] = 172800,
    ["weapon_golfclub"] = 172800,
    ["weapon_hatchet"] = 172800,
    ["weapon_knuckle"] = 172800,
    ["weapon_machete"] = 172800,
    ["weapon_nightstick"] = 172800,
    ["weapon_wrench"] = 172800,
    ["weapon_knife"] = 172800,
    ["weapon_switchblade"] = 172800,
    ["weapon_battleaxe"] = 172800,
    ["weapon_poolcue"] = 172800,
    ["weapon_canette"] = 172800,
    ["weapon_bouteille"] = 172800,
    ["weapon_pelle"] = 172800,
    ["weapon_pickaxe"] = 172800,
    ["weapon_sledgehammer"] = 172800,
    ["weapon_dagger"] = 172800,
    ["serflex"] = 172800,

    --mc
    ["weapon_pistol"] = 345600,
    ["weapon_vintagepistol"] = 345600,
    ["weapon_snspistol"] = 345600,
    ["weapon_dbshotgun"] = 518400,
    ["weapon_molotov"] = 604800,
    ["pincecoupante"] = 172800,
    
    --orga
    ["weapon_katana"] = 604800,
    ["weapon_combatpistol"] = 345600,
    ["weapon_heavypistol"] = 345600,
    ["weapon_revolver"] = 518400,
    ["weapon_doubleaction"] = 604800,

    ["weapon_microsmg"] = 604800,
    ["weapon_machinepistol"] = 604800,
    ["weapon_minismg"] = 604800,

    ["weapon_assaultshotgun"] = 604800,
    ["weapon_sawnoffshotgun"] = 518400,
    ["weapon_pumpshotgun"] = 604800, 
    ["weapon_heavyshotgun"] = 604800,

    --mafia
    ["weapon_pistol50"] = 518400,
    ["weapon_autoshotgun"] = 604800,
    ["weapon_combatshotgun"] = 864000, 
    ["weapon_compactrifle"] = 604800, 
    ["weapon_assaultrifle"] = 864000,
    ["weapon_gusenberg"] = 864000,
    ["weapon_smg"] = 604800,
    ["weapon_carbinerifle"] = 864000,
    ["weapon_specialcarbine"] = 864000,
}

Drugs.type = {
    ["pf"] = {typeCrew = pf, wp = pfWeapon},
    ["gang"] = {typeCrew = gang, wp = gangWeapon},
    ["mc"] = {typeCrew = mc, wp = mcWeapon},
    ["orga"] = {typeCrew = orga, wp = orgaWeapon},
    ["mafia"] = {typeCrew = mafia, wp = mafiaWeapon},
}

local info = {
    totalSpent = 0,
    totalCommands = 0,
    mostOrdered = ''
}

local ct
local store = {
    name = "",
    drogues = {
    },
    armes = {
    },
    autre = {
    }
}
local crewLevel, crewXp = 1, 0

function addWpOnStore(typeCrew)
    local typecrew
    store.armes = {}
    for k, v in pairs(Drugs.type[typeCrew].wp) do
        table.insert(store.armes, v)
    end    
end

function addWeaponOnStore(weapon)
    store.armes = {}
    for k, v in pairs(weapon) do
        if convertStringToBoolean(v.active) and tonumber(v.level) <= crewLevel then
            print(v.name, convertStringToBoolean(v.active), tonumber(v.level) <= crewLevel, convertStringToBoolean(v.active) and tonumber(v.level) <= crewLevel, false and true)
            table.insert(store.armes, {
                id = k,
                price = v.price,
                name = v.name,
                image = v.image,
                stock = v.stock,
                spawnName = v.spawnName,
                type = v.type,
                level = v.level
            })
        end
    end
    print("armes", json.encode(store.armes))
end

function addDrugsOnStore(drugs)
    store.drogues = {}
    for k, v in pairs(drugs) do
        if convertStringToBoolean(v.active) then
            print(v.name, convertStringToBoolean(v.active))
            table.insert(store.drogues, {
                id = k,
                price = v.price,
                name = v.name,
                image = v.image,
                stock = v.stock,
                spawnName = v.spawnName,
                type = v.type,
                level = v.level
            })
        end
    end
    print("drogues", json.encode(store.drogues))
end

function addAutresOnStore(autres)
    store.autre = {}
    for k, v in pairs(autres) do
        if convertStringToBoolean(v.active) and tonumber(v.level) <= crewLevel then
            table.insert(store.autre, {
                id = k,
                price = v.price,
                name = v.name,
                image = v.image,
                stock = v.stock,
                spawnName = v.spawnName,
                type = v.type,
                level = v.level
            })
        end
    end
    print("autre", json.encode(store.autre))
end

function createStore(typeCrew, variable)
    store.name = typeCrew
    for k, v in pairs(variable) do
        if k == "drogues" then
            addDrugsOnStore(v)
        elseif k == "autre" then
            addAutresOnStore(v)
        else
            addWeaponOnStore(v)
        end
    end
end

RegisterNetEvent("core:tabletteIllegalV1")
AddEventHandler("core:tabletteIllegalV1", function()
    if p:getCrew() == "None" then return end
    crewType = TriggerServerCallback("core:crew:getCrewTypeByName", p:getCrew())
    print(crewType)
    if crewType == "normal" then return end
    for k, v in pairs(Drugs.type) do
        if k == crewType then
            local crewVariable = GetVariable(crewType)
            print(json.encode(crewVariable))
            crewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", p:getCrew())
            crewXp = TriggerServerCallback("core:crew:getCrewXpByName", p:getCrew())
            while not crewLevel do Wait(1) end
            --store = v.typeCrew
            --addWpOnStore(crewType)
            createStore(typeCrew, crewVariable)
            print(json.encode(info, {indent= true}))
            if info.totalSpent == 0 and info.totalCommands == 0 and info.mostOrdered == '' then
                TriggerServerEvent("drugsDeliveries:getHistoryOrderServer", p:getCrew())
            end
            TriggerServerEvent("core:GetWeaponListCrew", p:getCrew(), crewLevel)
            local timer = 1
            while not receivedLastinfo do 
                Wait(100) 
                if timer > 20 then 
                    receivedLastinfo = true
                end
            end
            openIllegalTablet()
        end
    end
end)

local listWeaponMyCrew = {}
RegisterNetEvent("core:GetlistWeaponMyCrewClient")
AddEventHandler("core:GetlistWeaponMyCrewClient", function(data, timestamp)
    --print(store.name, json.encode(data))
    local typeCrew = TriggerServerCallback("core:crew:getCrewTypeByName", p:getCrew())
    --print(typeCrew)
    local crewVariable = GetVariable(typeCrew).armes
    listWeaponMyCrew = data
    for k,v in pairs(store.armes) do 
        for i,j in pairs(listWeaponMyCrew) do
            --print("Stock ", crewVariable[j.weapon].stock, j.quantity)
            if v.spawnName == j.weapon then
                v.stock = crewVariable[j.weapon].stock - j.quantity
                --print("Calcul", v.stock)
                if v.stock == 0 then
                    v.stock = nil
                    v.cooldown = (j.cooldown - timestamp)*1000
                    --TriggerServerEvent("core:StartCooldown", p:getCrew(), v.spawnName, Drugs.cooldown[v.spawnName])
                end
            end
        end
    end
end)

local crewName = ''--'Gouvernement'
local crewDesc = ''--'Vespucci - Trafic de drogues et d\'armes'
local crewInitials = ''--'LS'
local crewColor = ''--"#FF0000"
local crewMotto = ''--'Tip top coolos'

local orders = {}

local hourlyVariable

function getCrewInfo()
    crewInfo = TriggerServerCallback("core:crew:getCrewByName", p:getCrew())
    --print(crewInfo.name, crewInfo.devise, string.sub(crewInfo.name, 1, 1), crewInfo.color, crewInfo.devise)
    crewName = crewInfo.name
    crewDesc = crewInfo.devise
    crewInitials = string.sub(crewInfo.name, 1, 1)
    crewColor = crewInfo.color
    crewMotto =  crewInfo.devise
    hourlyVariable = GetVariable("hourly")
end

-- function getStore()
--     storeBdd = TriggerServerCallback("drugsDeliveries:getStore", token, p:getCrew()) --getStore todo get all object to sell for this crew
--     for k, v in pairs(storeBdd) do
--         if (store[v.ObjectType] == nil) then
--             store[v.ObjectType] = {}
--         end
--         store[v.ObjectType][k] = {}
--         store[v.ObjectType][k].id = k
--         store[v.ObjectType][k].price = v.price
--         store[v.ObjectType][k].name = v.name
--         store[v.ObjectType][k].image = v.image
--         store[v.ObjectType][k].spawnName = v.spawnName
--         store[v.ObjectType][k].type = v.typeObject
--     end
-- end

RegisterNetEvent("drugsDeliveries:getHistoryOrderClient") 
AddEventHandler("drugsDeliveries:getHistoryOrderClient", function(history) 
    --print("hist", history)
    local most = {}
    local i = 1
    for k, v in pairs(history) do
        --print("Order1", json.encode(v, {indent=true}))
        if v.crewName == p:getCrew() then
            orders[i] = {}
            orders[i].date = v.date.."+02:00"
            orders[i].price = v.total
            orders[i].type = v.typeObject
            orders[i]["items"] = {}
            for key, order in pairs(v.order) do
                --print("Order2", order.name, order.quantity)
                orders[i]["items"][key] = {}
                orders[i]["items"][key].name = order.name
                orders[i]["items"][key].quantity = order.quantity
                if (most[order.name] == nil) then
                    most[order.name] = {}
                    most[order.name].nbr = 0
                    most[order.name].name = order.name
                end
                most[order.name].nbr = most[order.name].nbr + order.quantity
            end
            info.totalSpent = info.totalSpent + v.total
            info.totalCommands = info.totalCommands + 1
            i = i + 1
        end
    end
    --print("Total commands", info.totalCommands, info.totalSpent)
    local nbrMost = 0
    for k, v in pairs(most) do
        --print(v, json.encode(v))
        if v.nbr > nbrMost then 
            nbrMost = v.nbr
            info.mostOrdered = v.name
        end
    end
    receivedLastinfo = true
end)

RegisterNUICallback("focusOut", function()
    if InsideTabletIllegal then 
        InsideTabletIllegal = false
        ExecuteCommand("e c")
    end
end)

function openIllegalTablet()
    getCrewInfo()
    InsideTabletIllegal = true
    --print("infoooooooooo", json.encode(orders),json.encode(info))
    print(json.encode(store, {indent = true}))
    ExecuteCommand("e tablet2")
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Tablette',
        data = {
            crewName = crewName,
            crewDesc = crewDesc,
            crewInitials = crewInitials,
            crewColor = crewColor,
            crewMotto = crewMotto,
            informations = info,
            crewXp = crewXp,
            crewLevel = crewLevel,
            orders = orders,
            shop = store,
            hourStart = tonumber(hourlyVariable.hourStart),
			minStart = tonumber(hourlyVariable.minStart),
			hourStop = tonumber(hourlyVariable.hourStop),
			minStop = tonumber(hourlyVariable.minStop)
        }
    }));
end

function AllCheck()
    return true
end

RegisterNetEvent('drugsDeliveries:saveCommandReturn')
AddEventHandler('drugsDeliveries:saveCommandReturn', function(value, order, total, typeObject)
    --print(value)
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    if value == true then
        if typeObject == "weapons" then
            --print(json.encode(order))
            TriggerServerEvent("core:AddWeaponListCrew", p:getCrew(), order)
        end
        --print(math.tointeger(total))
        --print(p:getCrew(), math.floor(math.tointeger(total)/100*2))
        TriggerSecurEvent("core:crew:updateXp", token, math.floor(math.tointeger(total) / 100 * 2), "add", p:getCrew(), "tablet")
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Tablette',
            data = {
                crewName = crewName,
                crewDesc = crewDesc,
                crewInitials = crewInitials,
                crewColor = crewColor,
                crewMotto = crewMotto,
                informations = info,
                crewLevel = crewLevel,
                orders = orders,
                shop = store,
                hourStart = tonumber(hourlyVariable.hourStart),
                minStart = tonumber(hourlyVariable.minStart),
                hourStop = tonumber(hourlyVariable.hourStop),
                minStop = tonumber(hourlyVariable.minStop),
                force = "Logout"
            }
        }));
    else
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Tablette',
            data = {
                crewName = crewName,
                crewDesc = crewDesc,
                crewInitials = crewInitials,
                crewColor = crewColor,
                crewMotto = crewMotto,
                informations = info,
                crewLevel = crewLevel,
                orders = orders,
                shop = store,
                hourStart = tonumber(hourlyVariable.hourStart),
                minStart = tonumber(hourlyVariable.minStart),
                hourStop = tonumber(hourlyVariable.hourStop),
                minStop = tonumber(hourlyVariable.minStop),
                errorMessage = value,
                force = "Shop"
            }
        }));
    end
end)

RegisterNUICallback("TabletteIllegale", function(data)
    -- local command = {}
    local typeObject = data.order[1].type
    ---- print(typeObject)
    ---- print(data.time)
    ---- print(data.total)
    -- for key, value in pairs(data.order) do
    ----     print(value.price)
    ----     print(value.quantity)
    ----     print(value.spawnName)
    ----     print('-----------')
    -- end
    ---- print(data.total)
    if AllCheck() then
        if p:pay(data.total) then
            --print('pay')
            TriggerServerEvent("drugsDeliveries:saveCommand", data, crewName, typeObject)
            --await return of drugsDeliveries:saveCommandReturn
            --TriggerServerEvent("drugsDeliveries:start", data.order, crewName, typeObject)
        else
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            --print('nopay')
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Tablette',
                data = {
                    crewName = crewName,
                    crewDesc = crewDesc,
                    crewInitials = crewInitials,
                    crewColor = crewColor,
                    crewMotto = crewMotto,
                    informations = info,
                    crewLevel = crewLevel,
                    orders = orders,
                    shop = store,
                    hourStart = tonumber(hourlyVariable.hourStart),
                    minStart = tonumber(hourlyVariable.minStart),
                    hourStop = tonumber(hourlyVariable.hourStop),
                    minStop = tonumber(hourlyVariable.minStop),
                    errorMessage = "Vous n'avez pas assez d'argent.",
                    force = "Shop"
                }
            }));
        end
    else
        --print('backStore')
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Tablette',
            data = {
                crewName = crewName,
                crewDesc = crewDesc,
                crewInitials = crewInitials,
                crewColor = crewColor,
                crewMotto = crewMotto,
                informations = info,
                crewLevel = crewLevel,
                orders = orders,
                shop = store,
                hourStart = tonumber(hourlyVariable.hourStart),
                minStart = tonumber(hourlyVariable.minStart),
                hourStop = tonumber(hourlyVariable.hourStop),
                minStop = tonumber(hourlyVariable.minStop),
                errorMessage = "erreur dans le traitement",
                force = "Shop"
            }
        }));
    end
end)


RegisterCommand("xpCrew", function(_, args)
    if p:getCrew() == nil or p:getCrew() == "None" then return end
    local xpCrew = TriggerServerCallback("core:crew:getCrewXpByName", p:getCrew())
    local xpCrewLevel = TriggerServerCallback("core:crew:getCrewLevelByName",  p:getCrew())
    print("xpCrew: " .. xpCrew .. ", crew level: " .. xpCrewLevel)
end)

RegisterCommand("getXpLevelGlobal", function(_, args)
        local xpCrewLevel = TriggerServerCallback("core:crew:getGlobalXp")
        print(json.encode(xpCrewLevel, {indent=true}))
end)