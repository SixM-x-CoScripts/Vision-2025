Fleeca = {
    {
        name = "Fleeca Place cube",
        door = {
            { pos = vector4(146.99, -1047.8515625, 29.51, 249.84620666504), hash = "v_ilev_gb_vauldr" } ---GrossePorte
        },
        anim = {
            firstDoor = {
                vector3(145.88307189941, -1048.8159179688, 28.392553329468), ---Insertion de la cle
                vector3(145.88307189941, -1048.8159179688, 28.392553329468), ---Ordinateur
                vector3(145.88307189941, -1048.8159179688, 28.392553329468) ---Recup de la clé
            },
            secondDoor = {
                vector3(149.28485107422, -1050.3739013672, 29.663038253784), ---Insertion de la cle
                vector3(149.28485107422, -1050.3739013672, 29.663038253784), ---Insertion de la cle
                vector3(149.28485107422, -1050.3739013672, 29.663038253784), ---Insertion de la cle
            },
            heading = 159.84616088867

        },
        trolley = {

            { pos = vector4(148.98341369629, -1051.4837646484, 28.346298217773, -108),
                money = vector3(148.98341369629, -1051.4837646484, 28.346298217773), loot = false },
            { pos = vector4(147.13446044922, -1050.8922119141, 28.346298217773, -15),
                money = vector3(147.13446044922, -1050.8922119141, 28.346298217773), loot = false },
            { pos = vector4(146.1202545166, -1052.0963134766, 28.346298217773, -15),
                money = vector3(146.1202545166, -1052.0963134766, 28.346298217773), loot = false },
        },
        cam = {
            firstDoor = {
                { pos = vector3(148.11157226563, -1046.1678466797, 28.34627532959),
                    lookAt = vector3(145.88307189941, -1048.8159179688, 28.392553329468), fov = 50.0 }, ---First Anim
                { pos = vector3(148.11157226563, -1046.1678466797, 28.34627532959),
                    lookAt = vector3(145.88307189941, -1048.8159179688, 28.392553329468), fov = 50.0 }, ---second Anim
                { pos = vector3(148.11157226563, -1046.1678466797, 28.34627532959),
                    lookAt = vector3(145.88307189941, -1048.8159179688, 28.392553329468), fov = 50.0 }, ---third Anim
            },
            secondDoor = {
                { pos = vector3(148.20764160156, -1050.1130371094, 28.34635925293),
                    lookAt = vector3(149.28485107422, -1050.3739013672, 29.663038253784), fov = 50.0 }, ---First Anim
                { pos = vector3(148.20764160156, -1050.1130371094, 28.34635925293),
                    lookAt = vector3(149.28485107422, -1050.3739013672, 29.663038253784), fov = 50.0 }, ---second Anim
                { pos = vector3(148.20764160156, -1050.1130371094, 28.34635925293),
                    lookAt = vector3(149.28485107422, -1050.3739013672, 29.663038253784), fov = 50.0 }, ---third Anim
            },
            trolley = {
                { pos = vector3(148.23928833008, -1047.1193847656, 29.765605926514),
                    lookAt = vector3(149.26947021484, -1052.5021972656, 28.346298217773), fov = 50.0 }, ---First trolley
                { pos = vector3(147.1163482666, -1050.0354003906, 29.61043548584),
                    lookAt = vector3(149.26947021484, -1052.5021972656, 28.346298217773), fov = 50.0 }, ---second trolley
                { pos = vector3(151.57299804688, -1046.3245849609, 29.697360992432),
                    lookAt = vector3(149.26947021484, -1052.5021972656, 28.346298217773), fov = 50.0 }, ---thirst trolley
            }
        },
        money = math.random(215, 235),
        ipFinished = false,
        HackSuccess = false,
        done = false,
    },
    {
        name = "Hawick Avenue",
        door = {
            {pos = vector4(311.33, -285.57, 54.3, 249.86599731445), hash = "v_ilev_gb_vauldr"} ---GrossePorte
        },
        anim = {
            firstDoor = {
                vector3(310.24716186523, -287.27462768555, 53.464782714844),---Insertion de la cle porte 1
                vector3(310.24716186523, -287.27462768555, 53.7), ---Ordinateur porte 1
                vector3(310.24716186523, -287.27462768555, 53.464782714844) ---Recup de la clé porte 1
            },
            secondDoor = {
                vector3(311.8283996582, -287.53176879883, 53.143009185791),---Insertion de la cle porte 2
                vector3(311.8283996582, -287.53176879883, 53.76),---Ordinateur porte 2
                vector3(311.8283996582, -287.53176879883, 53.143009185791),---Insertion de la cle porte 2
            },
            heading = 158.69375610352

        },
        trolley = {
            {pos = vector4(313.50540161133, -290.08053588867, 53.143035888672, -108), money =  vector3(313.50540161133, -290.08053588867, 53.143035888672) , loot = false}, ---loot petite salle
            {pos = vector4(311.24237060547, -289.17654418945, 53.143035888672, 161), money =  vector3(311.24237060547, -289.17654418945, 53.143035888672) , loot = false}, ---loot porte grande salle
            {pos = vector4(310.59222412109, -290.51943969727, 53.143035888672, 290), money =  vector3(310.59222412109, -290.51943969727, 53.143035888672) , loot = false}, ---loot fond grande salle
        },
        cam = { -- desac
            firstDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            secondDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            trolley = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.0241394043, -286.48098754883, 54.164703369141), fov = 50.0}, ---First Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(310.91323852539, -288.21435546875, 54.317314147949), fov = 50.0}, ---second Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(314.72799682617, -284.4020690918, 54.27571105957), fov = 50.0}, ---thirst Loot
            }
        },
        money = math.random(215, 235),
        ipFinished = false,
        HackSuccess = false,
        done = false,
    },
    {
        name = "Rockford",
        door = {
            {pos = vector4(-1209.8310546875, -337.25616455078, 36.780948638916, 296.86376953125), hash = "v_ilev_gb_vauldr"} ---GrossePorte
        },
        anim = {
            firstDoor = {
                vector3(-1209.4895019531, -339.24279785156, 36.794494628906),---Insertion de la cle porte 1
                vector3(-1209.4895019531, -339.24279785156, 36.994494628906), ---Ordinateur porte 1
                vector3(-1209.4895019531, -339.24279785156, 36.794494628906) ---Recup de la clé porte 1
            },
            secondDoor = {
                vector3(-1208.1859130859, -338.26425170898, 36.759254455566),---Insertion de la cle porte 2
                vector3(-1208.1859130859, -338.26425170898, 36.959254455566),---Ordinateur porte 2
                vector3(-1208.1859130859, -338.26425170898, 36.759254455566),---Insertion de la cle porte 2
            },
            heading = 158.69375610352
        },
        trolley = {
            {pos = vector4(-1205.25390625, -338.69110107422, 36.759254455566, -108), money =  vector3(-1205.25390625, -338.69110107422, 36.759254455566) , loot = false}, ---loot petite salle
            {pos = vector4(-1207.3182373047, -339.78881835938, 36.759254455566, 161), money =  vector3(-1207.3182373047, -339.78881835938, 36.759254455566) , loot = false}, ---loot porte grande salle
            {pos = vector4(-1206.9500732422, -341.02529907227, 36.759254455566, 290), money =  vector3(-1206.9500732422, -341.02529907227, 36.759254455566) , loot = false}, ---loot fond grande salle
        },
        cam = { -- desac
            firstDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            secondDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            trolley = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.0241394043, -286.48098754883, 54.164703369141), fov = 50.0}, ---First Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(310.91323852539, -288.21435546875, 54.317314147949), fov = 50.0}, ---second Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(314.72799682617, -284.4020690918, 54.27571105957), fov = 50.0}, ---thirst Loot
            }
        },
        money = math.random(215, 235),
        ipFinished = false,
        HackSuccess = false,
        done = false,
    },
    {
        name = "Fleeca GOH",
        door = {
            {pos = vector4(-2955.9501953125, 482.20, 14.697002410889, 357.84622192383), hash = "v_ilev_gb_vauldr"} ---GrossePorte
        },
        anim = {
            firstDoor = {
                vector3(-2953.7983398438, 481.68273925781, 14.742567062378),---Insertion de la cle porte 1
                vector3(-2953.7983398438, 481.68273925781, 14.992567062378), ---Ordinateur porte 1
                vector3(-2953.7983398438, 481.68273925781, 14.742567062378) ---Recup de la clé porte 1
            },
            secondDoor = {
                vector3(-2953.7993164063, 483.43716430664, 14.676209449768),---Insertion de la cle porte 2
                vector3(-2953.7993164063, 483.43716430664, 14.996209449768),---Ordinateur porte 2
                vector3(-2953.7993164063, 483.43716430664, 14.676209449768),---Insertion de la cle porte 2
            },
            heading = 158.69375610352
        },
        trolley = {
            {pos = vector4(-2954.8972167969, 483.18695068359, 14.697002410889, -108), money =  vector3(-2954.8972167969, 483.18695068359, 14.697002410889) , loot = false}, ---loot petite salle
            {pos = vector4(-2953.2731933594, 484.4010925293, 14.697002410889, 161), money =  vector3(-2953.2731933594, 484.4010925293, 14.697002410889) , loot = false}, ---loot porte grande salle
            {pos = vector4(0.720703125, 0.00207519531, 0.676209449768, 290), money =  vector3(0.720703125, 0.00207519531, 0.676209449768) , loot = false}, ---loot fond grande salle
        },
        cam = { -- desac
            firstDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            secondDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            trolley = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.0241394043, -286.48098754883, 54.164703369141), fov = 50.0}, ---First Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(310.91323852539, -288.21435546875, 54.317314147949), fov = 50.0}, ---second Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(314.72799682617, -284.4020690918, 54.27571105957), fov = 50.0}, ---thirst Loot
            }
        },
        money = math.random(205, 225),
        ipFinished = false,
        HackSuccess = false,
        done = false,
    },
    {
        name = "Fleeca Route 66",
        door = {
            {pos = vector4(1175.8791503906, 2713.7612304688, 37.087947845459, 90.000015258789), hash = "v_ilev_gb_vauldr"} ---GrossePorte
        },
        anim = {
            firstDoor = {
                vector3(1176.0207519531, 2715.7387695313, 37.11697769165),---Insertion de la cle porte 1
                vector3(1176.0207519531, 2715.7387695313, 37.99697769165), ---Ordinateur porte 1
                vector3(1176.0207519531, 2715.7387695313, 37.11697769165) ---Recup de la clé porte 1
            },
            secondDoor = {
                vector3(1174.48046875, 2715.4682617188, 37.066253662109),---Insertion de la cle porte 2
                vector3(1174.48046875, 2715.4682617188, 37.99253662109),---Ordinateur porte 2
                vector3(1174.48046875, 2715.4682617188, 37.066253662109),---Insertion de la cle porte 2
            },
            heading = 158.69375610352
        },
        trolley = {
            {pos = vector4(1172.2049560547, 2717.3596191406, 37.066253662109, -108), money =  vector3(1172.2049560547, 2717.3596191406, 37.066253662109) , loot = false}, ---loot petite salle
            {pos = vector4(1174.0278320313, 2717.2866210938, 37.066253662109, 161), money =  vector3(1174.0278320313, 2717.2866210938, 37.066253662109) , loot = false}, ---loot porte grande salle
            {pos = vector4(1174.6148681641, 2718.6528320313, 37.066253662109, 290), money =  vector3(1174.6148681641, 2718.6528320313, 37.066253662109) , loot = false}, ---loot fond grande salle
        },
        cam = { -- desac
            firstDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(311.27236938477, -284.34869384766, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            secondDoor = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---First Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---second Anim
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.78707885742, -284.53713989258, 54.164703369141), fov = 50.0}, ---thirst Anim
            },
            trolley = {
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(312.0241394043, -286.48098754883, 54.164703369141), fov = 50.0}, ---First Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(310.91323852539, -288.21435546875, 54.317314147949), fov = 50.0}, ---second Loot
                {pos = vector3(0.0, 0.0, 0.0), lookAt = vector3(314.72799682617, -284.4020690918, 54.27571105957), fov = 50.0}, ---thirst Loot
            }
        },
        money = math.random(205, 215),
        ipFinished = false,
        HackSuccess = false,
        done = false,
    }
}