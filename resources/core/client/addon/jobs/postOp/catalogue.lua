local toSend = nil

-- Nourritures

local UwUcafe_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/header_uwucoffee.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',

    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/CatPat.webp',
            label= 'CatPat',
            givename= 'CatPat',
            category= 'Nourritures',
            price= 15,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Chat_Gourmand.webp',
            label= 'Chat Gourmand',
            givename= 'ChatGourmand',
            category= 'Nourritures',
            price=140,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Mochi.webp',
            label= 'Mochi',
            givename= 'Mochi',
            category= 'Nourritures',
            price=90,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Pocky.webp',
            label= 'Pocky',
            givename= 'Pocky',
            category= 'Nourritures',
            price=90,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/UwU_Burger-removebg-preview.webp',
            label= 'UwU Burger',
            givename= 'UwUBurger',
            category= 'Nourritures',
            price=140,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy.webp',
            label= 'Kitty Toy',
            category= 'Nourritures',
            price=5,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/melto.webp',
            label= 'Melto',
            givename= 'melto',
            category= 'Nourritures',
            price=140,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/lapinut.webp',
            label= 'Lapinut',
            givename= 'lapinut',
            category= 'Nourritures',
            price=140,
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/BarbaMilk.webp',
            label= 'BarbaMilk',
            givename= 'BarbaMilk',
            category= 'Boissons',
            price=100,
        },
        {
            id=2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Chatmallow.webp',
            label= 'Chatmallow',
            givename= 'Chatmallow',
            category= 'Boissons',
            price=100,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Bubble_Tea.webp',
            label= 'Bubble Tea',
            givename= 'BubbleTea',
            category= 'Boissons',
            price=110,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Ice_Coffee.webp',
            label= 'Ice Coffee',
            givename= 'IceCoffee',
            category= 'Boissons',
            price=100,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/IceCream_Cat.webp',
            label= 'IceCream Cat',
            givename= 'IceCreamCat',
            category= 'Boissons',
            price=100,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Lailait_chaud.webp',
            label= 'Lailait chaud',
            givename= 'Lailaitchaud',
            category= 'Boissons',
            price=100,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Milkshake.webp',
            label= 'Milkshake',
            givename= 'Milkshake',
            category= 'Boissons',
            price=100,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/LatteMatcha.webp',
            label= 'LatteMatcha',
            givename= 'LatteMatcha',
            category= 'Boissons',
            price=100,
        },
    },

    elementsUtilitaires = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Arc_En_Ciel.webp',
            label= 'Kitty Toy Arc-en-ciel',
            givename= 'KittyToyArcEnCiel',
            category= 'Utilitaires',
            price=250,

        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Bleu.webp',
            label= 'Kitty Toy Bleu',
            givename= 'kitty2',
            category= 'Utilitaires',
            price=250,

        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Dark.webp',
            label= 'Kitty Toy Dark',
            givename= 'KittyToyDark',
            category= 'Utilitaires',
            price=250,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Flower.webp',
            label= 'Kitty Toy Flower',
            givename= 'KittyToyFlower',
            category= 'Utilitaires',
            price=250,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Gris.webp',
            label= 'Kitty Toy Gris',
            givename= 'KittyToyGris',
            category= 'Utilitaires',
            price=250,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Jaune.webp',
            label= 'Kitty Toy Jaune',
            givename= 'KittyToyJaune',
            category= 'Utilitaires',
            price=250,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Vert-removebg-preview.webp',
            label= 'Kitty Toy Vert',
            givename= 'KittyToyVert',
            category= 'Utilitaires',
            price=250,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy.webp',
            label= 'Kitty Toy Rose',
            givename= 'kitty',
            category= 'Utilitaires',
            price=250,

        },
    }
}

-- Nourritures

local VanillaUnicorn_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/header_unicorn.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Aperitifs.webp',
            label= 'Apéritifs',
            givename= 'Aperitifs',
            category= 'Nourritures',
            price=10,
        },
    },

    elementsBoissons = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price=7,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price=7,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price=7,
        },
    },

    elementsAlcool = {
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Cool_Granny.webp',
            label= 'Cool Granny',
            givename= 'CoolGranny',
            category= 'Alcool',
            price=22,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Doudou.webp',
            label= 'Doudou',
            givename= 'Doudou',
            category= 'Alcool',
            price=22,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/French_Kiss.webp',
            label= 'French Kiss',
            givename= 'FrenchKiss',
            category= 'Alcool',
            price=22,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Red_Velvet.webp',
            label= 'Red Velvet',
            givename= 'RedVelvet',
            category= 'Alcool',
            price=22,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Sex_on_the_beach.webp',
            label= 'Sex On The Beach',
            givename= 'Sexonthebeach',
            category= 'Alcool',
            price=22,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Uni_tail.webp',
            label= 'Uni Tail',
            givename= 'Unitail',
            category= 'Alcool',
            price=37,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/champagne.webp',
            label= 'Champagne',
            givename= 'champagne',
            category= 'Alcool',
            price= 20,
        },      
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            givename= 'vodka',
            category= 'Alcool',
            price= 22,
        },  
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            givename= 'whisky',
            category= 'Alcool',
            price= 22,
        },
    },
}

local Skyblue_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/skyblue/header_skyblue.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',

    elementsBoissons = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/caprisun.webp',
            label= 'Capri-Seum',
            givename= 'capriseum',
            category= 'Boissons',
            price=25,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price=30,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/soda.webp',
            label= 'eCola',
            givename= 'soda',
            category= 'Boissons',
            price=25,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tea.webp',
            label= 'Thé',
            givename= 'tea',
            category= 'Boissons',
            price=25,
        },
    },
    
    elementsAlcool = {
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Cool_Granny.webp',
            label= 'Cool Granny',
            givename= 'CoolGranny',
            category= 'Alcool',
            price=22,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Doudou.webp',
            label= 'Doudou',
            givename= 'Doudou',
            category= 'Alcool',
            price=22,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/French_Kiss.webp',
            label= 'French Kiss',
            givename= 'FrenchKiss',
            category= 'Alcool',
            price=22,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Red_Velvet.webp',
            label= 'Red Velvet',
            givename= 'RedVelvet',
            category= 'Alcool',
            price=22,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Sex_on_the_beach.webp',
            label= 'Sex On The Beach',
            givename= 'Sexonthebeach',
            category= 'Alcool',
            price=22,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Uni_tail.webp',
            label= 'Uni Tail',
            givename= 'Unitail',
            category= 'Alcool',
            price=37,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/champagne.webp',
            label= 'Champagne',
            givename= 'champagne',
            category= 'Alcool',
            price= 20,
        },      
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            givename= 'vodka',
            category= 'Alcool',
            price= 22,
        },  
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            givename= 'whisky',
            category= 'Alcool',
            price= 22,
        },
    },
}

-- Nourritures

local RoyalHotel_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/royalhotel/header_royalhotel.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Aperitifs.webp',
            label= 'Apéritifs',
            givename= 'Aperitifs',
            category= 'Nourritures',
            price=10,
        },
    },

    elementsBoissons = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price=7,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price=7,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price=7,
        },
    },

    elementsAlcool = {
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Cool_Granny.webp',
            label= 'Cool Granny',
            givename= 'CoolGranny',
            category= 'Alcool',
            price=22,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Doudou.webp',
            label= 'Doudou',
            givename= 'Doudou',
            category= 'Alcool',
            price=22,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/French_Kiss.webp',
            label= 'French Kiss',
            givename= 'FrenchKiss',
            category= 'Alcool',
            price=22,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Red_Velvet.webp',
            label= 'Red Velvet',
            givename= 'RedVelvet',
            category= 'Alcool',
            price=22,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Sex_on_the_beach.webp',
            label= 'Sex On The Beach',
            givename= 'Sexonthebeach',
            category= 'Alcool',
            price=22,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Uni_tail.webp',
            label= 'Uni Tail',
            givename= 'Unitail',
            category= 'Alcool',
            price=37,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/champagne.webp',
            label= 'Champagne',
            givename= 'champagne',
            category= 'Alcool',
            price= 20,
        },      
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            givename= 'vodka',
            category= 'Alcool',
            price= 22,
        },  
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            givename= 'whisky',
            category= 'Alcool',
            price= 22,
        },
    },
}

-- Nourritures

local BeanMachine_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/header_beanmachine.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cookie.webp',
            label= 'Cookie',
            givename= 'Cookie',
            category= 'Nourritures',
            price=5,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Muffin_choco.webp',
            label= 'Muffin choco',
            givename= 'Muffinchoco',
            category= 'Nourritures',
            price=5,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Oeufsbacon.webp',
            label= 'Oeufs Bacon',
            givename= 'OeufsBacon',
            category= 'Nourritures',
            price= 15,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutc.webp',
            label= 'Donuts Chocolat',
            givename= 'donutc',
            category= 'Nourritures',
            price= 8,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donuts Nature',
            givename= 'donutn',
            category= 'Nourritures',
            price= 8,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cheesecake.webp',
            label= 'Cheesecake',
            givename= 'Cheesecake',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cafe_frappe.webp',
            label= 'Café frappé',
            givename= 'Cafefrappe',
            category= 'Boissons',
            price=2,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cafe_praline.webp',
            label= 'Café praliné',
            givename= 'Cafepraline',
            category= 'Boissons',
            price=2,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cappuccino.webp',
            label= 'Cappuccino',
            givename= 'Cappuccino',
            category= 'Boissons',
            price=2,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Caramel_macchiato.webp',
            label= 'Caramel macchiato',
            givename= 'Caramelmacchiato',
            category= 'Boissons',
            price=5,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Choco_guimauve.webp',
            label= 'Choco guimauve',
            givename= 'Chocoguimauve',
            category= 'Boissons',
            price= 5,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Chocolat_viennois.webp',
            label= 'Chocolat viennois',
            givename= 'Chocolatviennois',
            category= 'Boissons',
            price= 5,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Expresso.webp',
            label= 'Expresso',
            givename= 'Expresso',
            category= 'Boissons',
            price=2,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Latte.webp',
            label= 'Latte',
            givename= 'Latte',
            category= 'Boissons',
            price=2,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Theglace.webp',
            label= 'Thé glacé',
            givename= 'Theglace',
            category= 'Boissons',
            price= 5,
        },
    },
}

-- Nourritures

local LeMiroir_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/header_lemiroir.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Fondant_chocolat.webp',
            label= 'Fondant au chocolat',
            givename= 'Fondantchocolat',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Waffle.webp',
            label= 'Gaufre',
            givename= 'Waffle',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Moules_frites.webp',
            label= 'Moules frites',
            givename= 'Moulesfrites',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Plateau_de_charcuterie.webp',
            label= 'Plateau de charcuterie',
            givename= 'Plateaudecharcuterie',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/escalope.webp',
            label= 'Escalope',
            givename= 'escalope',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/seafoodInWood.webp',
            label= 'Plateau des mers',
            givename= 'seafood-in-wood-',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/American_ribs.webp',
            label= 'American ribs',
            givename= 'Americanribs',
            category= 'Nourritures',
            price= 20,
        },

        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/caviar.webp',
            label= 'Caviar',
            givename= 'caviar',
            category= 'Nourritures',
            price= 10,
        },

        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/magret.webp',
            label= 'Magret',
            givename= 'magret',
            category= 'Nourritures',
            price= 20,
        },

        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/foiegras.webp',
            label= 'Foie Gras',
            givename= 'foiegras',
            category= 'Nourritures',
            price= 20,
        },
    },

    elementsBoissons = {
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/champagne.webp',
            label= 'Champagne',
            givename= 'champagne',
            category= 'Alcool',
            price= 20,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Vin_blanc.webp',
            label= 'Vin Blanc',
            givename= 'Vinblanc',
            category= 'Alcool',
            price= 17,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Vin_rouge.webp',
            label= 'Vin Rouge',
            givename= 'Vinrouge',
            category= 'Alcool',
            price= 17,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Bouteille de Champagne',
            givename= 'BouteilleChampagne',
            category= 'Alcool',
            price= 80,
        },
    },
}

-- Nourritures

local Tacos2Rancho_toSend = {
    headerImage = 'https://cdn.discordapp.com/attachments/1146829717597606119/1147487872258166834/Banner-Tacos2Rancho.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 10,
            image= 'https://media.discordapp.net/attachments/1146829717597606119/1147511638568742973/fajitas-the-frenchy-burger.webp',
            label= 'Fajitas',
            givename= 'fajitas',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 11,
            image= 'https://cdn.discordapp.com/attachments/1146829717597606119/1147511814939222087/menuthumbnail_breakfast_burrito-supersonic.webp',
            label= 'Burritos',
            givename= 'burrito',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 12,
            image= 'https://cdn.discordapp.com/attachments/1146829717597606119/1147512065838297118/KWC-Image-2018-Food-Quesadilla-Whole-Chicken-1a-4853_kf_hd51_09063-FNL.webp',
            label= 'Quessadillas',
            givename= 'quesadillas',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 13,
            image= 'https://cdn.discordapp.com/attachments/1146829717597606119/1147512360039362570/SINGLE-TACO.webp',
            label= 'Tacos',
            givename= 'tacos',
            category= 'Nourritures',
            price= 20,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 5,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 5,
        },
        {
            id= 6,
            image= 'https://media.discordapp.net/attachments/1147903108442226779/1148218396383653888/laitchoco.webp',
            label= 'Lait',
            givename= 'lait',
            category= 'Boissons',
            price= 5,
        },
        {
            id= 7,
            image= 'https://media.discordapp.net/attachments/1147903108442226779/1148218098520952842/caprisun.webp',
            label= 'Capri-Sun',
            givename= 'caprisun',
            category= 'Boissons',
            price= 5,
        },
    },
}

local CluckinBell_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/header_cluckinbell.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_bucket.webp',
            label= 'Buckets',
            givename= 'gncluckinbucket',
            category= 'Nourritures',
            price= 15,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_burg.webp',
            label= 'Burger',
            givename= 'gncluckinburg',
            category= 'Nourritures',
            price= 15,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_fowl.webp',
            label= 'Volaille à croquer',
            givename= 'gncluckinfowl',
            category= 'Nourritures',
            price= 15,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_fries.webp',
            label= 'Frites',
            givename= 'gncluckinfries',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_kids.webp',
            label= 'Menu Enfant',
            givename= 'gncluckinkids',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_rings.webp',
            label= 'Onion Rings',
            givename= 'gncluckinrings',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_salad.webp',
            label= 'Salade',
            givename= 'gncluckinsalad',
            category= 'Nourritures',
            price= 15,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_soup.webp',
            label= 'Soupe',
            givename= 'gncluckinsoup',
            category= 'Nourritures',
            price= 15,
        },
    },


    elementsBoissons = {
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_cup.webp',
            label= 'soda',
            givename= 'gncluckincup',
            category= 'Boissons',
            price= 7,
        },
    },
}

-- Nourritures

local BahamaMamas_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/header_bahamamamas.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Tapas.webp',
            label= 'Tapas',
            givename= 'Tapas',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Bloody_Mary.webp',
            label= 'Bloody Mary',
            givename= 'BloodyMary',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Blue-Mamas.webp',
            label= 'Blue-Mamas',
            givename= 'Blue-Mamas',
            category= 'Alcool',
            price= 37,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Gin.webp',
            label= 'Gin',
            givename= 'Gin',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Mojito.webp',
            label= 'Mojito',
            givename= 'Mojito',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Punch.webp',
            label= 'Punch',
            givename= 'Punch',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/White_Lady.webp',
            label= 'White Lady',
            givename= 'WhiteLady',
            category= 'Alcool',
            price= 22,
        },
    },
}

local club77_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_club77.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Tapas.webp',
            label= 'Tapas',
            givename= 'Tapas',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/beer.webp',
            label= 'Bière',
            givename= 'beer',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jagger.webp',
            label= 'Jagger',
            givename= 'jagger',
            category= 'Alcool',
            price= 37,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            givename= 'rhum',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/vodka.webp',
            label= 'Vodka',
            givename= 'vodka',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/whisky.webp',
            label= 'Whisky',
            givename= 'whisky',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/champagne.webp',
            label= 'Champagne',
            givename= 'champagne',
            category= 'Alcool',
            price= 22,
        },
    },
}


local vClub_toSend = {
    headerImage = 'https://media.discordapp.net/attachments/1153604219740377098/1154920459192782950/Design_sans_titre_2.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Tapas.webp',
            label= 'Tapas',
            givename= 'Tapas',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/beer.webp',
            label= 'Bière',
            givename= 'beer',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jagger.webp',
            label= 'Jagger',
            givename= 'jagger',
            category= 'Alcool',
            price= 37,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            givename= 'rhum',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/vodka.webp',
            label= 'Vodka',
            givename= 'vodka',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/whisky.webp',
            label= 'Whisky',
            givename= 'whisky',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/champagne.webp',
            label= 'Champagne',
            givename= 'champagne',
            category= 'Alcool',
            price= 22,
        },
    },
}

-- Nourritures

local BayviewLodge_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/header_bayviewlodge.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Applepie.webp',
            label= 'Apple pie',
            givename= 'Applepie',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Poutine.webp',
            label= 'Poutine',
            givename= 'Poutine',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Saucisson.webp',
            label= 'Saucisson',
            givename= 'Saucisson',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Pancakes.webp',
            label= 'Pancakes',
            givename= 'Pancakes',
            category= 'Nourritures',
            price= 10,
        },

        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Entrecote.webp',
            label= 'Entrecôte',
            givename= 'Entrecote',
            category= 'Nourritures',
            price= 20,
        },

        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Oeufsbacon.webp',
            label= 'Oeufs Bacon',
            givename= 'OeufsBacon',
            category= 'Nourritures',
            price= 20,
        },

        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Mac&cheese.webp',
            label= 'Mac & cheese',
            givename= 'Mac&cheese',
            category= 'Nourritures',
            price= 20,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/BayviewBeer.webp',
            label= 'Bayview Beer',
            givename= 'BayviewBeer',
            category= 'Alcool',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/DuffBeer.webp',
            label= 'Duff Beer',
            givename= 'DuffBeer',
            category= 'Alcool',
            price= 10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Blonde.webp',
            label= 'Bière Blonde',
            givename= 'Blonde',
            category= 'Alcool',
            price= 10,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Hydromel.webp',
            label= 'Hydromel',
            givename= 'Hydromel',
            category= 'Alcool',
            price= 12,
        },
    },
}

-- Nourritures

local BurgerShot_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/header_burgershot.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/fries_box.webp',
            label= 'Frites',
            givename= 'friesbox',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/chicken_wrap.webp',
            label= 'Wrap Poulet',
            givename= 'chickenwrap',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/the_simply_burger.webp',
            label= 'Fishburger',
            givename= 'fishburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/the_glorious_burger.webp',
            label= 'Cheeseburger',
            givename= 'thegloriousburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/double_shot_burger.webp',
            label= 'Double Cheese',
            givename= 'doubleshotburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/meteorite_icecream.webp',
            label= 'Glace Meteorite',
            givename= 'meteoriteicecream',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/orangotang_icecream.webp',
            label= 'Glace Orangotang',
            givename= 'orangotangicecream',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/goat_cheese_wrap.webp',
            label= 'Wrap Chèvre',
            givename= 'goatcheesewrap',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/tacos.webp',
            label= 'Tacos',
            givename= 'tacos',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/the_fabulous_6lb_burger.webp',
            label= 'Fabulous Burger',
            givename= 'thefabulous6lbburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/bleeder_burger.webp',
            label= 'Bleeder Burger',
            givename= 'bleederburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/prickly_burger.webp',
            label= 'Prickly Burger',
            givename= 'prickyburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
    },

    elementsBoissons = {
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'Jus',
            ItemCategory= 'Boissons',
            price= 10,
        },
    },

    elementsAlcool = {
        
    },
}

-- Nourritures

local ComradesBar_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/header_comradesbar.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Aperitifs.webp',
            label= 'Apéritifs',
            givename= 'Aperitifs',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cacahueteswmrd.webp',
            label= 'Cacahuètes',
            givename= 'cacahueteswmrd',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boeufseche.webp',
            label= 'Boeuf Séché',
            givename= 'boeufseche',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cheesestick.webp',
            label= 'Bâtonnet de Fromage',
            givename= 'cheesestick',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/maxiplanche.webp',
            label= 'Maxi Planche',
            givename= 'maxiplanche',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fromagesdes.webp',
            label= 'Cubes de Fromage',
            givename= 'fromagesdes',
            category= 'Nourritures',
            price= 5,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/chipscmrd.webp',
            label= 'Chips',
            givename= 'chipscmrd',
            category= 'Nourritures',
            price= 5,
        },
    },

    elementsBoissons = {
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/diabolored.webp',
            label= 'Diabolo',
            givename='diabolored',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/eaumineral.webp',
            label= 'Eau Mineral',
            givename='eaumineral',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Blonde.webp',
            label= 'Bière Blonde',
            givename= 'Blonde',
            price= 15,
            category= 'Alcool',
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Irish_coffee.webp',
            label= 'Irish Coffee',
            givename= 'irishc',
            category= 'Alcool',
            price= 15,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Camarade.webp',
            label= 'Camarade',
            givename= 'Camarade',
            category= 'Alcool',
            price= 17,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Jaggerbomb.webp',
            label= 'Jäggerbomb',
            givename= 'Jaggerbomb',
            category= 'Alcool',
            price= 15,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            givename= 'Vodka',
            category= 'Alcool',
            price= 15,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            givename= 'Whisky',
            category= 'Alcool',
            price= 15,
        },
        {
            id= 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            givename= 'rhum',
            category= 'Alcool',
            price= 17,
        },
        {
            id= 13,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tequila.webp',
            label= 'Tequila',
            givename= 'tequila',
            category= 'Alcool',
            price= 15,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowrp.webp',
            label= 'Yellow Rose Premium',
            givename='yellowrp',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowro.webp',
            label= 'Yellow Rose Outlaw',
            givename='yellowro',
            category= 'Alcool',
            price= 22,
        },
    },
}

-- Nourritures

local PopsDiner_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/header_popsdiner.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Cesar.webp',
            label= 'César',
            givename= 'Cesar',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Hot_dog.webp',
            label= 'Hot Dog',
            givename= 'Hotdog',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Mozza_sticks.webp',
            label= 'Mozza Sticks',
            givename= 'Mozzasticks',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Pancakes.webp',
            label= 'Pancakes',
            givename= 'Pancakes',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/pizza-7945.webp',
            label= 'Pizza',
            givename= 'pizza-7945',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Pulled_Pork.webp',
            label= 'Pulled Pork',
            givename= 'PulledPork',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Sandwich.webp',
            label= 'Sandwich',
            givename= 'Sandwich',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 11,
            image= 'https://cdn.discordapp.com/attachments/1145780120846614598/1145780120993407096/png_20230828_171524_0000.webp',
            label= 'Panini',
            givename= 'panini',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 12,
            image= 'https://cdn.discordapp.com/attachments/1145780120846614598/1145780120993407096/png_20230828_171524_0000.webp',
            label= 'Frite',
            givename= 'frite',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Eggs_muffin.webp',
            label= 'Eggs Muffin',
            givename= 'Eggs_muffin',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donuts',
            givename= 'donutn',
            category= 'Nourritures',
            price= 8,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Glace.webp',
            label= 'Glace Vanille',
            givename= 'vanilaicecream',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Waffle.webp',
            label= 'Gaufre',
            givename= 'Waffle',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Pancakes.webp',
            label= 'Crêpe',
            givename= 'Pancakes',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Granita_upnatom.webp',
            label= 'Granita',
            givename= 'Granita_upnatom',
            category= 'Boissons',
            price=7,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Milkshake_Hornys.webp',
            label= 'Milkshake',
            givename= 'Milkshake_Hornys',
            category= 'Boissons',
            price=7,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Coffee_Hornys.webp',
            label= 'Café',
            givename= 'Coffee_Hornys',
            category= 'Boissons',
            price=7,
        },
    },

    elementsAlcool = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/911.webp',
            label= '911',
            givename= '911',
            category= 'Alcool',
            price= 12,
        },
        {
            id= 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/beer.webp',
            label= 'Bière',
            givename= 'beer',
            category= 'Alcool',
            price=11,
        },
    },
}

local RexDiner_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_rexdiner.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = PopsDiner_toSend.elements,

    elementsBoissons = PopsDiner_toSend.elementsBoissons,

    elementsAlcool = PopsDiner_toSend.elementsAlcool,
}

-- Boissons

-- Nourritures

local YellowJack_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/header_yellowjack.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Aperitifs.webp',
            label= 'Apéritifs',
            givename= 'Aperitifs',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 19,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donut',
            givename= 'donut',
            category= 'Nourritures',
            price= 16,
        },
        {
            id= 20,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Frites_Hornys.webp',
            label= 'Frites',
            givename= 'gncluckinfries',
            category= 'Nourritures',
            price= 40,
        },
        {
            id= 21,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Mozza_sticks.webp',
            label= 'Mozza Sticks',
            givename= 'mozzasticks',
            category= 'Nourritures',
            price= 20,
        },
    },

    elementsBoissons = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Soda.webp',
            label= 'soda',
            givename= 'soda',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Blonde.webp',
            label= 'Bière Blonde',
            givename= 'Blonde',
            category= 'Alcool',
            price= 11,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Brune.webp',
            label= 'Bière Brune',
            givename= 'Brune',
            category= 'Alcool',
            price= 11,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Rousse.webp',
            label= 'Bière Rousse',
            givename= 'Rousse',
            category= 'Alcool',
            price= 11,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Ambree.webp',
            label= 'Bière Ambrée',
            givename= 'Ambree',
            category= 'Alcool',
            price= 11,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Shamrock.webp',
            label= 'Shamrock',
            givename= 'Shamrock',
            category= 'Alcool',
            price= 11,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/RhumCoke.webp',
            label= 'Rhum Coke',
            givename= 'RhumCoke',
            category= 'Alcool',
            price= 11,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Pisse_d_ane.webp',
            label= 'Pisse d\'Âne',
            givename= 'Pissedane',
            category= 'Alcool',
            price= 17,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowrp.webp',
            label= 'Yellow Rose Premium',
            givename='yellowrp',
            ItemCategory= 'Alcool',
            category= 'Alcool',
            price= 22,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowro.webp',
            label= 'Yellow Rose Outlaw',
            givename= 'yellowro',
            ItemCategory= 'Alcool',
            category= 'Alcool',
            price= 22,
        },
    },

    elementsUtilitaires = {
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigar.webp',
            label = 'Cigar',
            price = 5,
            givename = "cigar",
            category= 'Utilitaires'
        },
    },
}



local LTD_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/header_ltd.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Chips.webp',
            label = 'Chips',
            price = 5,
            givename = "Chips",
            category= 'Nourritures'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sandwich_triangle.webp',
            label = 'Sandwich Triangle',
            price = 5,
            givename = "triangle",
            category= 'Nourritures'
        },
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sucette.webp',
            label = 'Sucette',
            price = 5,
            givename = "lollipop",
            category= 'Nourritures'
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Glace_a_l_italienne.webp',
            label = 'Glace a l\'Italienne',
            price = 5,
            givename = "GlaceItalienne",
            category= 'Nourritures'
        },
        {
            id = 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Barre_de_cereale.webp',
            label = 'Barre Céréales',
            price = 5,
            givename = "BarreCereale",
            category= 'Nourritures'
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/lait_chocolat.webp',
            label= 'Lait Chocolat',
            givename= 'laitchoco',
            category= 'Boissons',
            price= 2,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Bouteille_petillante.webp',
            label= 'Eau Pétillante',
            givename= 'eaupetillante',
            category= 'Boissons',
            price= 2,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Bouteille d\'eau',
            givename= 'water',
            category= 'Boissons',
            price= 2,
        },
    },

    elementsUtilitaires = {
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigarettes.webp',
            label = 'Cigarette',
            price = 5,
            givename = "cig",
            category= 'Utilitaires'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Ciseaux.webp',
            label = 'Ciseaux',
            price = 25,
            givename = "scissors",
            category= 'Utilitaires'
        }, 
        --{
        --    id = 1,
        --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/ordinateur.webp',
        --    label = 'Ordinateur',
        --    price= 100,
        --    subCategory = 'CATALOGUE LTD',
        --    givename = "laptop"
        --},
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Pince_a_cheveux.webp',
            label = 'Pince à cheveux',
            givename = "pince",
            category= 'Utilitaires',
            price= 15
        },

        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/can.webp',
            label = 'Canette Vide',
            price = 5,
            givename = "can",
            category= 'Utilitaires'
        },

        {
            id = 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Recycleur.webp',
            label = 'Recycleur',
            price = 325,
            givename = "recycleur",
            category= 'Utilitaires'
        }, 
        {
            id = 6,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Telephone.webp',
            label = 'Téléphone',
            price = 25,
            givename = "phone",
            category= 'Utilitaires'
        }, 
        {
            id = 7,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boombox.webp',
            label = 'Boombox',
            price = 50,
            givename = "boombox",
            category= 'Utilitaires'
        },

        {
            id = 8,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/umbrella.webp',
            label = 'Parapluie',
            price = 15,
            givename = "umbrella",
            category= 'Utilitaires'
        },

        {
            id = 9,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bloc_note.webp',
            label = 'Bloc-note',
            price = 5,
            givename = "blocnote",
            category= 'Utilitaires'
        },
        {
            id = 10,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jumelle.webp',
            label = 'Jumelle',
            price = 100,
            givename = "jumelle",
            category= 'Utilitaires'
        },
        {
            id = 11,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fishroad.webp',
            label = 'Canne Pêche',
            price = 25,
            givename = "fishroad",
            category= 'Utilitaires'
        },
        {
            id = 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigar.webp',
            label = 'Cigar',
            price = 5,
            givename = "cigar",
            category= 'Utilitaires'
        },

        {
            id = 13,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/parachute.webp',
            label = 'Parachute',
            price = 325,
            givename = "gadget_parachute",
            category= 'Utilitaires'
        },


        {
            id = 14,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cleaner.webp',
            label = 'Cleaner',
            price = 5,
            givename = "cleaner",
            category= 'Utilitaires'
        },

        {
            id = 15,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/sactete.webp',
            label = 'Sacs',
            price = 150,
            givename = "sactete",
            category= 'Utilitaires'
        },

        {
            id = 16,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp',
            label = 'GPS',
            price = 25,
            givename = "gps",
            category= 'Utilitaires'
        },

        {
            id = 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/malettecuir.webp',
            label = 'Malette en Cuir',
            price = 150,
            givename = "malettecuir",
            category= 'Utilitaires'
        },
        {
            id = 18,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Radio.webp',
            label = 'Radio',
            price = 25,
            givename = "radio",
            category= 'Utilitaires'
        }, 

    },
}

local Dons_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_rexdiner.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Chips.webp',
            label = 'Chips',
            price = 5,
            givename = "Chips",
            category= 'Nourritures'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sandwich_triangle.webp',
            label = 'Sandwich Triangle',
            price = 5,
            givename = "triangle",
            category= 'Nourritures'
        },
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sucette.webp',
            label = 'Sucette',
            price = 5,
            givename = "lollipop",
            category= 'Nourritures'
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Glace_a_l_italienne.webp',
            label = 'Glace a l\'Italienne',
            price = 5,
            givename = "GlaceItalienne",
            category= 'Nourritures'
        },
        {
            id = 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Barre_de_cereale.webp',
            label = 'Barre Céréales',
            price = 5,
            givename = "BarreCereale",
            category= 'Nourritures'
        },

        {
            id = 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/twinkies.webp',
            label = 'Twinkies',
            price = 5,
            givename = "twinkies",
            category= 'Nourritures'
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/lait_chocolat.webp',
            label= 'Lait Chocolat',
            givename= 'laitchoco',
            category= 'Boissons',
            price= 2,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Bouteille_petillante.webp',
            label= 'Eau Pétillante',
            givename= 'eaupetillante',
            category= 'Boissons',
            price= 2,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Bouteille d\'eau',
            givename= 'water',
            category= 'Boissons',
            price= 2,
        },
    },

    elementsUtilitaires = {
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigarettes.webp',
            label = 'Cigarette',
            price = 5,
            givename = "cig",
            category= 'Utilitaires'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Ciseaux.webp',
            label = 'Ciseaux',
            price = 25,
            givename = "scissors",
            category= 'Utilitaires'
        }, 
        --{
        --    id = 1,
        --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/ordinateur.webp',
        --    label = 'Ordinateur',
        --    price= 100,
        --    subCategory = 'CATALOGUE LTD',
        --    givename = "laptop"
        --},
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Pince_a_cheveux.webp',
            label = 'Pince à cheveux',
            givename = "pince",
            category= 'Utilitaires',
            price= 15
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Radio.webp',
            label = 'Radio',
            price = 25,
            givename = "radio",
            category= 'Utilitaires'
        }, 
--[[         {
            id = 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Recycleur.webp',
            label = 'Recycleur',
            price = 325,
            givename = "recycleur",
            category= 'Utilitaires'
        },  ]]
        {
            id = 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/can.webp',
            label = 'Canette Vide',
            price = 5,
            givename = "can",
            category= 'Utilitaires'
        },

        {
            id = 6,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Telephone.webp',
            label = 'Téléphone',
            price = 25,
            givename = "phone",
            category= 'Utilitaires'
        }, 
        {
            id = 7,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boombox.webp',
            label = 'Boombox',
            price = 50,
            givename = "boombox",
            category= 'Utilitaires'
        },

        {
            id = 8,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/umbrella.webp',
            label = 'Parapluie',
            price = 15,
            givename = "umbrella",
            category= 'Utilitaires'
        },

        {
            id = 9,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bloc_note.webp',
            label = 'Bloc-note',
            price = 5,
            givename = "blocnote",
            category= 'Utilitaires'
        },
        {
            id = 10,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jumelle.webp',
            label = 'Jumelle',
            price = 100,
            givename = "jumelle",
            category= 'Utilitaires'
        },
        {
            id = 11,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fishroad.webp',
            label = 'Canne Pêche',
            price = 100,
            givename = "fishroad",
            category= 'Utilitaires'
        },
        {
            id = 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigar.webp',
            label = 'Cigar',
            price = 5,
            givename = "cigar",
            category= 'Utilitaires'
        },

        {
            id = 13,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/parachute.webp',
            label = 'Parachute',
            price = 325,
            givename = "gadget_parachute",
            category= 'Utilitaires'
        },


        {
            id = 14,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cleaner.webp',
            label = 'Cleaner',
            price = 5,
            givename = "cleaner",
            category= 'Utilitaires'
        },

        {
            id = 15,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/sactete.webp',
            label = 'Sacs',
            price = 150,
            givename = "sactete",
            category= 'Utilitaires'
        },

        {
            id = 16,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp',
            label = 'GPS',
            price = 25,
            givename = "gps",
            category= 'Utilitaires'
        },

        {
            id = 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/malettecuir.webp',
            label = 'Malette en Cuir',
            price = 150,
            givename = "malettecuir",
            category= 'Utilitaires'
        },


    },
}

local blackwood_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_blackwood.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Applepie.webp',
            label= 'Apple pie',
            givename= 'Applepie',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Poutine.webp',
            label= 'Poutine',
            givename= 'Poutine',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Saucisson.webp',
            label= 'Saucisson',
            givename= 'Saucisson',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Pancakes.webp',
            label= 'Pancakes',
            givename= 'Pancakes',
            category= 'Nourritures',
            price= 10,
        },

        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Entrecote.webp',
            label= 'Entrecôte',
            givename= 'Entrecote',
            category= 'Nourritures',
            price= 20,
        },

        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Oeufsbacon.webp',
            label= 'Oeufs Bacon',
            givename= 'OeufsBacon',
            category= 'Nourritures',
            price= 20,
        },

        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Mac&cheese.webp',
            label= 'Mac & cheese',
            givename= 'Mac&cheese',
            category= 'Nourritures',
            price= 20,
        },
    },

    elementsBoissons = {
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            givename= 'Jusdefruits',
            category= 'Boissons',
            price= 7,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price= 7,
        },
    },

    elementsAlcool = {
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/BayviewBeer.webp',
            label= 'Bayview Beer',
            givename= 'BayviewBeer',
            category= 'Alcool',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/DuffBeer.webp',
            label= 'Duff Beer',
            givename= 'DuffBeer',
            category= 'Alcool',
            price= 10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Blonde.webp',
            label= 'Bière Blonde',
            givename= 'Blonde',
            category= 'Alcool',
            price= 10,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Hydromel.webp',
            label= 'Hydromel',
            givename= 'Hydromel',
            category= 'Alcool',
            price= 12,
        },
    },
}

-- MECANO

local bennys_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_bennys.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 99,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kitmoteur.webp',
            label= 'Kit moteur',
            givename= 'kitmoteur',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}

local ocean_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_ocean.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}


local cayogarage_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_bennys.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 99,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kitmoteur.webp',
            label= 'Kit moteur',
            givename= 'kitmoteur',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}

local hayesauto_toSend = {
    headerImage = 'https://media.discordapp.net/attachments/1142829822821797929/1146736570037194752/Ban_Hayes_Final.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 99,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kitmoteur.webp',
            label= 'Kit moteur',
            givename= 'kitmoteur',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}

local beekersgarage_toSend = {
    headerImage = 'https://media.discordapp.net/attachments/1142829822821797929/1146736522419249223/Ban_Beekers_Final.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 99,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kitmoteur.webp',
            label= 'Kit moteur',
            givename= 'kitmoteur',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}

local sunshine_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_sunshine.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 99,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kitmoteur.webp',
            label= 'Kit moteur',
            givename= 'kitmoteur',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}

local harmony_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_harmonyrepair.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elementsUtilitaires = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            givename= 'weapon_petrolcan',
            price= 50,
            category= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            givename= 'spray',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            givename= 'repairkit',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            givename= 'cleankit',
            price= 15,
            category= 'Utilitaires',
        },
        {
            id= 99,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/kitmoteur.webp',
            label= 'Kit moteur',
            givename= 'kitmoteur',
            price= 250,
            category= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            givename= 'sangle',
            price= 150,
            category= 'Utilitaires',
        },
    },
}

local Pizzeria_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_pizzeria.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzaburata.webp',
            label= 'Pizza Burata',
            givename= 'pizzaburata',
            category= 'Nourritures',
            price= 100,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzamarghe.webp',
            label= 'Pizza Margherita',
            givename= 'pizzamarghe',
            category= 'Nourritures',
            price= 120,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizza4fromage.webp',
            label= 'Pizza 4 fromages',
            givename= 'pizza4fromage',
            category= 'Nourritures',
            price= 120,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzachevre.webp',
            label= 'Pizza Chèvre Miel',
            givename= 'pizzachevre',
            category= 'Nourritures',
            price= 120,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/crostini.webp',
            label= 'Crostini',
            givename= 'crostini',
            category= 'Nourritures',
            price= 110,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/tiramisu.webp',
            label= 'Tiramisu',
            givename= 'tiramisu',
            category= 'Nourritures',
            price= 90,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/saladeburata.webp',
            label= 'Salade Burata',
            givename= 'saladeburata',
            category= 'Nourritures',
            price= 110,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzanutella.webp',
            label= 'Pizza Nutella',
            givename= 'pizzanutella',
            category= 'Nourritures',
            price= 110,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/saladedefruit.webp',
            label= 'Salade de fruits',
            givename= 'saladedefruit',
            category= 'Nourritures',
            price= 90,
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Eau',
            givename= 'water',
            category= 'Boissons',
            price=90,
        },
        {
            id=2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'Sprunk',
            givename= 'sprunk',
            category= 'Boissons',
            price=90,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'E-cola',
            givename= 'ecola',
            category= 'Boissons',
            price=90,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price=90,
        },

    }
}

local Pearl_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_pearl.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Crevettes.webp',
            label= 'Crevettes',
            givename= 'Crevettes',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/FishBowl.webp',
            label= 'FishBowl',
            givename= 'FishBowl',
            category= 'Nourritures',
            price= 7,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Huitres.webp',
            label= 'Huitres',
            givename= 'Huitres',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Moules.webp',
            label= 'Moules',
            givename= 'Moules',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Fruits_de_mer.webp',
            label= 'Plateau des mers',
            givename= 'seafood-in-wood-',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Tarte_au_Citron.webp',
            label= 'Tarte au Citron',
            givename= 'Tarte_au_Citron',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Glace.webp',
            label= 'Glace Vanille',
            givename= 'vanilaicecream',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/accras_crevettes.webp',
            label= 'Accras Crevettes',
            givename= 'accras_crevettes',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bananes_plantains.webp',
            label= 'Bananes Plantains',
            givename= 'bananes_plantains',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/samoussa.webp',
            label= 'Samoussa',
            givename= 'samoussa',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/rougaille_saucisse.webp',
            label= 'Rougaille Saucisse',
            givename= 'rougaille_saucisse',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/colombo_poulet.webp',
            label= 'Colombo Poulet',
            givename= 'colombo_poulet',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bokit_bocane.webp',
            label= 'Bokit Bocane',
            givename= 'bokit_bocane',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bokit_poulet.webp',
            label= 'Bokit Poulet',
            givename= 'bokit_poulet',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bokit_morue.webp',
            label= 'Bokit Morue',
            givename= 'bokit_morue',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/salade_antillaise.webp',
            label= 'Salade Antillaise',
            givename= 'salade_antillaise',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/glace_mangue.webp',
            label= 'Glace Mangue',
            givename= 'glace_mangue',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 18,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/glace_coco.webp',
            label= 'Glace Coco',
            givename= 'glace_coco',
            category= 'Nourritures',
            price= 10,
        },

    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Limonade.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price=7,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Cocktail.webp',
            label= 'Cocktail',
            givename= 'Cocktail',
            category= 'Boissons',
            price= 15,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/royalsoda_grenadine.webp',
            label= 'RoyalSoda Grenadine',
            givename= 'royalsoda_grenadine',
            category= 'Boissons',
            price= 15,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/royalsoda_annanas.webp',
            label= 'RoyalSoda Annanas',
            givename= 'royalsoda_annanas',
            category= 'Boissons',
            price= 15,
        },
    },

    elementsAlcool = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Vin_blanc.webp',
            label= 'Vin Blanc',
            givename= 'Vinblanc',
            category= 'Boissons',
            price=17,
        },
        {
            id=2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Vin_rouge.webp',
            label= 'Vin Rouge',
            givename= 'Vinrouge',
            category= 'Boissons',
            price=17,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/punch_planteur.webp',
            label= 'Punch Planteur',
            givename= 'punch_planteur',
            category= 'Boissons',
            price=17,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/punch_coco.webp',
            label= 'Punch Coco',
            givename= 'punch_coco',
            category= 'Boissons',
            price=17,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/rhum_agricole.webp',
            label= 'Rhum Agricole',
            givename= 'rhum_agricole',
            category= 'Boissons',
            price=17,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=17,
        },
    },
}

local Hornys_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/hornys.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Frites_Hornys.webp',
            label= 'Frites',
            givename= 'Frites_Hornys',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Batonspoulet_Hornys.webp',
            label= 'Batons de Poulet',
            givename= 'Batonspoulet_Hornys',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Burgerpoulet_Hornys.webp',
            label= 'Burger Poulet',
            givename= 'Burgerpoulet_Hornys',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Wrappoulet_Hornys.webp',
            label= 'Wrap Poulet',
            givename= 'Wrappoulet_Hornys',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Pignonpoulet_Hornys.webp',
            label= 'Pignon de Poulet',
            givename= 'Pignonpoulet_Hornys',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Donut_Hornys.webp',
            label= 'Donut',
            givename= 'Donut_Hornys',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Milkshake_Hornys.webp',
            label= 'Milkshake',
            givename= 'Milkshake_Hornys',
            category= 'Boissons',
            price=7,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Coffee_Hornys.webp',
            label= 'Café',
            givename= 'Coffee_Hornys',
            category= 'Boissons',
            price=7,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Soda_Hornys.webp',
            label= 'soda',
            givename= 'Soda_Hornys',
            category= 'Boissons',
            price=7,
        },
    },
}
local Upnatom_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_upnatom.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Frites_zigzag.webp',
            label= 'Frites Zigzag',
            givename= 'Frites_zigzag',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Onion_rings.webp',
            label= 'Onion Rings',
            givename= 'Onion_rings',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Eggs_muffin.webp',
            label= 'Eggs Muffin',
            givename= 'Eggs_muffin',
            category= 'Nourritures',
            price= 10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Black_burger.webp',
            label= 'Black Burger',
            givename= 'Black_burger',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Burger_Uranus.webp',
            label= 'Saturne Burger',
            givename= 'Burger_Uranus',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Burger_earth.webp',
            label= 'Earth Burger',
            givename= 'Burger_earth',
            category= 'Nourritures',
            price= 20,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Cup_space.webp',
            label= 'Cup Space',
            givename= 'Cup_space',
            category= 'Nourritures',
            price= 10,
        },
    },

    elementsBoissons = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Granita_upnatom.webp',
            label= 'Granita',
            givename= 'Granita_upnatom',
            category= 'Boissons',
            price=7,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Ice_cup.webp',
            label= 'Ice Cup',
            givename= 'Ice_cup',
            category= 'Boissons',
            price=7,
        },
    },
}

function OpenPostOPCatalogue(catChoice)
	print('CATALOGUE CHOICE', catChoice)

    if catChoice == 'UwUcafe' then
        toSend = UwUcafe_toSend
    elseif catChoice == 'BeanMachine' then
        toSend = BeanMachine_toSend
    elseif catChoice == 'LeMiroir' then
        toSend = LeMiroir_toSend
    elseif catChoice == 'Unicorn' then
        toSend = VanillaUnicorn_toSend
    elseif catChoice == 'RoyalHotel' then
        toSend = RoyalHotel_toSend
    elseif catChoice == 'CluckinBell' then
        toSend = CluckinBell_toSend
    elseif catChoice == 'PopsDiner' then
        toSend = PopsDiner_toSend
	elseif catChoice == 'RexDiner' then
        toSend = RexDiner_toSend
	elseif catChoice == 'skyblue' then
        toSend = Skyblue_toSend
    elseif catChoice == 'BurgerShot' then
        toSend = BurgerShot_toSend
    elseif catChoice == 'YellowJack' then
        toSend = YellowJack_toSend
    elseif catChoice == 'BayviewLodge' then
        toSend = BayviewLodge_toSend
    elseif catChoice == 'pizzeria' then
        toSend = Pizzeria_toSend
    elseif catChoice == 'pearl' then
        toSend = Pearl_toSend
    elseif catChoice == 'upnatom' then
        toSend = Upnatom_toSend
    elseif catChoice == 'hornys' then
        toSend = Hornys_toSend
    elseif catChoice == 'Bahamas' then
        toSend = BahamaMamas_toSend
    elseif catChoice == 'vclub' then
        toSend = vClub_toSend
    elseif catChoice == 'club77' then
        toSend = club77_toSend
    elseif catChoice == 'Comrades' then
        toSend = ComradesBar_toSend
    elseif catChoice == 'ltdsud' then
        toSend = LTD_toSend
    elseif catChoice == 'ltdseoul' then
        toSend = LTD_toSend
    elseif catChoice == 'ltdmirror' then
        toSend = LTD_toSend
    elseif catChoice == 'don' then
        toSend = Dons_toSend
    elseif catChoice == 'blackwood' then
        toSend = blackwood_toSend
    elseif catChoice == 'bennys' then
        toSend = bennys_toSend
    elseif catChoice == 'ocean' then
        toSend = ocean_toSend
    elseif catChoice == 'cayogarage' then
        toSend = cayogarage_toSend
    elseif catChoice == 'hayes' then
        toSend = hayesauto_toSend
    elseif catChoice == 'beekers' then
        toSend = beekersgarage_toSend
    elseif catChoice == 'sunshine' then
        toSend = sunshine_toSend
    elseif catChoice == 'harmony' then
        toSend = harmony_toSend
    elseif catChoice == 'tacosrancho' then
        toSend = Tacos2Rancho_toSend
    end

    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuCatalogue',
        data = toSend
    }));
    forceHideRadar()
end

RegisterNUICallback("focusOut", function (data, cb)
    TriggerScreenblurFadeOut(0.5)
    DisplayHud(true)
    openRadarProperly()
end)

function GetCataloguePostOPItems(job)
    local toSend;

    --print('JOB', json.encode(job))

    if job == 'uwu' then
        toSend = UwUcafe_toSend
    elseif job == 'beanmachine' then
        toSend = BeanMachine_toSend
    elseif job == 'lemiroir' then
        toSend = LeMiroir_toSend
    elseif job == 'unicorn' then
        toSend = VanillaUnicorn_toSend
    elseif job == 'royalhotel' then
        toSend = RoyalHotel_toSend
    elseif job == 'cluckinbell' then
        toSend = CluckinBell_toSend
    elseif job == 'popsdiner' then
        toSend = PopsDiner_toSend
	elseif job == 'skyblue' then
        toSend = Skyblue_toSend
	elseif job == 'rexdiner' then
        toSend = RexDiner_toSend
    elseif job == 'burgershot' then
        toSend = BurgerShot_toSend
    elseif job == 'yellowjack' then
        toSend = YellowJack_toSend
    elseif job == 'bayviewLodge' then
        toSend = BayviewLodge_toSend
    elseif job == 'bahamas' then
        toSend = BahamaMamas_toSend
    elseif job == 'vclub' then
        toSend = vClub_toSend
    elseif job == 'comrades' then
        toSend = ComradesBar_toSend
    elseif job == 'ltdsud' then
        toSend = LTD_toSend
    elseif job == 'ltdseoul' then
        toSend = LTD_toSend
    elseif job == 'ltdmirror' then
        toSend = LTD_toSend
    elseif job == 'don' then
        toSend = Dons_toSend
    elseif job == 'club77' then
        toSend = club77_toSend
    elseif job == 'blackwood' then
        toSend = blackwood_toSend
    elseif job == 'bennys' then
        toSend = bennys_toSend
    elseif job == 'ocean' then
        toSend = ocean_toSend  
    elseif job == 'cayogarage' then
        toSend = cayogarage_toSend
    elseif job == 'hayes' then
        toSend = hayesauto_toSend
    elseif job == 'beekers' then
        toSend = beekersgarage_toSend
    elseif job == 'sunshine' then
        toSend = sunshine_toSend
    elseif job == 'harmony' then
        toSend = harmony_toSend
    elseif job == 'pizzeria' then
        toSend = Pizzeria_toSend
    elseif job == 'pearl' then
        toSend = Pearl_toSend
    elseif job == 'upnatom' then
        toSend = Upnatom_toSend
    elseif job == 'hornys' then
        toSend = Hornys_toSend
    elseif job == 'tacosrancho' then
        toSend = Tacos2Rancho_toSend
    end

    return toSend
end