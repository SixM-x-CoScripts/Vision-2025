local menuForJob = {
	["lspd"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			{ icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			--{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["bp"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			{ icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			--{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["lssd"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			{ icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			--{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["gcp"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			{ icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			--{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["usss"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			{ icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["boi"] = {
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" },
			{ icon = "Facture", label = "Donner une facture", action = "Factureboi" },
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" },
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" },
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" },
			--{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" },
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
		},
	},
	["lsfd"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "carteidentiteblanc", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- TODO
			{ icon = "Soigner", label = "Soigner", action = "HealthPatient" }, -- TODO
			{ icon = "coeurblanc", label = "Réanimer", action = "revivePatient" }, -- TODO
			{ icon = "coeurblanc", label = "Identification coma", action = "identificationComa" }, -- TODO
			{ icon = "Facture", label = "Facture", action = "FactureEms" }, -- TODO
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["ems"] = {
		ped = { 
			{ icon = "carteidentiteblanc", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- TODO
			{ icon = "Soigner", label = "Soigner", action = "HealthPatient" }, -- TODO
			{ icon = "coeurblanc", label = "Identification coma", action = "identificationComa" }, -- TODO
			{ icon = "coeurblanc", label = "Réanimer", action = "revivePatient" }, -- TODO
			{ icon = "Facture", label = "Facture", action = "FactureEms" }, -- TODO
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["bcms"] = {
		ped = { 
			{ icon = "carteidentiteblanc", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- TODO
			{ icon = "Soigner", label = "Soigner", action = "HealthPatient" }, -- TODO
			{ icon = "coeurblanc", label = "Identification coma", action = "identificationComa" }, -- TODO
			{ icon = "coeurblanc", label = "Réanimer", action = "revivePatient" }, -- TODO
			{ icon = "Facture", label = "Facture", action = "FactureEms" }, -- TODO
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["sams"] = {
		ped = { 
			{ icon = "carteidentiteblanc", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- TODO
			{ icon = "Soigner", label = "Soigner", action = "HealthPatient" }, -- TODO
			{ icon = "coeurblanc", label = "Identification coma", action = "identificationComa" }, -- TODO
			{ icon = "coeurblanc", label = "Réanimer", action = "revivePatient" }, -- TODO
			{ icon = "Facture", label = "Facture", action = "FactureEms" }, -- TODO
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["cayoems"] = {
		ped = { 
			{ icon = "carteidentiteblanc", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- TODO
			{ icon = "Soigner", label = "Soigner", action = "HealthPatient" }, -- TODO
			{ icon = "coeurblanc", label = "Réanimer", action = "revivePatient" }, -- TODO
			{ icon = "Facture", label = "Facture", action = "FactureEms" }, -- TODO
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["cardealerSud"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "concessFacture" }, -- TODO
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "fourriere", label = "Mettre véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
			{ icon = "info_veh", label = "Information véhicule", action = "showPlate" }, -- good
		},
	},
	["cardealerNord"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "concessNordFacture" }, -- TODO
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "fourriere", label = "Mettre véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
			{ icon = "info_veh", label = "Information véhicule", action = "showPlate" }, -- good
		},
	},
	["autoecole"] = {
		ped = { { icon = "Facture", label = "Donner une facture", action = "FactureAutoEcole" }, -- TODO
			{ icon = "Carte", label = "Attribuer le permis", action = "GivePermis" }, -- TODO
			{ icon = "Carte", label = "Attribuer le permis moto", action = "GivePermisMoto" }, -- TODO
			{ icon = "Carte", label = "Attribuer le permis camion", action = "GivePermisCamion" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["bennys"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Nettoyer le véhicule", action = "CleanVeh"},
			{ icon = "car", label = "Réparer la Carrosserie", action = "RepareCarosserie"},
			{ icon = "car", label = "Réparer le Moteur", action = "RepareVehMoteur"},
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["cayogarage"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Nettoyer le véhicule", action = "CleanVeh"},
			{ icon = "car", label = "Réparer la Carrosserie", action = "RepareCarosserie"},
			{ icon = "car", label = "Réparer le Moteur", action = "RepareVehMoteur"},
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["heliwave"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "concessFacture" }, -- TODO
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
			{ icon = "info_veh", label = "Information véhicule", action = "showPlate" }, -- good
		},
	},
	["hayes"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Nettoyer le véhicule", action = "CleanVeh"},
			{ icon = "car", label = "Réparer la Carrosserie", action = "RepareCarosserie"},
			{ icon = "car", label = "Réparer le Moteur", action = "RepareVehMoteur"},
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["beekers"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Nettoyer le véhicule", action = "CleanVeh"},
			{ icon = "car", label = "Réparer la Carrosserie", action = "RepareCarosserie"},
			{ icon = "car", label = "Réparer le Moteur", action = "RepareVehMoteur"},
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["sunshine"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Nettoyer le véhicule", action = "CleanVeh"},
			{ icon = "car", label = "Réparer la Carrosserie", action = "RepareCarosserie"},
			{ icon = "car", label = "Réparer le Moteur", action = "RepareVehMoteur"},
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre le véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["harmony"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Nettoyer le véhicule", action = "CleanVeh"},
			{ icon = "car", label = "Réparer la Carrosserie", action = "RepareCarosserie"},
			{ icon = "car", label = "Réparer le Moteur", action = "RepareVehMoteur"},
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre le véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["ocean"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureMechano" }, -- TODO
			--{ icon = "move", label = "Suivant", action = "contextMenuPage2" }, -- good

		},
		veh = {
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "fourriere", label = "Mettre le véhicule en fourrière", action = "SetVehicleInFourriere" }, -- TODO
			{ icon = "car", label = "Ouvrir les customs du véhicule", action = "OpenCustomVehMenu" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["bahamas"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "bahamasFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["vclub"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "vclubFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["club77"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "vclubFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
    },
	["skyblue"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "burgerFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["rexdiner"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "burgerFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["burgershot"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "burgerFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["tacosrancho"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "tacosFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},

	["ltdsud"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "ltdsudFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},

	["ltdseoul"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "ltdseoulFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},

	["ltdmirror"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "ltdMirrorFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["sushistar"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "ShushiStarFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["mayansclub"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "MayansFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["lucky"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "luckyFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["athena"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "AthenaFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["mostwanted"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "MostWantedFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVeh" }, -- good
		},
	},
	["unicorn"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "UnicornFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["royalhotel"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "RoyalHotelFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["weazelnews"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureWeazelNews" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["lifeinvader"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureWeazelNews" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["realestateagent"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureAgentImmo" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["justice"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureJustice" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["pawnshop"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FacturePawnShop" }, -- TODO
			{ icon = "Facture", label = "Envoyé de l'argent", action = "SendMoneyPawnShop" }, -- TODO
			

		},
		veh = {
			{ icon = "info_veh", label = "Changer le propriétaire", action = "ChangePropertyCar" }, -- TODO
			{ icon = "info_veh", label = "Changer le propriétaire (Crew)", action = "ChangePropertyCarCrew" }, -- TODO
			{ icon = "info_veh", label = "Changer le propriétaire (Job)", action = "ChangePropertyCarJOb" }, -- TODO
			{ icon = "info_veh", label = "Ajouter un co-propriétaire", action = "AddCoOwnerCar" }, -- TODO
			{ icon = "info_veh", label = "Information véhicule", action = "InfoVehPawnshop" }, -- good
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlatePawnshop" }, -- good
			{ icon = "car", label = "Crocheter", action = "HookVehiclePawnshop" }, -- TODO
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			--{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			--{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["casse"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureCasse" },
			
		},
		veh = {
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["tequilala"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "TequilalaFacture" },
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["uwu"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "UWUFacture" },
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["pizzeria"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "Facture" },
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["pearl"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "Facture" },
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["upnatom"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "Facture" },
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["hornys"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "Facture" },
			
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["tattooSud"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureTattoo" },
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["tattooNord"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureTattoo" },
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["tattooCayo"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureTattoo" },
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["amerink"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "FactureTattoo" },
		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["comrades"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "ComradesFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["sultan"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "sultanFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["mirror"] = {
		ped = {
			{ icon = "Facture", label = "Donner une facture", action = "MirrorFacture" }, -- TODO
			

		},
		veh = {
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
	},
	["g6"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			-- { icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			--{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
	["usmc"] = {
		veh = {
			{ icon = "car", label = "Crocheter", action = "HookVehicleLSPD" }, -- TODO
			{ icon = "search", label = "Inspecter", action = "InfoVehLSPD" },
			{ icon = "plate", label = "Relever l'immatriculation", action = "GetVehiclePlate" }, -- good
			{ icon = "fourriere", label = "Mettre en fourrière", action = "SetVehicleInFourriere" },
			{ icon = "car", label = "Rentrer dans le coffre", action = "putInTrunk" },
			{ icon = "car", label = "Ouvrir le capot", action = "openHood" },
			{ icon = "car", label = "Ouvrir le coffre", action = "openTrunk" },
			{ icon = "car", label = "Verouiller / Déverouiller", action = "useKey" },
		},
		ped = {
			{ icon = "CROIX", label = "Vérifier l'identité", action = "getPatientIdentityCard" }, -- good
			{ icon = "Fouiller", label = "Fouiller (JOB)", action = "StartSearchOnPlayer" }, -- good
			{ icon = "handcuff", label = "Menotter/Démenotter", action = "CuffPlayer" }, -- good
			-- { icon = "mettre_voiture", label = "Sortir/Mettre dans le véhicule", action = "PlacePlayerIntoVehicle" }, -- good
			-- { icon = "Carte", label = "Gérer les permis", action = "PermisPolice" }, -- TODO
			--{ icon = "Facture", label = "Faire une facture", action = "MakeBillingPolice" }, -- TODO
			{ icon = "move", label = "Déplacer", action = "MoovePlayerCuffed" }, -- good
			{ icon = "move", label = "ID Joueur", action = "ShowIds" },
			

		}
	},
}

local SamePedEmotes = {
	{ "S'asseoir sur une chaise", "e sitchair" },
	{ "S'asseoir par terre", "e sitground" },
	{ "Se rendre à genoux", "e surrender" },
	{ "Pisser", "e pee" },
}

local PedEmotes = {
	{ "Massage cardique", "nearby cprs" },
	{ "Prendre en otage", "nearby hostage" },
	{ "Gifler", "nearby slap" }
}

function GetSamePedEmotes(submenu)
	local actions = {}

	for i, emote in ipairs(SamePedEmotes) do
		table.insert(actions, {
			submenu,
			emote[1],
			function() ExecuteCommand(emote[2]) end
		})
	end

	return actions
end

function GetPedEmotes(submenu)
	local actions = {}

	for i, emote in ipairs(PedEmotes) do
		table.insert(actions, {
			submenu,
			emote[1],
			function() ExecuteCommand(emote[2]) end
		})
	end

	return actions
end


function GetContextVehActionByJob(job)
	if menuForJob[job] ~= nil then
		return menuForJob[job].veh
	else
		return {}
	end
end

function isVehActionsAvailable(job)
	if menuForJob[job] ~= nil then
		return true
	else
		return false
	end
end

function GetContextVehActionByJobV2(submenu, job, entity)
    if menuForJob[job] and menuForJob[job].veh ~= nil then
        local actions = {}

        for i, action in ipairs(menuForJob[job].veh) do
            table.insert(actions, {
                submenu,
                action.label,
                function() _G[action.action](entity) end
            })
        end

        return actions
    else
        return nil
    end
end

function isPedActionsAvailable(job)
	if menuForJob[job] ~= nil then
		return true
	else
		return false
	end
end

function GetContextPedActionByJob(job)
	if menuForJob[job] ~= nil then
		return menuForJob[job].ped
	else
		return {}
	end
end

function GetContextPedActionByJobV2(submenu, job, entity)
	if menuForJob[job] ~= nil and menuForJob[job].ped ~= nil then
		local actions = {}

		-- return a list of {menuId, title, action} 
		-- Action includes the entity as argument
		for i, action in ipairs(menuForJob[job].ped) do
			table.insert(actions, {
				submenu,
				action.label,
				function() _G[action.action](entity) end
			})
		end

		return actions
	else
		return nil
	end
end
