local gradeIndex = 1
local tenueIndex = 1
local civilCloths = {}
local jobs = {}
local jobIndex = 0
local newJob = {
    label = "template",
    name = "template",
    moneyPerNpc = 0,
    actionEntreprise = vector3(0.0, 0.0, 0.0),
    clothsPos = vector3(0.0, 0.0, 0.0),
    grade = {
        {grade = 1, label = "template",   gestion = false,    salaire = 50, coffre = false},
    },
    cloths = {
        {grade = 1, label = "Nouvelle tenue", cloths = {}, women = false},
    }
}
local allowedTypeForCloth = {
    ["tshirt_1"] = true,
    ["tshirt_2"] = true,
    ["torso_1"] = true,
    ["torso_2"] = true,
    ["arms"] = true,
    ["arms_2"] = true,
    ["decals_1"] = true,
    ["decals_2"] = true,
    ["pants_1"] = true,
    ["pants_2"] = true,
    ["shoes_1"] = true,
    ["shoes_2"] = true,
    ["mask_1"] = true,
    ["mask_2"] = true,
    ["bproof_1"] = true,
    ["bproof_2"] = true,
    ["chain_1"] = true,
    ["chain_2"] = true,
    ["bags_1"] = true,
    ["bags_2"] = true,
    ["helmet_1"] = true,
    ["helmet_2"] = true,
}

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t 
end)

function HandleStaffMenu(staff, jobCreate, gradeCreate, tenueCreate, jobList, jobEdit, jobEditGrade, jobEditCloths)
    RageUI.IsVisible(staff, function()
        for k,v in pairs(staff_menu) do
            RageUI.Button(v.label, nil, {}, true, {
            }, v.menu)
        end
    end)

    for k,v in pairs(staff_menu) do
        RageUI.IsVisible(v.menu, function()
            if not v.customData then
                for _,self in pairs(v.data) do
                    RageUI.Button(self.label, nil, {}, true, {
                        onSelected = function()
                            self.action()
                        end,
                    });
                end
            else
                if v.label == "Jobs" then
                    RageUI.Button("Crée un nouveau job", nil, {}, true, {}, jobCreate)
                    RageUI.Button("Liste des jobs", nil, {}, true, {
                        onSelected = function()
                            jobs = TriggerServerCallback("core:GetJobList")
                        end,
                    }, jobList)
                end
            end
        end)
    end

    RageUI.IsVisible(jobList, function()
        for k,v in pairs(jobs) do
            RageUI.Button(v.label, nil, {}, true, {
                onSelected = function()
                    jobIndex = k
                end,
            }, jobEdit)  
        end
    end)

    RageUI.IsVisible(jobEdit, function()
        self = jobs[jobIndex]
        RageUI.Button("> Name", nil, {RightLabel = "("..tostring(self.name)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Job: name")
                if text ~= nil then
                    self.name = text
                end
            end,
        })
        RageUI.Button("> Label", nil, {RightLabel = "("..tostring(self.label)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Job: Label")
                if text ~= nil then
                    self.label = text
                end
            end,
        })
        RageUI.Button("> Argent par mission NPC", nil, {RightLabel = "("..tostring(self.moneyPerNpc)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Job: Argent")
                if text ~= nil then
                    self.moneyPerNpc = tonumber(text)
                end
            end,
        })
        RageUI.Button("> Action patron", "Position des actions patron", {RightLabel = "("..tostring(self.actionEntreprise)..")"}, true, {
            onSelected = function()
                self.actionEntreprise = p:pos()
            end,
        })
        RageUI.Button("> Position véstiaire", "Position des actions patron", {RightLabel = "("..tostring(self.clothsPos)..")"}, true, {
            onSelected = function()
                self.clothsPos = p:pos()
            end,
        })


        RageUI.Separator("Grades")

        RageUI.Button("~g~Ajouter un grade", nil, {}, true, {
            onSelected = function()
                table.insert(self.grade, {grade = #self.grade + 1, label = "template",   gestion = false,    salaire = 50, coffre = false})
            end,
        })

        for k,v in pairs(self.grade) do
            RageUI.Button("[~b~"..v.grade.."~s~] - "..v.label.." (~g~"..v.salaire.."~s~$)", "Gestion: "..tostring(v.gestion).." - Acces coffre: "..tostring(v.coffre), {}, true, {
                onSelected = function()
                    gradeIndex = k
                end,
            }, jobEditGrade)
        end

        RageUI.Separator("Tenues")
        RageUI.Button("~g~Ajouter une tenue", nil, {}, true, {
            onSelected = function()
                table.insert(self.cloths,  {grade = 1, label = "Nouvelle tenue", women = false, cloths = {}})
            end,
        })
        for k,v in pairs(self.cloths) do
            RageUI.Button("[~b~"..v.grade.."~s~] - "..v.label, nil, {}, true, {
                onSelected = function()
                    tenueIndex = k
                end,
            }, jobEditCloths)
        end

        
        RageUI.Separator("Valider la modification")

        RageUI.Button("> Modifier le job", nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("core:UpdateJob", token, jobIndex, self)
            end,
        }) 
    end)


    RageUI.IsVisible(jobEditGrade, function()
        local self = jobs[jobIndex].grade[gradeIndex]
        RageUI.Button("> ID Grade", nil, {RightLabel = "("..tostring(self.grade)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: ID")
                if text ~= nil then
                    self.grade = tonumber(text)
                end
            end,
        })
        RageUI.Button("> Label", nil, {RightLabel = "("..tostring(self.label)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: Label")
                if text ~= nil then
                    self.label = text
                end
            end,
        })
        RageUI.Button("> Salaire", nil, {RightLabel = "("..tostring(self.salaire)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: salaire")
                if text ~= nil then
                    self.salaire = tonumber(text)
                end
            end,
        })
        RageUI.Button("> Accès gestion", nil, {RightLabel = "("..tostring(self.gestion)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: gestion (true/false)")
                if text ~= nil then
                    if text == "true" then
                        self.gestion = true
                    else
                        self.gestion = false
                    end
                end
            end,
        })
        RageUI.Button("> Accès coffre", nil, {RightLabel = "("..tostring(self.coffre)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: coffre (true/false)")
                if text ~= nil then
                    if text == "true" then
                        self.coffre = true
                    else
                        self.coffre = false
                    end
                end
            end,
        })
    end)
    

    RageUI.IsVisible(jobEditCloths, function()
        local self = jobs[jobIndex].cloths[tenueIndex]
        RageUI.Button("> ID Grade", "Toute personnes ayant le grade ou en dessus pourra mettre la tenue", {RightLabel = "("..tostring(self.grade)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Tenue: ID")
                if text ~= nil then
                    self.grade = tonumber(text)
                    -- ShowNotification("ID mis à jours")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s ID mis à jour"
                    })

                end
            end,
        })

        RageUI.Button("> Label", nil, {RightLabel = "("..tostring(self.label)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Tenue: Label")
                if text ~= nil then
                    self.label = text
                    -- ShowNotification("Label mis à jours")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Label mis à jours"
                    })

                end
            end,
        })
        RageUI.Button("> Tenue pour femme", nil, {RightLabel = "("..tostring(self.women)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Tenue: pour femme ? (true/false)")
                if text ~= nil then
                    if text == "true" then
                        self.women = true
                    else
                        self.women = false
                    end
                end
            end,
        })

        RageUI.Button("> Set la tenue", "Met votre tenue actuel en temps que tenue pour le grade", {}, true, {
            onSelected = function()
                local cloth = {}
                local tenue = SkinChangerGetSkin()
                for k,v in pairs(tenue) do
                    if allowedTypeForCloth[k] ~= nil then
                        --print(k,v)
                        cloth[k] = v
                    end
                end

                self.cloths = cloth
                -- ShowNotification("Tenue mis à jours")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Tenue mis à jours"
                })
                
            end,
        })

        RageUI.Separator("Vérification")

        RageUI.Button("Enlever la preview", nil, {}, true, {
            onSelected = function()

                for k,v in pairs(civilCloths) do
                    p:setCloth(k,v)
                end
            end,
        })
        RageUI.Button("Preview de la tenue", "Permet de tester la tenue", {}, true, {
            onSelected = function() 

                local cloths = SkinChangerGetSkin()
                for k,v in pairs(cloths) do
                    if allowedTypeForCloth[k] ~= nil then
                        civilCloths[k] = v
                    end
                end

                for k,v in pairs(self.cloths) do
                    p:setCloth(k,v)
                end
                -- ShowNotification("Preview mise sur votre personnage")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Preview mise sur votre personnage"
                })

            end,
        })
    end)

    RageUI.IsVisible(jobCreate, function()
        RageUI.Button("> Reset la création de job", nil, {}, true, {
            onSelected = function()
                newJob = {
                    label = "template",
                    name = "template",
                    moneyPerNpc = 0,
                    actionEntreprise = vector3(0.0, 0.0, 0.0),
                    grade = {
                        {grade = 1, label = "template",   gestion = false,    salaire = 50, coffre = false},
                    },
                    cloths = {
                        {grade = 1, label = "Nouvelle tenue", cloths = {}},
                    }
                }
            end,
        })

        RageUI.Button("> Name", nil, {RightLabel = "("..tostring(newJob.name)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Job: name")
                if text ~= nil then
                    newJob.name = text
                end
            end,
        })
        RageUI.Button("> Label", nil, {RightLabel = "("..tostring(newJob.label)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Job: Label")
                if text ~= nil then
                    newJob.label = text
                end
            end,
        })
        RageUI.Button("> Argent par mission NPC", nil, {RightLabel = "("..tostring(newJob.moneyPerNpc)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Job: Label")
                if text ~= nil then
                    newJob.moneyPerNpc = tonumber(text)
                end
            end,
        })
        RageUI.Button("> Action patron", "Position des actions patron", {RightLabel = "("..tostring(newJob.actionEntreprise)..")"}, true, {
            onSelected = function()
                newJob.actionEntreprise = p:pos()
            end,
        })
        RageUI.Button("> Position véstiaire", "Position des actions patron", {RightLabel = "("..tostring(newJob.clothsPos)..")"}, true, {
            onSelected = function()
                newJob.clothsPos = p:pos()
            end,
        })


        RageUI.Separator("Grades")

        RageUI.Button("~g~Ajouter un grade", nil, {}, true, {
            onSelected = function()
                table.insert(newJob.grade, {grade = #newJob.grade + 1, label = "template",   gestion = false,    salaire = 50, coffre = false})
            end,
        })

        for k,v in pairs(newJob.grade) do
            RageUI.Button("[~b~"..v.grade.."~s~] - "..v.label.." (~g~"..v.salaire.."~s~$)", "Gestion: "..tostring(v.gestion).." - Acces coffre: "..tostring(v.coffre), {}, true, {
                onSelected = function()
                    gradeIndex = k
                end,
            }, gradeCreate)
        end

        RageUI.Separator("Tenues")
        RageUI.Button("~g~Ajouter une tenue", nil, {}, true, {
            onSelected = function()
                table.insert(newJob.cloths,  {grade = 1, label = "Nouvelle tenue", women = false, cloths = {}})
            end,
        })
        for k,v in pairs(newJob.cloths) do
            RageUI.Button("[~b~"..v.grade.."~s~] - "..v.label, nil, {}, true, {
                onSelected = function()
                    tenueIndex = k
                end,
            }, tenueCreate)
        end

        
        RageUI.Separator("Valider la création")

        RageUI.Button("> Crée le job", nil, {}, true, {
            onSelected = function()
                TriggerServerEvent("core:CreateNewJob", token, newJob.name, newJob.label, newJob.grade, newJob.moneyPerNpc, newJob.actionEntreprise, newJob.cloths, newJob.clothsPos)
            end,
        })
    end)

    RageUI.IsVisible(gradeCreate, function()
        local self = newJob.grade[gradeIndex]
        RageUI.Button("> ID Grade", nil, {RightLabel = "("..tostring(self.grade)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: ID")
                if text ~= nil then
                    self.grade = tonumber(text)
                end
            end,
        })
        RageUI.Button("> Label", nil, {RightLabel = "("..tostring(self.label)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: Label")
                if text ~= nil then
                    self.label = text
                end
            end,
        })
        RageUI.Button("> Salaire", nil, {RightLabel = "("..tostring(self.salaire)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: salaire")
                if text ~= nil then
                    self.salaire = tonumber(text)
                end
            end,
        })
        RageUI.Button("> Accès gestion", nil, {RightLabel = "("..tostring(self.gestion)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: gestion (true/false)")
                if text ~= nil then
                    if text == "true" then
                        self.gestion = true
                    else
                        self.gestion = false
                    end
                end
            end,
        })
        RageUI.Button("> Accès coffre", nil, {RightLabel = "("..tostring(self.coffre)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Grade: coffre (true/false)")
                if text ~= nil then
                    if text == "true" then
                        self.coffre = true
                    else
                        self.coffre = false
                    end
                end
            end,
        })
    end)

    
    RageUI.IsVisible(tenueCreate, function()
        local self = newJob.cloths[tenueIndex]
        RageUI.Button("> ID Grade", "Toute personnes ayant le grade ou en dessus pourra mettre la tenue", {RightLabel = "("..tostring(self.grade)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Tenue: ID")
                if text ~= nil then
                    self.grade = tonumber(text)
                    -- ShowNotification("ID mis à jours")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s ID mis à jour"
                    })

                end
            end,
        })

        RageUI.Button("> Label", nil, {RightLabel = "("..tostring(self.label)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Tenue: Label")
                if text ~= nil then
                    self.label = text
                    -- ShowNotification("Label mis à jours")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Label mis à jours"
                    })
                    
                end
            end,
        })
        RageUI.Button("> Tenue pour femme", nil, {RightLabel = "("..tostring(self.women)..")"}, true, {
            onSelected = function()
                local text = KeyboardImput("Tenue: pour femme ? (true/false)")
                if text ~= nil then
                    if text == "true" then
                        self.women = true
                    else
                        self.women = false
                    end
                end
            end,
        })

        RageUI.Button("> Set la tenue", "Met votre tenue actuel en temps que tenue pour le grade", {}, true, {
            onSelected = function()
                local cloth = {}
                local tenue = SkinChangerGetSkin()
                for k,v in pairs(tenue) do
                    if allowedTypeForCloth[k] ~= nil then
                        --print(k,v)
                        cloth[k] = v
                    end
                end

                self.cloths = cloth
                -- ShowNotification("Tenue mis à jours")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Tenue mis à jours"
                })

            end,
        })

        RageUI.Separator("Vérification")

        RageUI.Button("Enlever la preview", nil, {}, true, {
            onSelected = function()

                for k,v in pairs(civilCloths) do
                    p:setCloth(k,v)
                end
            end,
        })
        RageUI.Button("Preview de la tenue", "Permet de tester la tenue", {}, true, {
            onSelected = function() 

                local cloths = SkinChangerGetSkin()
                for k,v in pairs(cloths) do
                    if allowedTypeForCloth[k] ~= nil then
                        civilCloths[k] = v
                    end
                end

                for k,v in pairs(self.cloths) do
                    p:setCloth(k,v)
                end
                -- ShowNotification("Preview mise sur votre personnage")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Preview mise sur votre personnage"
                })

            end,
        })
    end)
end