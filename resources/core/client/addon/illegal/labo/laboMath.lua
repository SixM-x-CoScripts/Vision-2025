FormattedDrugDataNeeds = {
    ['weed'] = {
        levelthree = {
            engrais = 30,
            fertilisant = 30,
            grainecannabis = 120,
        },
        levelfour = {
            --engrais = 35,
            --fertilisant = 35,
            --grainecannabis = 140,
            engrais = 30,
            fertilisant = 30,
            grainecannabis = 120,
        },
        levelfive = {
            --engrais = 40,
            --fertilisant = 40,
            --grainecannabis = 160,
            engrais = 30,
            fertilisant = 30,
            grainecannabis = 120,
        },
    },
    ['fentanyl'] = {
        levelthree = {
            pavosomnifere = 240,
            chlorureammonium = 60,
            anhydrideacetique = 60,
        },
        levelfour = {
            --pavosomnifere = 280,
            --chlorureammonium = 70,
            --anhydrideacetique = 70,
            pavosomnifere = 240,
            chlorureammonium = 60,
            anhydrideacetique = 60,
        },
        levelfive = {
            --pavosomnifere = 320,
            --chlorureammonium = 80,
            --anhydrideacetique = 80,
            pavosomnifere = 240,
            chlorureammonium = 60,
            anhydrideacetique = 60,
        },
    },
    ['coke'] = {
        levelthree = {
            kerosene = 60,
            feuilledecoca = 480,
            acidesulfurique = 60,
        },
        levelfour = {
            --kerosene = 70,
            --feuilledecoca = 560,
            --acidesulfurique = 70,
            kerosene = 60,
            feuilledecoca = 480,
            acidesulfurique = 60,
        },
        levelfive = {
            --kerosene = 80,
            --feuilledecoca = 640,
            --acidesulfurique = 80,
            kerosene = 60,
            feuilledecoca = 480,
            acidesulfurique = 60,
        },
    },
    ['meth'] = {
        levelthree = {
            ephedrine = 30,
            methylamine = 60,
            phenylacetone = 60,
        },
        levelfour = {
            --ephedrine = 40,
            --methylamine = 70,
            --phenylacetone = 70,
            ephedrine = 30,
            methylamine = 60,
            phenylacetone = 60,
        },
        levelfive = {
            --ephedrine = 40,
            --methylamine = 80,
            --phenylacetone = 80,
            ephedrine = 30,
            methylamine = 60,
            phenylacetone = 60,
        },
    },
}

function GetPercentageLabo(item, ItemCount, notify, crewlevel, dtype)
    -- ## Systeme de pourcentage a refaire
    if ItemCount == 0 or ItemCount == nil or ItemCount == false then 
        if notify then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Il vous manque l'ingrédient "..GoodNames[item].." !"
            })
        end
        return 0
    end
    local value = 5
    if crewlevel == 3 then
        value = FormattedDrugDataNeeds[dtype].levelthree[item]
    elseif crewlevel == 2 or crewlevel == 1 then
        value = FormattedDrugDataNeeds[dtype].levelthree[item]
    elseif crewlevel == 4 then
        value = FormattedDrugDataNeeds[dtype].levelfour[item]
    elseif crewlevel == 5 then
        value = FormattedDrugDataNeeds[dtype].levelfive[item]
    end
    local percentage = math.floor((ItemCount/value)*100)
    if percentage > 100 then percentage = 100 end
    return percentage
end

function HasExceedMaxValue(value, crewlevel, dtype, item)
    if crewlevel == 3 then
        if value and value > FormattedDrugDataNeeds[dtype].levelthree[item] then 
            value = FormattedDrugDataNeeds[dtype].levelthree[item]
        end
    elseif crewlevel == 2 then
        if value and value > FormattedDrugDataNeeds[dtype].levelthree[item] then 
            value = FormattedDrugDataNeeds[dtype].levelthree[item]
        end
    elseif crewlevel == 4 then
        if value and value > FormattedDrugDataNeeds[dtype].levelfour[item] then 
            value = FormattedDrugDataNeeds[dtype].levelfour[item]
        end
    elseif crewlevel == 5 then
        if value and value > FormattedDrugDataNeeds[dtype].levelfive[item] then 
            value = FormattedDrugDataNeeds[dtype].levelfive[item]
        end
    end
    return value
end