Config = {
	Framework = 0, --[ 1 = ESX / 2 = QBCore / 3 = Other ] Choose your framework

	FrameworkTriggers = {
		notify = '', -- [ ESX = 'esx:showNotification' / QBCore = 'QBCore:Notify' ] Set the notification event, if left blank, default will be used
		object = '', --[ ESX = 'esx:getSharedObject' / QBCore = 'QBCore:GetObject' ] Set the shared object event, if left blank, default will be used (deprecated for QBCore)
		resourceName = '', -- [ ESX = 'es_extended' / QBCore = 'qb-core' ] Set the resource name, if left blank, automatic detection will be performed
	},

	--[[
		This automatically adds a help point to Burton bowling alley,
		helping players get to the bowling alley and teaches them the basic rules
		and physics.

		This feature requires https://store.rcore.cz/package/5041989, but bowling works great without it.
	]]
	EnableGuidebookIntegration = false,

	--[[
		Further blip configuration (scale, sprite, color)
		can be made directly in client/blip.lua
	]]
	Blips = {
		-- vector3(-149.44, -258.21, 44.14), -- breze bowling map
		vector3(749.92, -776.68, 26.33), -- gabz bowling map
	},

	AllowWager = true,
	ScoreboardCommand = 'bowling',
	Text = {
		BLIP = 'Bowling',

		REGISTER_LANE = '~INPUT_PICKUP~ Créer une nouvelle partie~n~~INPUT_SPRINT~ + ~INPUT_PICKUP~ Créer une nouvelle équipe',
		JOIN_LANE = '~INPUT_PICKUP~ Rejoindre la partie',
		PLAY = '~INPUT_PICKUP~ Jouer',
		OPEN = '~INPUT_PICKUP~ Ouvrir',
		TAKE_BALL = '~INPUT_PICKUP~ Prendre la boule',

		NOT_IN_GAME = 'Vous ne jouez pas actuellement au bowling.',
		NOT_ENOUGH_MONEY = 'Vous n\'avez pas assez d\'argent pour payer votre pari.',
		INPUT_POSITION = 'Sélectionner la postion initiale de la ~y~boule de bowling~s~',
		INPUT_ROTATION = 'Sélectionner une boule ~y~spin~s~',
		INPUT_ANGLE = "Sélectionner ~y~l'angle de projection~s~",
        INPUT_POWER = 'Sélectionner ~y~la puissance de projection~s~',
		
        TOTAL = "Total",
        MATCH_END = "La partie est terminée dans {0} secondes",
		MATCH_WHO_WON = "{0} gagne ${1}",

		START = "Commencer",
		CLOSE = "Fermer",
		JOIN = "Rejoindre",
		REGISTER = "S\'enregistrer",
		WAGER = "Parier",
		WAGER_SET_TO = "Le parie est mit à <b>${0}</b>",
		INPUT_CONFIRM = "~INPUT_ATTACK~ Confirmer",
		ROUND_COUNT = "Nombre de manches",
		TEAM = "Equipe",
		PLAYER = "Joueur",
		TEAM_NAME = 'Nom d\'équipe',
		YOUR_NAME = 'Votre nom',
	},
	ThrowWait = 1800,
}

POINTS_BREZE = {
    LEFT = {
        {vector3(0.0, 0.0, 0.0), 3.0, 0.0},
        {vector3(0.05000305, 0.1100159, 0.4399986), 3.0, 0.0},
        {vector3(0.2600098, 0.7700195, 0.579998), 1.0, -90.0},
        {vector3(0.2600098, 0.7700195, 0.5599976), 1.0, -90.0}, 
        {vector3(0.480011, 0.6900024, 0.5599976), 1.0, -90.0},
        {vector3(1.059998, 2.340012, 0.5599976), 1.0, 0.0}
    },
    RIGHT = {
        {vector3(0, 0, 0), 3.0, 0.0},
        {vector3(0.05000305, 0.1100159, 0.4399986), 3.0, 0.0},
        {vector3(0.2600098, 0.7700195, 0.579998), 1.0, -90.0},
        {vector3(0.2600098, 0.7700195, 0.5599976), 1.0, -90.0}, 
        {vector3(0.08000183, 0.8400269, 0.5599976), 1.0, -90.0},
        {vector3(0.6500092, 2.490021, 0.5599976), 1.0, 0.0}
    }
}

POINTS_GABZ = {
    RIGHT = {
		{vector3(0, 0, 0), 6.0, 270.0},
		{vector3(0.1600342, 0, -0.2099991), 6.0, 270.0},
		{vector3(0.2999878, 0, -0.3500004), 6.0, 270.0},
		{vector3(0.460022, 0, -0.4599991), 6.0, 270.0},
        {vector3(0.7000122, 0, -0.5100002), 6.0, 270.0},
        {vector3(17.04004, 0.01000977, -0.4599991), 5.5, 270.0},
        {vector3(17.23004, 0.01000977, -0.4300003), 4.0, 270.0},
		{vector3(17.40002, 0.01000977, -0.2999992), 3.5, 270.0},
        {vector3(17.64001, 0.01000977, -0.07999992), 3.0, 270.0},
        {vector3(17.71002, 0.01000977, -0.02999878), 2.5, 270.0},
        {vector3(17.85004, 0.01000977, 0.04000092), 2.0, 270.0},
        {vector3(18.13, 0.01000977, 0.06999969), 1.5, 270.0},
        {vector3(18.39001, 0.01000977, 0.06999969), 1.0, 270.0},
        {vector3(18.85999, 0.01000977, 0.06999969), 1.0, 270.0},
    },
    LEFT = {
		{vector3(0, 0, 0), 6.0, 270.0},
		{vector3(0.1600342, 0, -0.2099991), 6.0, 270.0},
		{vector3(0.2999878, 0, -0.3500004), 6.0, 270.0},
		{vector3(0.460022, 0, -0.4599991), 6.0, 270.0},
        {vector3(0.7000122, 0, -0.5100002), 6.0, 270.0},
        {vector3(17.04004, 0.01000977, -0.4599991), 5.5, 270.0},
        {vector3(17.23004, 0.01000977, -0.4300003), 4.0, 270.0},
		{vector3(17.40002, 0.01000977, -0.2999992), 3.5, 270.0},
        {vector3(17.64001, 0.01000977, -0.07999992), 3.0, 270.0},
        {vector3(17.71002, 0.01000977, -0.02999878), 2.5, 270.0},
        {vector3(17.85004, 0.01000977, 0.04000092), 2.0, 270.0},
        {vector3(18.13, 0.01000977, 0.06999969), 1.5, 270.0},
        {vector3(18.39001, 0.01000977, 0.06999969), 1.0, 270.0},
        {vector3(18.85999, 0.01000977, 0.06999969), 1.0, 270.0},
    },
}

Lanes = {
    GABZ_1 = {
		Place = 'LMESA',
		IsClosestToDoor = true,
		Start = vector3(746.89, -781.84, 25.45),
		End = vector3(728.26, -781.84, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'RIGHT',
		SourceRoot = vector3(728.61, -780.8, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(18.88999 + 0.075, 0.01000977, 0.06999969),
	},
    
    GABZ_2 = {
		Place = 'LMESA',
		Start = vector3(746.89, -781.84 + 2.085, 25.45),
		End = vector3(728.26, -781.84 + 2.085, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'LEFT',
		SourceRoot = vector3(728.61, -780.8, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(18.88999 + 0.075, 0.01000977, 0.06999969),
	},
    
    GABZ_3 = {
		Place = 'LMESA',
		Start = vector3(746.89, -781.84 + 2.087 * 2, 25.45),
		End = vector3(728.26, -781.84 + 2.087 * 2, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'RIGHT',
		SourceRoot = vector3(728.61, -780.8 + 4.17, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(18.53599 + 0.075, 0.01000977, 0.06999969),
	},
    GABZ_4 = {
		Place = 'LMESA',
		Start = vector3(746.89, -781.84 + 2.0875 * 3, 25.45),
		End = vector3(728.26, -781.84 + 2.0875 * 3, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'LEFT',
		SourceRoot = vector3(728.61, -780.8 + 4.17, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(18.53599 + 0.075, 0.01000977, 0.06999969),
	},
    
    GABZ_5 = {
		Place = 'LMESA',
		Start = vector3(746.89, -781.84 + 2.0875 * 4, 25.45),
		End = vector3(728.26, -781.84 + 2.0875 * 4, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'RIGHT',
		SourceRoot = vector3(728.61, -780.8 + 4.17*2, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(19.120999 + 0.075, 0.01000977, 0.06999969),
	},
    GABZ_6 = {
		Place = 'LMESA',
		Start = vector3(746.89, -781.84 + 2.0875 * 5, 25.45),
		End = vector3(728.26, -781.84 + 2.0875 * 5, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'LEFT',
		SourceRoot = vector3(728.61, -780.8 + 4.17*2, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(19.120999 + 0.075, 0.01000977, 0.06999969),
	},
    GABZ_7 = {
		Place = 'LMESA',
		Start = vector3(746.89, -781.84 + 2.0875 * 7, 25.45),
		End = vector3(728.26, -781.84 + 2.0875 * 7, 25.45),
		Width = 0.624,
		GutterWidth = 0.75,
		GutterDepth = 0.05,
		PinDistance = 17.1,
		PinSideSpace = 0.34,
		SourcePoints = POINTS_GABZ,
		SourceSide = 'LEFT',
		SourceRoot = vector3(728.61, -780.8 + 4.175*3, 26.06),
		BallPickupOffsetMultiplier = -0.6,
		BallPickupZOffset = -0.6,
		LastRackBallPos = vector3(18.83199 + 0.075, 0.01000977, 0.06999969),
	},
    
}