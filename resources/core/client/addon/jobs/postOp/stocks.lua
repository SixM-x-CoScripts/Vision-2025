Citizen.CreateThread(function()
    Wait(250)
    
    PostOpSocietysStockage = {
		['skyblue'] = {
            elementsBoissons = GetCataloguePostOPItems("skyblue").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("skyblue").elementsAlcool,
            headerImage = GetCataloguePostOPItems("skyblue").headerImage,
            headerIcon = GetCataloguePostOPItems("skyblue").headerIcon,
            headerIconName = 'COMMANDE'
        },
		['rexdiner'] = {
            elements = GetCataloguePostOPItems("rexdiner").elements,
            elementsBoissons = GetCataloguePostOPItems("rexdiner").elementsBoissons,
            headerImage = GetCataloguePostOPItems("rexdiner").headerImage,
            headerIcon = GetCataloguePostOPItems("rexdiner").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['burgershot'] = {
            elements = GetCataloguePostOPItems("burgershot").elements,
            elementsBoissons = GetCataloguePostOPItems("burgershot").elementsBoissons,
            headerImage = GetCataloguePostOPItems("burgershot").headerImage,
            headerIcon = GetCataloguePostOPItems("burgershot").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['beanmachine'] = {
            elements = GetCataloguePostOPItems("beanmachine").elements,
            elementsBoissons = GetCataloguePostOPItems("beanmachine").elementsBoissons,
            headerImage = GetCataloguePostOPItems("beanmachine").headerImage,
            headerIcon = GetCataloguePostOPItems("beanmachine").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['mirror'] = {
            elements = GetCataloguePostOPItems("lemiroir").elements,
            elementsBoissons = GetCataloguePostOPItems("lemiroir").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("lemiroir").elementsAlcool,
            headerImage = GetCataloguePostOPItems("lemiroir").headerImage,
            headerIcon = GetCataloguePostOPItems("lemiroir").heaerIcon,
            headerIconName = 'COMMANDE'
        },
        ['unicorn'] = {
            elements = GetCataloguePostOPItems("unicorn").elements,
            elementsBoissons = GetCataloguePostOPItems("unicorn").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("unicorn").elementsAlcool,
            headerImage = GetCataloguePostOPItems("unicorn").headerImage,
            headerIcon = GetCataloguePostOPItems("unicorn").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['royalhotel'] = {
            elements = GetCataloguePostOPItems("royalhotel").elements,
            elementsBoissons = GetCataloguePostOPItems("royalhotel").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("royalhotel").elementsAlcool,
            headerImage = GetCataloguePostOPItems("royalhotel").headerImage,
            headerIcon = GetCataloguePostOPItems("royalhotel").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['yellowjack'] = {
            elements = GetCataloguePostOPItems("yellowjack").elements,
            elementsBoissons = GetCataloguePostOPItems("yellowjack").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("yellowjack").elementsAlcool,
            elementsUtilitaires = GetCataloguePostOPItems("yellowjack").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("yellowjack").headerImage,
            headerIcon = GetCataloguePostOPItems("yellowjack").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['pops'] = {
            elements = GetCataloguePostOPItems("popsdiner").elements,
            elementsBoissons = GetCataloguePostOPItems("popsdiner").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("popsdiner").elementsAlcool,
            headerImage = GetCataloguePostOPItems("popsdiner").headerImage,
            headerIcon = GetCataloguePostOPItems("popsdiner").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['cluckin'] = {
            elements = GetCataloguePostOPItems("cluckinbell").elements,
            elementsBoissons = GetCataloguePostOPItems("cluckinbell").elementsBoissons,
            headerImage = GetCataloguePostOPItems("cluckinbell").headerImage,
            headerIcon = GetCataloguePostOPItems("cluckinbell").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['comrades'] = {
            elements = GetCataloguePostOPItems("comrades").elements,
            elementsBoissons = GetCataloguePostOPItems("comrades").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("comrades").elementsAlcool,
            headerImage = GetCataloguePostOPItems("comrades").headerImage,
            headerIcon = GetCataloguePostOPItems("comrades").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['bahamas'] = {
            elements = GetCataloguePostOPItems("bahamas").elements,
            elementsBoissons = GetCataloguePostOPItems("bahamas").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("bahamas").elementsAlcool,
            headerImage = GetCataloguePostOPItems("bahamas").headerImage,
            headerIcon = GetCataloguePostOPItems("bahamas").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['vclub'] = {
            elements = GetCataloguePostOPItems("vclub").elements,
            elementsBoissons = GetCataloguePostOPItems("vclub").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("vclub").elementsAlcool,
            headerImage = GetCataloguePostOPItems("vclub").headerImage,
            headerIcon = GetCataloguePostOPItems("vclub").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['club77'] = {
            elements = GetCataloguePostOPItems("club77").elements,
            elementsBoissons = GetCataloguePostOPItems("club77").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("club77").elementsAlcool,
            headerImage = GetCataloguePostOPItems("club77").headerImage,
            headerIcon = GetCataloguePostOPItems("club77").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['bayviewLodge'] = {
            elements = GetCataloguePostOPItems("bayviewLodge").elements,
            elementsBoissons = GetCataloguePostOPItems("bayviewLodge").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("bayviewLodge").elementsAlcool,
            headerImage = GetCataloguePostOPItems("bayviewLodge").headerImage,
            headerIcon = GetCataloguePostOPItems("bayviewLodge").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ltdsud'] = {
            elements = GetCataloguePostOPItems("ltdsud").elements,
            elementsUtilitaires = GetCataloguePostOPItems("ltdsud").elementsUtilitaires,
            elementsBoissons = GetCataloguePostOPItems("ltdsud").elementsBoissons,
            headerImage = GetCataloguePostOPItems("ltdsud").headerImage,
            headerIcon = GetCataloguePostOPItems("ltdsud").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['uwu'] = {
            elements = GetCataloguePostOPItems("uwu").elements,
            elementsUtilitaires = GetCataloguePostOPItems("uwu").elementsUtilitaires,
            elementsBoissons = GetCataloguePostOPItems("uwu").elementsBoissons,
            headerImage = GetCataloguePostOPItems("uwu").headerImage,
            headerIcon = GetCataloguePostOPItems("uwu").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ltdseoul'] = {
            elements = GetCataloguePostOPItems("ltdseoul").elements,
            elementsUtilitaires = GetCataloguePostOPItems("ltdseoul").elementsUtilitaires,
            elementsBoissons = GetCataloguePostOPItems("ltdseoul").elementsBoissons,
            headerImage = GetCataloguePostOPItems("ltdseoul").headerImage,
            headerIcon = GetCataloguePostOPItems("ltdseoul").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ltdmirror'] = {
            elements = GetCataloguePostOPItems("ltdmirror").elements,
            elementsUtilitaires = GetCataloguePostOPItems("ltdmirror").elementsUtilitaires,
            elementsBoissons = GetCataloguePostOPItems("ltdmirror").elementsBoissons,
            headerImage = GetCataloguePostOPItems("ltdmirror").headerImage,
            headerIcon = GetCataloguePostOPItems("ltdmirror").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['don'] = {
            elements = GetCataloguePostOPItems("don").elements,
            elementsBoissons = GetCataloguePostOPItems("don").elementsBoissons,
            elementsUtilitaires = GetCataloguePostOPItems("don").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("don").headerImage,
            headerIcon = GetCataloguePostOPItems("don").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['blackwood'] = {
            elements = GetCataloguePostOPItems("blackwood").elements,
            elementsBoissons = GetCataloguePostOPItems("blackwood").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("blackwood").elementsAlcool,
            headerImage = GetCataloguePostOPItems("blackwood").headerImage,
            headerIcon = GetCataloguePostOPItems("blackwood").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['pizzeria'] = {
            elements = GetCataloguePostOPItems("pizzeria").elements,
            elementsBoissons = GetCataloguePostOPItems("pizzeria").elementsBoissons,
            headerImage = GetCataloguePostOPItems("pizzeria").headerImage,
            headerIcon = GetCataloguePostOPItems("pizzeria").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['pearl'] = {
            elements = GetCataloguePostOPItems("pearl").elements,
            elementsBoissons = GetCataloguePostOPItems("pearl").elementsBoissons,
            elementsAlcool = GetCataloguePostOPItems("pearl").elementsAlcool,
            headerImage = GetCataloguePostOPItems("pearl").headerImage,
            headerIcon = GetCataloguePostOPItems("pearl").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['upnatom'] = {
            elements = GetCataloguePostOPItems("upnatom").elements,
            elementsBoissons = GetCataloguePostOPItems("upnatom").elementsBoissons,
            headerImage = GetCataloguePostOPItems("upnatom").headerImage,
            headerIcon = GetCataloguePostOPItems("upnatom").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['hornys'] = {
            elements = GetCataloguePostOPItems("hornys").elements,
            elementsBoissons = GetCataloguePostOPItems("hornys").elementsBoissons,
            headerImage = GetCataloguePostOPItems("hornys").headerImage,
            headerIcon = GetCataloguePostOPItems("hornys").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['tacosrancho'] = {
            elements = GetCataloguePostOPItems("tacosrancho").elements,
            elementsBoissons = GetCataloguePostOPItems("tacosrancho").elementsBoissons,
            headerImage = GetCataloguePostOPItems("tacosrancho").headerImage,
            headerIcon = GetCataloguePostOPItems("tacosrancho").headerIcon,
            headerIconName = 'COMMANDE'
        },

        -- MECANO

        ['bennys'] = {
            elementsUtilitaires = GetCataloguePostOPItems("bennys").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("bennys").headerImage,
            headerIcon = GetCataloguePostOPItems("bennys").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['cayogarage'] = {
            elementsUtilitaires = GetCataloguePostOPItems("cayogarage").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("cayogarage").headerImage,
            headerIcon = GetCataloguePostOPItems("cayogarage").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['hayes'] = {
            elementsUtilitaires = GetCataloguePostOPItems("hayes").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("hayes").headerImage,
            headerIcon = GetCataloguePostOPItems("hayes").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['beekers'] = {
            elementsUtilitaires = GetCataloguePostOPItems("beekers").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("beekers").headerImage,
            headerIcon = GetCataloguePostOPItems("beekers").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ocean'] = {
            elementsUtilitaires = GetCataloguePostOPItems("ocean").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("ocean").headerImage,
            headerIcon = GetCataloguePostOPItems("ocean").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['harmony'] = {
            elementsUtilitaires = GetCataloguePostOPItems("harmony").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("harmony").headerImage,
            headerIcon = GetCataloguePostOPItems("harmony").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['sunshine'] = {
            elementsUtilitaires = GetCataloguePostOPItems("sunshine").elementsUtilitaires,
            headerImage = GetCataloguePostOPItems("sunshine").headerImage,
            headerIcon = GetCataloguePostOPItems("sunshine").headerIcon,
            headerIconName = 'COMMANDE'
        },

    }

    SocietysStockage = {
		['skyblue'] = {
            elements = GetCatalogueItems("skyblue").elements,
            headerImage = GetCatalogueItems("skyblue").headerImage,
            headerIcon = GetCatalogueItems("skyblue").headerIcon,
            headerIconName = 'COMMANDE'
        },
		['rexdiner'] = {
            elements = GetCatalogueItems("rexdiner").elements,
            headerImage = GetCatalogueItems("rexdiner").headerImage,
            headerIcon = GetCatalogueItems("rexdiner").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['burgershot'] = {
            elements = GetCatalogueItems("burgershot").elements,
            headerImage = GetCatalogueItems("burgershot").headerImage,
            headerIcon = GetCatalogueItems("burgershot").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['bean'] = {
            elements = GetCatalogueItems("beanmachine").elements,
            headerImage = GetCatalogueItems("beanmachine").headerImage,
            headerIcon = GetCatalogueItems("beanmachine").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['mirror'] = {
            elements = GetCatalogueItems("lemiroir").elements,
            headerImage = GetCatalogueItems("lemiroir").headerImage,
            headerIcon = GetCatalogueItems("lemiroir").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['unicorn'] = {
            elements = GetCatalogueItems("unicorn").elements,
            headerImage = GetCatalogueItems("unicorn").headerImage,
            headerIcon = GetCatalogueItems("unicorn").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['royalhotel'] = {
            elements = GetCatalogueItems("royalhotel").elements,
            headerImage = GetCatalogueItems("royalhotel").headerImage,
            headerIcon = GetCatalogueItems("royalhotel").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['yellowJack'] = {
            elements = GetCatalogueItems("yellowjack").elements,
            headerImage = GetCatalogueItems("yellowjack").headerImage,
            headerIcon = GetCatalogueItems("yellowjack").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['pops'] = {
            elements = GetCatalogueItems("popsdiner").elements,
            headerImage = GetCatalogueItems("popsdiner").headerImage,
            headerIcon = GetCatalogueItems("popsdiner").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['cluckin'] = {
            elements = GetCatalogueItems("cluckinbell").elements,
            headerImage = GetCatalogueItems("cluckinbell").headerImage,
            headerIcon = GetCatalogueItems("cluckinbell").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['comrades'] = {
            elements = GetCatalogueItems("comrades").elements,
            headerImage = GetCatalogueItems("comrades").headerImage,
            headerIcon = GetCatalogueItems("comrades").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['bahamas'] = {
            elements = GetCatalogueItems("bahamas").elements,
            headerImage = GetCatalogueItems("bahamas").headerImage,
            headerIcon = GetCatalogueItems("bahamas").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['vclub'] = {
            elements = GetCatalogueItems("vclub").elements,
            headerImage = GetCatalogueItems("vclub").headerImage,
            headerIcon = GetCatalogueItems("vclub").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['club77'] = {
            elements = GetCatalogueItems("club77").elements,
            headerImage = GetCatalogueItems("club77").headerImage,
            headerIcon = GetCatalogueItems("club77").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['bayviewLodge'] = {
            elements = GetCatalogueItems("bayviewLodge").elements,
            headerImage = GetCatalogueItems("bayviewLodge").headerImage,
            headerIcon = GetCatalogueItems("bayviewLodge").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ltdsud'] = {
            elements = GetCatalogueItems("ltdsud").elements,
            headerImage = GetCatalogueItems("ltdsud").headerImage,
            headerIcon = GetCatalogueItems("ltdsud").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['uwu'] = {
            elements = GetCatalogueItems("uwu").elements,
            headerImage = GetCatalogueItems("uwu").headerImage,
            headerIcon = GetCatalogueItems("uwu").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ltdseoul'] = {
            elements = GetCatalogueItems("ltdseoul").elements,
            headerImage = GetCatalogueItems("ltdseoul").headerImage,
            headerIcon = GetCatalogueItems("ltdseoul").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ltdmirror'] = {
            elements = GetCatalogueItems("ltdmirror").elements,
            headerImage = GetCatalogueItems("ltdmirror").headerImage,
            headerIcon = GetCatalogueItems("ltdmirror").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['don'] = {
            elements = GetCatalogueItems("don").elements,
            headerImage = GetCatalogueItems("don").headerImage,
            headerIcon = GetCatalogueItems("don").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['blackwood'] = {
            elements = GetCatalogueItems("blackwood").elements,
            headerImage = GetCatalogueItems("blackwood").headerImage,
            headerIcon = GetCatalogueItems("blackwood").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['pizzeria'] = {
            elements = GetCatalogueItems("pizzeria").elements,
            headerImage = GetCatalogueItems("pizzeria").headerImage,
            headerIcon = GetCatalogueItems("pizzeria").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['pearl'] = {
            elements = GetCatalogueItems("pearl").elements,
            headerImage = GetCatalogueItems("pearl").headerImage,
            headerIcon = GetCatalogueItems("pearl").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['upnatom'] = {
            elements = GetCatalogueItems("upnatom").elements,
            headerImage = GetCatalogueItems("upnatom").headerImage,
            headerIcon = GetCatalogueItems("upnatom").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['hornys'] = {
            elements = GetCatalogueItems("hornys").elements,
            headerImage = GetCatalogueItems("hornys").headerImage,
            headerIcon = GetCatalogueItems("hornys").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['tacosrancho'] = {
            elements = GetCatalogueItems("tacosrancho").elements,
            headerImage = GetCatalogueItems("tacosrancho").headerImage,
            headerIcon = GetCatalogueItems("tacosrancho").headerIcon,
            headerIconName = 'COMMANDE'
        },


        -- MECANO

        ['bennys'] = {
            elements = GetCatalogueItems("bennys").elements,
            headerImage = GetCatalogueItems("bennys").headerImage,
            headerIcon = GetCatalogueItems("bennys").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['cayogarage'] = {
            elements = GetCatalogueItems("cayogarage").elements,
            headerImage = GetCatalogueItems("cayogarage").headerImage,
            headerIcon = GetCatalogueItems("cayogarage").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['hayes'] = {
            elements = GetCatalogueItems("hayes").elements,
            headerImage = GetCatalogueItems("hayes").headerImage,
            headerIcon = GetCatalogueItems("hayes").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['beekers'] = {
            elements = GetCatalogueItems("beekers").elements,
            headerImage = GetCatalogueItems("beekers").headerImage,
            headerIcon = GetCatalogueItems("beekers").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['ocean'] = {
            elements = GetCatalogueItems("ocean").elements,
            headerImage = GetCatalogueItems("ocean").headerImage,
            headerIcon = GetCatalogueItems("ocean").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['harmony'] = {
            elements = GetCatalogueItems("harmony").elements,
            headerImage = GetCatalogueItems("harmony").headerImage,
            headerIcon = GetCatalogueItems("harmony").headerIcon,
            headerIconName = 'COMMANDE'
        },
        ['sunshine'] = {
            elements = GetCatalogueItems("sunshine").elements,
            headerImage = GetCatalogueItems("sunshine").headerImage,
            headerIcon = GetCatalogueItems("sunshine").headerIcon,
            headerIconName = 'COMMANDE'
        },


    }

end)