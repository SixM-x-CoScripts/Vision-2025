--========================================================================================================================================================================-
--========================================================================================================================================================================-
--=========================================                                                                                      =========================================-                         
--=========================================                                                                                      =========================================-
--=========================================                                                                                      =========================================-
--========================================================================================================================================================================-
--========================================================================================================================================================================-



globalConfig = {

  language = 'fr', --change with 'en' for english, 'fr' for french, 'cz' for czech, 'de' for german




      --Set up new line to add a table, xyz are the coordinate, model is the props used as table. The 3 tables for armwrestling are 

                                                    -- 'prop_arm_wrestle_01' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_01a' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_02a' --

  props = { 
    {x = 974.91, y = -112.33, z = 74.35, model = 'bkr_prop_clubhouse_arm_wrestle_02a'},
    {x = -1484.98, y = -220.26, z = 50.87, model = 'bkr_prop_clubhouse_arm_wrestle_02a'},
    {x = 57.48, y = -1880.57, z = 22.2, model = 'prop_arm_wrestle_01'},
    {x = 393.91, y = -1924.2, z = 24.76, model = 'prop_arm_wrestle_01'},
    {x = 520.32, y = -1808.09, z = 28.51, model = 'prop_arm_wrestle_01'},
    {x = -7.31, y = -1475.23, z = 30.54, model = 'prop_arm_wrestle_01'},
    {x = -177.75, y = -1284.75, z = 31.3, model = 'prop_arm_wrestle_01'},
    {x = -356.23, y = -146.81, z = 37.24, model = 'prop_arm_wrestle_01'},
    {x = 163.48, y = -1290.96, z = 29.3, model = 'prop_arm_wrestle_01'},
  },

  showBlipOnMap = false, -- Set to true to show blip for each table

  blip = { --Blip info

    title="Arm wrestle",  
    colour=0, -- 
    id=1 

  }

}

text = { 
  ['en'] = {
    ['win'] = "You win !",
    ['lose'] = "You lost",
    ['full'] = "A wrestling match is already in progress",
    ['tuto'] = "To win, quickly press ",
    ['wait'] = "Waiting for an opponent",
  },
  ['fr'] = {
    ['win'] = "Victoire !",
    ['lose'] = "Défaite !",
    ['full'] = "Des personnes sont déjà entrain de jouer",
    ['tuto'] = "Pour jouer, appuyez rapidement sur ",
    ['wait'] = "En attente d'un adversaire",
  },
  ['cz'] = {
    ['win'] = "Vyhrál jsi !",
    ['lose'] = "Prohrál jsi",
    ['full'] = "Zápasový zápas již probíhá",
    ['tuto'] = "Chcete-li vyhrát, rychle stiskněte ",
    ['wait'] = "Čekání na protivníka",
  },
  ['de'] = {
    ['win'] = "Du hast gewinnen !",
    ['lose'] = "Du hast verloren",
    ['full'] = "Ein Wrestling Match ist bereits im Gange",
    ['tuto'] = "Um zu gewinnen, drücken Sie schnell ",
    ['wait'] = "Warten auf einen Gegner",
  },

}