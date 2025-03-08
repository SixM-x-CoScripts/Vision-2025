function GetDatasTenues()
    if not isPlayerPed() then
        local Skin = p:skin()
        ApplySkinFake(Skin)
    end
    --if nbStart == 0 then
    --    nbStart = 1
        DataSendBinco.buttons = {}
        DataSendBinco.catalogue = {}
        DataSendBinco.forceCategory = nil  
        if p:skin().sex == 0 then
            DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
            DataSendBinco.headerIconName = 'Binco Homme'
            playerType = "Homme"
        elseif p:skin().sex == 1 then
            DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
            DataSendBinco.headerIconName = 'Binco Femme'
            playerType = "Femme"
        end

        DataSendBinco.buttons = {
            {
                name = 'Metiers',
                width = 'full',
                hoverStyle = 'stroke-black',
                type = 'coverBackground',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/metiers.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name= 'Metiers'
                    },
                } 
            },
            {
                name = 'Activités',
                width = 'full',
                hoverStyle = 'stroke-black',
                type = 'coverBackground',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/activites.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name= 'Activités'
                    },
                } 
            },
            {
                name = 'Sport',
                width = 'full',
                hoverStyle = 'stroke-black',
                type = 'coverBackground',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/sport.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name= 'Sport'
                    },
                } 
            },
            {
                name = 'Décontracté',
                width = 'full',
                hoverStyle = 'stroke-black',
                type = 'coverBackground',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/decontracte.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name= 'Décontracté'
                    },
                } 
            },
            {
                name = 'Classe',
                width = 'full',
                hoverStyle = 'stroke-black',
                type = 'coverBackground',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/classe.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name= 'Classe'
                    },
                } 
            },
        }


        --[[
        Pour les sans PED
        ]]
        -- Pantalon

        for k,v in pairs(cloths_tenues) do
			local imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/male/clothing/torso2/" .. v.haut1 .. ".webp"

			if v ~= 0 then
				imageURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/male/clothing/torso2/" .. v.haut1 .. "_".. v.haut2 + 1 ..".webp"
			end

            table.insert(DataSendBinco.catalogue, {all = v, price = 20, label=v.name, image=imageURL, category="Metiers", subCategory="Metiers"})
        end        
    --end
    return true
end