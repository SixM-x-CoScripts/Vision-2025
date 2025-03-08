local contextObjectHandler = {
    [992069095] = { -- Machine à soda
        { icon = "Boisson", label = "Prendre un eCola", action = "UseVendingMachineCoca" }
    },

    [1114264700] = { -- Machine à sprunk
        { icon = "Boisson", label = "Prendre un Sprunk", action = "UseVendingMachineSprunk" }
    },
    [-1034034125] = { -- Machine à chips 1
        { icon = "Chips", label = "Prendre un paquet de chips", action = "UseVendingMachineChips" }
    },
    [-654402915] = { -- Machine à chips 2
        { icon = "Chips", label = "Prendre un paquet de chips", action = "UseVendingMachineChips" }
    },
    [690372739] = {
        { icon = "Boisson", label = "Prendre un café", action = "UseVendingMachineCoffee" }
    },
    [-1691644768] = {
        { icon = "Boisson", label = "Prendre de l'eau", action = "UseFontaine" }
    },
    [-874338148] = {
        { icon = "ramasser", label = "Ramasser la herse", action = "PickupHerse" },
    },
    [1729911864] = {
        { icon = "ramasser", label = "Ramasser la boombox", action = "PickupBoombox" },
        { icon = "fichier-blanc", label = "Utiliser la boombox", action = "OpenBoomBoxUI"},
    },
    [-669511193] = {
        { icon = "ramasser", label = "DEBUG", action = "deleteflat" },
    },
    [774094055] = { -- Bouteille wisky
        { text = "Prendre un verre", action = function(entity) ExecuteCommand("e whiskey") end }
    },
    [-1364697528] = { -- ATM
        { icon = "fichier-blanc", label = "Acceder à votre compte", action = "OpenAtmMenu" }
    },
    [-870868698] = { -- ATM
        { icon = "fichier-blanc", label = "Acceder à votre compte", action = "OpenAtmMenu" }
    },
    [-1126237515] = { -- ATM
        { icon = "fichier-blanc", label = "Acceder à votre compte", action = "OpenAtmMenu" }
    },
    [506770882] = { -- ATM
        { icon = "fichier-blanc", label = "Acceder à votre compte", action = "OpenAtmMenu" }
    },
    [-1194335261] = { -- SAC ARGENT
        { icon = "ramasser", label = "Ramasser le sac", action = "SACSuperette" }
    },
    [-628719744] = { --Banc Grtille
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-99500382] = { -- Banc Betton
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1805980844] = { -- Banc Betton
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-1317098115] = { -- Banc Betton
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-2021659595] = { -- Banc Betton
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1037469683] = { -- Chaise concess
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-741944541] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [725259233] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [525667351] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [764848282] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [146905321] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [276029927] = { -- Chaise concess
        { icon = "sit", label = "S'asseoir (normal)", action = "SitbenchMBA" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWaitMBA" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [784932497] = { -- Chaise concess
        { icon = "sit", label = "S'asseoir (normal)", action = "SitbenchMBA" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWaitMBA" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-1173315865] = { -- Chaise concess
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-721037220] = { -- Chaise concess
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [536071214] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-523951410] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-881696544] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1339364336] = {
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [867556671] = { -- Fauteuille concess
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-171943901] = { --Chaise plastic bleu
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-109356459] = { -- Chaise Cuire
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1580642483] = { -- Chaise Cuire
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-377849416] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-1281587804] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-829283643] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-634790943] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [444105316] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [696509779] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1570477186] = {
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },
    [-421052012] = { -- New mapping
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },
    [1631638868] = {
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },
    [2117668672] = {
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },
    [-1544802998] = {
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },

    [1004440924] = { -- Sundy Shore
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },

    [1573503690] = { -- Sundy Shore
        { icon = "brancarblanc", label = "S'allonger (mal de ventre)", action = "SleepOnHospital" },
        { icon = "brancarblanc", label = "S'allonger (sur le dos)", action = "SleepOnHospitalDos" },
        { icon = "brancarblanc", label = "S'allonger (sur le ventre)", action = "SleepOnHospitalVentre" },
        { icon = "brancarblanc", label = "S'asseoir (mal au coeur)", action = "SleepOnHospitalHeartAttack" },
        { icon = "brancarblanc", label = "Se lever", action = "StopAnim" },
    },

    [-1633198649] = { -- chaise tribunal
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1630899471] = { -- chaise tribunal
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1355718178] = { -- Chaise Cuir Commandant
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    -- system de pickup
    [1644278705] = {
        { icon = "ramasser", label = "Ramasser", action = "PickupItem" },
    },
    -- ChaiseRoulante
    [1262298127] = {
        { icon = "ramasser", label = "Ramasser", action = "DeleteWheelChair" },
    },
    -- Ramasser sapin Noel
    [238789712] = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserSapinNoel" },
    },
        -- brancard
    [682964899] = {
        { icon = "ramasser", label = "Ramasser", action = "deletebrancard" },
        { icon = "ramasser", label = "Baisser", action = "baisserbrancard" },
        { icon = "ramasser", label = "Pousser", action = "pushbrancard" },
        { icon = "ramasser", label = "Lacher", action = "releasebrancard" },
    },
        -- brancard abaissé
    [1453045878] = {
        { icon = "ramasser", label = "Ramasser", action = "deletebrancard" },
        { icon = "ramasser", label = "Relever", action = "releverbrancard" },
        { icon = "ramasser", label = "S'Allonger", action = "leanbrancard" },
        { icon = "ramasser", label = "Se lever", action = "releaseplayerleanbrancard" },
    },
    -- le miroir
    [-110460483] = { -- Chaise le miroir
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    -- bahamas
    [-552026043] = { -- tabouret
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-469102356] = { -- banquette
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    -- bayviewLodge
    [-1062810675] = { -- banc
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1064877149] = { -- chaise
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },

    -- YellowJack
    [-1199485389] = { -- canapé
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [-1829764702] = { -- tabouret
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [826023884] = { -- chaise
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },
    [1872312775] = { -- toilette
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },

    -- Sicarios
    [-1460572644] = { -- canapé
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },

    -- Domaine
    [2051175944] = { -- Chaise Intérieur
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },

    [1028260687] = { -- Chaise Exterieur
        { icon = "sit", label = "S'asseoir (normal)", action = "Sitbench" },
        { icon = "sit", label = "S'asseoir (attente)", action = "SitbenchWait" },
        { icon = "sit", label = "S'asseoir (beauf)", action = "SitbenchBeauF" },
        { icon = "sit", label = "S'asseoir (tranquille)", action = "SitbenchWithChill" },
        { icon = "sit", label = "Se lever", action = "StopAnim" },
    },


    -- Ramassage Barrière

    [GetHashKey("prop_barier_conc_05c")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work01b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work02a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work05")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work06a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work06b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_fncsec_04a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_mp_arrow_barrier_01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_mp_barrier_02b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_plas_barier_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04br")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04c")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04cr")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04d")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04dr")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04drx")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04dx")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04e")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04er")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04erx")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work04ex")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work06c")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work06d")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    -- Ramassage Cible 

    [GetHashKey("gr_prop_gr_target_05a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("gr_prop_gr_target_05b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Ramassage Cones

    [GetHashKey("prop_air_conelight")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_wat_03b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_mp_cone_03")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_mp_cone_04")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_roadcone02a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_roadcone02b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_roadpole_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_roadpole_01b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_trafficdiv_01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_trafficdiv_02")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Ramassage Divers

    [GetHashKey("gr_prop_gr_laptop_01c")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_ballistic_shield")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_gazebo_02")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("ex_office_swag_med2")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_ld_health_pack")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("sm_prop_smug_crate_m_medical")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("xm_prop_body_bag")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("xm_prop_smug_crate_s_medical")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("treasurechest")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_rad_waste_barrel_01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_wheelchair_01_s")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_lspdpio")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_lssdpio")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Event Palomba
    [GetHashKey("prop_test_rocks01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_tree_fallen_02")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_test_rocks04")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_test_rocks02")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Ramassage Drogues

    [GetHashKey("bkr_prop_bkr_cashpile_01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("bkr_prop_meth_openbag_02")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("bkr_prop_meth_smallbag_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("bkr_prop_moneypack_03a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("bkr_prop_weed_med_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("bkr_prop_weed_smallbag_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("ex_office_swag_drugbag2")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("imp_prop_impexp_boxcoke_01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("imp_prop_impexp_coke_pile")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Ramassage Lumière

    [GetHashKey("prop_generator_03b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_worklight_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_worklight_03b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_worklight_04a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_worklight_04b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Ramassage Panneaux

    [GetHashKey("prop_consign_01b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_02a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_sign_road_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_sign_road_03a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_sign_road_06a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_sign_road_06f")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_sign_road_06q")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_sign_road_06r")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_01")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_02")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_03")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_04")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_05")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_06")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_07")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_08")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_09")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_10")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_11")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_12")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_13")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_14")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_15")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_16")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_17")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_18")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_19")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_20")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_21")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_22")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_23")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_24")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_25")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_26")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_27")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_28")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_29")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_30")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_sign_custom")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_sign_detour")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_sign_stop")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work01b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_barrier_work02a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_custom")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_consign_flag_stop")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    

    -- Ramassage Sacs

    [GetHashKey("xm_prop_x17_bag_01c")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("xm_prop_x17_bag_med_01a")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

    -- Ramassage Tables

    [GetHashKey("bkr_prop_weed_table_01b")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },
    [GetHashKey("prop_ven_market_table1")]  = {
        { icon = "ramasser", label = "Ramasser", action = "ramasserProps" },
        { icon = "fichier-blanc", label = "Un/Freeze", action = "freezeProps" },
    },

}


function GetContextActionForObject(model, entity)
    if contextObjectHandler[model] ~= nil then
        return contextObjectHandler[model]
    else
        if entity then
            if contextObjectHandler[entity] ~= nil then
                return contextObjectHandler[entity]
            else
                return {}
            end
        else
            return {}
        end
    end
end

function GetContextActionForObjectV2(entity)
    local model = GetEntityModel(entity)
    local items = {}
    
    if contextObjectHandler[model] ~= nil then
        for k,v in pairs(contextObjectHandler[model]) do
            table.insert(items, {
                0,
                v.label,
                function() _G[v.action](entity) end
            })
        end
    else
        if entity then
            if contextObjectHandler[entity] ~= nil then
                for k,v in pairs(contextObjectHandler[entity]) do
                    table.insert(items, {
                        0,
                        v.label,
                        function() _G[v.action](entity) end
                    })
                end
            end
        end
    end

    return items
end

function InsertContextObjectHandler(entity, tbl)
    contextObjectHandler[entity] = tbl
    local model = GetEntityModel(entity)
    if contextObjectHandler[model] ~= nil then 
        table.insert(contextObjectHandler[model], tbl[1])
    end
end