radars = {
    {name = "Capital Boulevard", speed = 80, pos = vector3(659.70391845703, -1436.5201416016, 30.029417037964)},
    {name = "Vespucci Boulevard", speed = 80, pos = vector3(221.89099121094, -1040.3817138672, 28.365791320801)},
    {name = "Carson Avenue", speed = 80, pos = vector3(-25.28130531311, -1607.8168945313, 28.285667419434)},
    {name = "Calais Avenue", speed = 80, pos = vector3(-531.31414794922, -1076.3690185547, 21.451322555542)},
    {name = "San Andreas Avenue #1", speed = 80, pos = vector3(-1081.2312011719, -762.75006103516, 18.360164642334)},
    {name = "Dorset Drive", speed = 80, pos = vector3(-1036.9223632813, -191.12382507324, 36.855308532715)},
    {name = "San Andreas Avenue #2", speed = 80, pos = vector3(-256.15753173828, -665.12145996094, 32.255260467529)},
    {name = "Vinewood Boulevard", speed = 80, pos = vector3(202.8935546875, 194.89936828613, 104.56754302979)},
    {name = "Tongva Drive", speed = 110, pos = vector3(-1751.3360595703, 810.55444335938, 140.4365234375)},
    {name = "Route 1 #1", speed = 150, pos = vector3(-2607.4855957031, 2969.5368652344, 15.657499313354)},
    {name = "Route 1 #2", speed = 110, pos = vector3(-373.47537231445, 6001.5927734375, 30.383007049561)},
    {name = "Route 13 #1", speed = 150, pos = vector3(2687.2700195313, 4856.6118164063, 32.481967926025)},
    {name = "Route 13 #2", speed = 150, pos = vector3(2015.5157470703, 2582.1186523438, 53.443691253662)},
    {name = "Joshua Road", speed = 110, pos = vector3(535.87670898438, 3503.4982910156, 33.204967498779)},
}

config = {}

config.speed = 'km' -- "mph" or "km"

config.radarRange = 20

config.flashSound = "https://youtu.be/JZvnthWeiZc"

config.sendLog = true
config.webhook = "https://discord.com/api/webhooks/1148258711240982668/SoZzZYqAqOtn0Cb0Poyhefsttp1FW5qSvdq8APGOow3k8UQHN3yyBZzzbjuB59UC5xQo"

config.jobs = {"lspd", "usss", "lsfd", "lssd", "ems", "bcms"}
config.takeIfNotInService = true