local toSend = nil

local UwUcafe_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/header_uwucoffee.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/BarbaMilk.webp',
            label= 'BarbaMilk',
            price=100,
            ItemCategory= 'Boissons',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Bubble_Tea.webp',
            label= 'Bubble Tea',
            price=110,
            ItemCategory= 'Boissons',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/CatPat.webp',
            label= 'CatPat',
            price=140,
            ItemCategory= 'Nourritures',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Chat_Gourmand.webp',
            label= 'Chat Gourmand',
            ItemCategory= 'Nourritures',
            price=100,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Chatmallow.webp',
            label= 'Chatmallow',
            ItemCategory= 'Boissons',
            price=100,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Ice_Coffee.webp',
            label= 'Ice Coffee',
            ItemCategory= 'Boissons',
            price=100,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/IceCream_Cat.webp',
            label= 'IceCream Cat',
            ItemCategory= 'Boissons',
            price=100,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Lailait_chaud.webp',
            label= 'Lailait chaud',
            ItemCategory= 'Boissons',
            price=100,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Milkshake.webp',
            label= 'Milkshake',
            ItemCategory= 'Boissons',
            price=100,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Mochi.webp',
            label= 'Mochi',
            ItemCategory= 'Nourritures',
            price=90,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Pocky.webp',
            label= 'Pocky',
            ItemCategory= 'Nourritures',
            price=90,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/UwU_Burger-removebg-preview.webp',
            label= 'UwU Burger',
            ItemCategory= 'Nourritures',
            price=140,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/melto.webp',
            label= 'Melto',
            ItemCategory= 'Nourritures',
            price=140,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/lapinut.webp',
            label= 'Lapinut',
            ItemCategory= 'Nourritures',
            price=140,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/LatteMatcha.webp',
            label= 'Latte Matcha',
            ItemCategory= 'Boissons',
            price=100,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy.webp',
            label= 'Kitty Toy',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Arc_En_Ciel.webp',
            label= 'Kitty Toy Arc-en-ciel',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 18,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Bleu.webp',
            label= 'Kitty Toy Bleu',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 19,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Dark.webp',
            label= 'Kitty Toy Dark',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 20,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Flower.webp',
            label= 'Kitty Toy Flower',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 21,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Gris.webp',
            label= 'Kitty Toy Gris',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 22,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Jaune.webp',
            label= 'Kitty Toy Jaune',
            ItemCategory= 'Utilitaires',
            price=250,
        },
        {
            id= 23,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/uwu/Kitty_Toy_Vert-removebg-preview.webp',
            label= 'Kitty Toy Vert',
            ItemCategory= 'Utilitaires',
            price=250,
        },
    },
}

local VanillaUnicorn_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/header_unicorn.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Aperitifs.webp',
            label= 'Apéritifs',
            ItemCategory= 'Nourritures',
            price=20,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Cool_Granny.webp',
            label= 'Cool Granny',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Doudou.webp',
            label= 'Doudou',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/French_Kiss.webp',
            label= 'French Kiss',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Red_Velvet.webp',
            label= 'Red Velvet',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Sex_on_the_beach.webp',
            label= 'Sex On The Beach',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Uni_tail.webp',
            label= 'Uni Tail',
            ItemCategory= 'Alcool',
            price=300,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=150,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price=150,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 150,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Champagne',
            ItemCategory= 'Alcool',
            price= 620,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
            price= 140,
        },  
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            ItemCategory= 'Alcool',
            price= 140,
        },
    },
}

local RoyalHotel_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/royalhotel/header_royalhotel.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Aperitifs.webp',
            label= 'Apéritifs',
            ItemCategory= 'Nourritures',
            price=20,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Cool_Granny.webp',
            label= 'Cool Granny',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Doudou.webp',
            label= 'Doudou',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/French_Kiss.webp',
            label= 'French Kiss',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Red_Velvet.webp',
            label= 'Red Velvet',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Sex_on_the_beach.webp',
            label= 'Sex On The Beach',
            ItemCategory= 'Alcool',
            price=200,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Uni_tail.webp',
            label= 'Uni Tail',
            ItemCategory= 'Alcool',
            price=300,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=150,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price=150,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 150,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Champagne',
            ItemCategory= 'Alcool',
            price= 620,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
            price= 140,
        },  
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            ItemCategory= 'Alcool',
            price= 140,
        },
    },
}

local BeanMachine_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/header_beanmachine.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cafe_frappe.webp',
            label= 'Café frappé',
            ItemCategory= 'Boissons',
            price=5,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cafe_praline.webp',
            label= 'Café praliné',
            ItemCategory= 'Boissons',
            price=5,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cappuccino.webp',
            label= 'Cappuccino',
            ItemCategory= 'Boissons',
            price=5,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Caramel_macchiato.webp',
            label= 'Caramel macchiato',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Choco_guimauve.webp',
            label= 'Choco guimauve',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Theglace.webp',
            label= 'Thé glacé',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Chocolat_viennois.webp',
            label= 'Chocolat viennois',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cookie.webp',
            label= 'Cookie',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Expresso.webp',
            label= 'Expresso',
            ItemCategory= 'Boissons',
            price=5,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Latte.webp',
            label= 'Latte',
            ItemCategory= 'Boissons',
            price=5,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Muffin_choco.webp',
            label= 'Muffin choco',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Oeufsbacon.webp',
            label= 'Oeufs bacon',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutc.webp',
            label= 'Donuts Chocolat',
            ItemCategory= 'Nourritures',
            price= 16,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donuts Nature',
            ItemCategory= 'Nourritures',
            price= 16,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/Cheesecake.webp',
            label= 'Cheesecake',
            ItemCategory= 'Nourritures',
            price= 20,
        },
    },
}

local LeMiroir_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/header_lemiroir.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Fondant_chocolat.webp',
            label= 'Fondant au chocolat',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Waffle.webp',
            label= 'Gaufre',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Moules_frites.webp',
            label= 'Moules frites',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Plateau_de_charcuterie.webp',
            label= 'Plateau de charcuterie',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/escalope.webp',
            label= 'Escalope',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/seafoodInWood.webp',
            label= 'Plateau des mers',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/American_ribs.webp',
            label= 'American ribs',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/champagne.webp',
            label= 'Champagne',
            ItemCategory= 'Alcool',
            price=50,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Vin_blanc.webp',
            label= 'Vin Blanc',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Vin_rouge.webp',
            label= 'Vin Rouge',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price=10,
        },
        
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/caviar.webp',
            label= 'Caviar',
            ItemCategory= 'Nourritures',
            price= 20,
        },

        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/magret.webp',
            label= 'Magret',
            ItemCategory= 'Nourritures',
            price= 40,
        },

        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/foiegras.webp',
            label= 'Foie Gras',
            ItemCategory= 'Nourritures',
            price= 40,
        },

        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Bouteille de Champagne',
            ItemCategory= 'Alcool',
            price=200,
        },
    },
}

local CluckinBell_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/header_cluckinbell.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_bucket.webp',
            label= 'Buckets',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_burg.webp',
            label= 'Burger',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_fowl.webp',
            label= 'Volaille à croquer',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_fries.webp',
            label= 'Frites',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_kids.webp',
            label= 'Menu Enfant',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_rings.webp',
            label= 'Onion Rings',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_salad.webp',
            label= 'Salade',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_soup.webp',
            label= 'Soupe',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/cluckinbell/gn_cluckin_cup.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price=10,
        },
    },
}

local BahamaMamas_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/header_bahamamamas.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Bloody_Mary.webp',
            label= 'Bloody Mary',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Blue-Mamas.webp',
            label= 'Blue-Mamas',
            ItemCategory= 'Alcool',
            price=75,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Gin.webp',
            label= 'Gin',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Mojito.webp',
            label= 'Mojito',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Punch.webp',
            label= 'Punch',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/White_Lady.webp',
            label= 'White Lady',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Tapas.webp',
            label= 'Tapas',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Champagne',
            ItemCategory= 'Alcool',
            price=80,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
            price=50,
        },
    },
}

local BayviewLodge_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/header_bayviewlodge.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Applepie.webp',
            label= 'Apple pie',
            ItemCategory= 'Nourritures',
            price=10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Poutine.webp',
            label= 'Poutine',
            ItemCategory= 'Nourritures',
            price=30,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Saucisson.webp',
            label= 'Saucisson',
            ItemCategory= 'Nourritures',
            price=10,
        },
        
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Pancakes.webp',
            label= 'Pancakes',
            ItemCategory= 'Nourritures',
            price= 15,
        },

        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Entrecote.webp',
            label= 'Entrecôte',
            ItemCategory= 'Nourritures',
            price= 30,
        },

        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Oeufsbacon.webp',
            label= 'Oeufs bacon',
            ItemCategory= 'Nourritures',
            price= 30,
        },

        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Mac&cheese.webp',
            label= 'Mac & cheese',
            ItemCategory= 'Nourritures',
            price= 30,
        },

        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=10,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/BayviewBeer.webp',
            label= 'Bayview Beer',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/DuffBeer.webp',
            label= 'Duff Beer',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Blonde.webp',
            label= 'Bière Blonde',
            ItemCategory= 'Alcool',
            price=15,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Hydromel.webp',
            label= 'Hydromel',
            givename= 'Hydromel',
            ItemCategory= 'Alcool',
            price= 20,
        },
    },
}

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
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/chicken_wrap.webp',
            label= 'Wrap Poulet',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/the_simply_burger.webp',
            label= 'Fishburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/the_glorious_burger.webp',
            label= 'Cheeseburger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/double_shot_burger.webp',
            label= 'Double Cheese',
            ItemCategory= 'Nourritures',
            price= 30,
        },
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
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/meteorite_icecream.webp',
            label= 'Glace Meteorite',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/orangotang_icecream.webp',
            label= 'Glace Orangotang',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/goat_cheese_wrap.webp',
            label= 'Wrap Chèvre',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/tacos.webp',
            label= 'Tacos',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/the_fabulous_6lb_burger.webp',
            label= 'Fabulous Burger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/bleeder_burger.webp',
            label= 'Bleeder Burger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/prickly_burger.webp',
            label= 'Prickly Burger',
            ItemCategory= 'Nourritures',
            price= 30,
        },
    },
}

local Skyblue_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/skyblue/header_skyblue.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/caprisun.webp',
            label= 'Capri-seum',
            givename= 'capriseum',
            category= 'Boissons',
            price=25,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Jusdefruits.webp',
            label= 'Limonade',
            givename= 'Limonade',
            category= 'Boissons',
            price=30,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/soda.webp',
            label= 'Soda',
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
    }
}

local domaine_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_vignoble.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/beer.webp',
            label= 'Bière',
            ItemCategory= 'Alcool',
        },
        {
            id= 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jet27.webp',
            label= 'Jet 27',
            ItemCategory= 'Alcool',
        },
        {
            id= 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
        },
        {
            id= 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gin.webp',
            label= 'Gin',
            ItemCategory= 'Alcool',
        },
        {
            id= 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            ItemCategory= 'Alcool',
        },
        {
            id= 6,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tequila.webp',
            label= 'Tequila',
            ItemCategory= 'Alcool',
        },
        {
            id= 7,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Vinblanc.webp',
            label= 'Vin blanc',
            ItemCategory= 'Alcool',
        },
        {
            id= 8,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Vinrouge.webp',
            label= 'Vin rouge',
            ItemCategory= 'Alcool',
        },
        {
            id= 9,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/whisky.webp',
            label= 'Whisky',
            ItemCategory= 'Alcool',
        },
    },
}

local ComradesBar_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/header_comradesbar.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Aperitifs.webp',
            label= 'Apéritifs',
            price= 90,
            ItemCategory= 'Nourritures',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Blonde.webp',
            label= 'Bière Blonde',
            price= 25,
            ItemCategory= 'Alcool',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Camarade.webp',
            label= 'Camarade',
            price= 115,
            ItemCategory= 'Alcool',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Irish_coffee.webp',
            label= 'Irish Coffee',
            price= 150,
            ItemCategory= 'Alcool',
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Jaggerbomb.webp',
            label= 'Jäggerbomb',
            ItemCategory= 'Alcool',
            price= 125,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 13,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/tequila.webp',
            label= 'Tequila',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowrp.webp',
            label= 'Yellow Rose Premium',
            ItemCategory= 'Alcool',
            price= 200,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowro.webp',
            label= 'Yellow Rose Outlaw',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/diabolored.webp',
            label= 'Diabolo',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/eaumineral.webp',
            label= 'Eau Mineral',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 18,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/cacahuetescmrd.webp',
            label= 'Cacahuètes',
            price= 80,
            ItemCategory= 'Nourritures',
        },
        {
            id= 19,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boeufseche.webp',
            label= 'Boeuf Séché',
            price= 80,
            ItemCategory= 'Nourritures',
        },
        {
            id= 20,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cheesestick.webp',
            label= 'Bâtonnet de Fromage',
            price= 80,
            ItemCategory= 'Nourritures',
        },
        {
            id= 21,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/maxiplanche.webp',
            label= 'Maxi Planche',
            price= 90,
            ItemCategory= 'Nourritures',
        },
        {
            id= 22,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fromagesdes.webp',
            label= 'Cubes de Fromage',
            price= 80,
            ItemCategory= 'Nourritures',
        },
        {
            id= 23,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/chipscmrd.webp',
            label= 'Chips',
            price= 80,
            ItemCategory= 'Nourritures',
        },
    },
}

local PopsDiner_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/header_popsdiner.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/911.webp',
            label= '911',
            ItemCategory= 'Alcool',
            price= 15,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Cesar.webp',
            label= 'César',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Hot_dog.webp',
            label= 'Hot Dog',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Mozza_sticks.webp',
            label= 'Mozza Sticks',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Pancakes.webp',
            label= 'Pancakes',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/pizza-7945.webp',
            label= 'Pizza',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Pulled_Pork.webp',
            label= 'Pulled Pork',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Sandwich.webp',
            label= 'Sandwich',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/panini.webp',
            label= 'Panini',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/fritesrex.webp',
            label= 'Frite',
            ItemCategory= 'Nourritures',
            price= 20,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Eggs_muffin.webp',
            label= 'Eggs Muffin',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donuts',
            ItemCategory= 'Nourritures',
            price= 8,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Glace.webp',
            label= 'Glace Vanille',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Waffle.webp',
            label= 'Gaufre',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 18,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Pancakes.webp',
            label= 'Crêpe',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 19,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Granita_upnatom.webp',
            label= 'Granita',
            ItemCategory= 'Boissons',
            price=7,
        },
        {
            id= 20,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Milkshake_Hornys.webp',
            label= 'Milkshake',
            ItemCategory= 'Boissons',
            price=7,
        },
        {
            id= 21,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Coffee_Hornys.webp',
            label= 'Café',
            ItemCategory= 'Boissons',
            price=7,
        },
    },
}

local RexDiner_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_rexdiner.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/911.webp',
            label= '911',
            ItemCategory= 'Alcool',
            price= 15,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Cesar.webp',
            label= 'César',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Hot_dog.webp',
            label= 'Hot Dog',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Mozza_sticks.webp',
            label= 'Mozza Sticks',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Pancakes.webp',
            label= 'Pancakes',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/pizza-7945.webp',
            label= 'Pizza',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Pulled_Pork.webp',
            label= 'Pulled Pork',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Sandwich.webp',
            label= 'Sandwich',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/panini.webp',
            label= 'Panini',
            ItemCategory= 'Nourritures',
            price= 30,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 10,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/fritesrex.webp',
            label= 'Frite',
            ItemCategory= 'Nourritures',
            price= 20,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Eggs_muffin.webp',
            label= 'Eggs Muffin',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donuts',
            ItemCategory= 'Nourritures',
            price= 8,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/Glace.webp',
            label= 'Glace Vanille',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/Waffle.webp',
            label= 'Gaufre',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 18,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/Pancakes.webp',
            label= 'Crêpe',
            ItemCategory= 'Nourritures',
            price= 10,
        },
        {
            id= 19,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Granita_upnatom.webp',
            label= 'Granita',
            ItemCategory= 'Boissons',
            price=7,
        },
        {
            id= 20,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Milkshake_Hornys.webp',
            label= 'Milkshake',
            ItemCategory= 'Boissons',
            price=7,
        },
        {
            id= 21,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Coffee_Hornys.webp',
            label= 'Café',
            ItemCategory= 'Boissons',
            price=7,
        },
        {
            id = 1,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sucette.webp',
            label = 'Sucette',
            price = 30,
            givename = "lollipop",
            ItemCategory= 'Nourritures'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Glace_a_l_italienne.webp',
            label = 'Glace a l\'Italienne',
            price = 35,
            givename = "GlaceItalienne",
            ItemCategory= 'Nourritures'
        },
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Barre_de_cereale.webp',
            label = 'Barre Céréales',
            price = 30,
            givename = "BarreCereale",
            ItemCategory= 'Nourritures'
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Chips.webp',
            label = 'Chips',
            ItemCategory= 'Nourritures',
            price = 35,
            item = "tapas"
        },
        
        {
            id = 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/twinkies.webp',
            label = 'Twinkies',
            price = 40,
            givename = "twinkies",
            ItemCategory= 'Nourritures'
        },
        {
            id = 6,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sandwich_triangle.webp',
            label = 'Sandwich Triangle',
            ItemCategory= 'Nourritures',
            price = 40,
            item = "tapas"
        },
        {
            id = 8,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigarettes.webp',
            label = 'Cigarette',
            ItemCategory= 'Utilitaires',
            price = 35,
            item = "cig"
        }, 
        {
            id = 9,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Ciseaux.webp',
            label = 'Ciseaux',
            ItemCategory= 'Utilitaires',
            price = 225,
            item = "scisor"
        }, 
        --{
        --    id = 1,
        --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/ordinateur.webp',
        --    label = 'Ordinateur',
        --    subCategory = 'CATALOGUE LTD',
        --    item = "laptop"
        --},
        {
            id = 10,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Pince_a_cheveux.webp',
            label = 'Pince à cheveux',
            ItemCategory= 'Utilitaires',
            price = 125,
            item = "pince"
        }, 
        {
            id = 11,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Radio.webp',
            label = 'Radio',
            ItemCategory= 'Utilitaires',
            price = 50,
            item = "radio"
        },
        {
            id = 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Telephone.webp',
            label = 'Téléphone',
            ItemCategory= 'Utilitaires',
            price = 200,
            item = "phone"
        }, 
        {
            id = 13,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boombox.webp',
            label = 'Boombox',
            ItemCategory= 'Utilitaires',
            price = 250,
            item = "boombox"
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/lait_chocolat.webp',
            label= 'Lait Chocolat',
            givename= 'laitchoco',
            ItemCategory= 'Boissons',
            price= 45,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Bouteille_petillante.webp',
            label= 'Eau Pétillante',
            givename= 'eaupetillante',
            ItemCategory= 'Boissons',
            price= 40,
        },

        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Bouteille d\'eau',
            givename= 'water',
            ItemCategory= 'Boissons',
            price= 25,
        },


        {
            id = 17,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/umbrella.webp',
            label = 'Parapluie',
            price = 30,
            givename = "umbrella",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 18,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bloc_note.webp',
            label = 'Bloc-note',
            price = 50,
            givename = "blocnote",
            ItemCategory= 'Utilitaires'
        },
        {
            id = 19,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jumelle.webp',
            label = 'Jumelle',
            price = 750,
            givename = "jumelle",
            ItemCategory= 'Utilitaires'
        },
        {
            id = 20,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fishroad.webp',
            label = 'Canne Pêche',
            price = 220,
            givename = "fishroad",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 21,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cigar.webp',
            label = 'Cigar',
            price = 40,
            givename = "cigar",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 22,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gadget_parachute.webp',
            label = 'Parachute',
            price = 700,
            givename = "gadget_parachute",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 23,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cleaner.webp',
            label = 'Produit nettoyant',
            price = 200,
            givename = "cleaner",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 24,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/sactete.webp',
            label = 'Sacs',
            price = 900,
            givename = "sactete",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 25,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp',
            label = 'GPS',
            price = 200,
            givename = "gps",
            ItemCategory= 'Utilitaires'
        },
        
        {
            id = 26,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/malettecuir.webp',
            label = 'Malette en Cuir',
            price = 800,
            givename = "malettecuir",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 27,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/can.webp',
            label = 'Canette Vide',
            price = 30,
            givename = "can",
            ItemCategory= 'Utilitaires'
        },
    },
}

local YellowJack_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/header_yellowjack.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Aperitifs.webp',
            label= 'Apéritifs',
            ItemCategory= 'Nourritures',
            price= 110,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Blonde.webp',
            label= 'Bière Blonde',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Brune.webp',
            label= 'Bière Brune',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Rousse.webp',
            label= 'Bière Rousse',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Ambree.webp',
            label= 'Bière Ambrée',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Pisse_d_ane.webp',
            label= 'Pisse d\'Âne',
            ItemCategory= 'Alcool',
            price= 120,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Shamrock.webp',
            label= 'Shamrock',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/RhumCoke.webp',
            label= 'Rhum Coke',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/yellowjack/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowrp.webp',
            label= 'Yellow Rose Premium',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/yellowro.webp',
            label= 'Yellow Rose Outlaw',
            ItemCategory= 'Alcool',
            price= 150,
        },
        {
            id = 14,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cigar.webp',
            label = 'Cigar',
            price = 10,
            givename = "cigar",
            ItemCategory= 'Utilitaires'
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/beanmachine/donutn.webp',
            label= 'Donut',
            ItemCategory= 'Nourritures',
            price= 100,
        },
        {
            id= 18,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Frites_Hornys.webp',
            label= 'Frites',
            ItemCategory= 'Nourritures',
            price= 160,
        },
        {
            id= 19,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/popsdiner/Mozza_sticks.webp',
            label= 'Mozza Sticks',
            ItemCategory= 'Nourritures',
            price= 160,
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
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sucette.webp',
            label = 'Sucette',
            price = 5,
            givename = "lollipop",
            ItemCategory = 'Nourritures'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Glace_a_l_italienne.webp',
            label = 'Glace a l\'Italienne',
            price = 5,
            givename = "GlaceItalienne",
            ItemCategory = 'Nourritures'
        },
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Barre_de_cereale.webp',
            label = 'Barre Céréales',
            price = 5,
            givename = "BarreCereale",
            ItemCategory = 'Nourritures'
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Chips.webp',
            label = 'Chips',
            ItemCategory= 'Nourritures',
            price = 10,
            item = "tapas"
        },
        {
            id = 5,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sandwich_triangle.webp',
            label = 'Sandwich Triangle',
            ItemCategory= 'Nourritures',
            price = 10,
            item = "tapas"
        },
        {
            id = 6,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigarettes.webp',
            label = 'Cigarette',
            ItemCategory= 'Utilitaires',
            price = 10,
            item = "cig"
        }, 
        {
            id = 7,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Ciseaux.webp',
            label = 'Ciseaux',
            ItemCategory= 'Utilitaires',
            price = 50,
            item = "scisor"
        }, 
        {
            id = 27,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/ticket.webp',
            label = 'Ticket à gratter',
            ItemCategory= 'Utilitaires',
            price = 50,
            item = "ticket"
        }, 
        --{
        --    id = 1,
        --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/ordinateur.webp',
        --    label = 'Ordinateur',
        --    subCategory = 'CATALOGUE LTD',
        --    item = "laptop"
        --},
        {
            id = 8,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Pince_a_cheveux.webp',
            label = 'Pince à cheveux',
            ItemCategory= 'Utilitaires',
            price = 30,
            item = "pince"
        }, 
       {
            id = 9,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Radio.webp',
            label = 'Radio',
            ItemCategory= 'Utilitaires',
            price = 50,
            item = "radio"
        },
        {
            id = 10,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Recycleur.webp',
            label = 'Recycleur',
            ItemCategory= 'Utilitaires',
            price = 700,
            item = "recycleur"
        }, 
        {
            id = 11,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Telephone.webp',
            label = 'Téléphone',
            ItemCategory= 'Utilitaires',
            price = 50,
            item = "phone"
        }, 
        {
            id = 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boombox.webp',
            label = 'Boombox',
            ItemCategory= 'Utilitaires',
            price = 75,
            item = "boombox"
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/lait_chocolat.webp',
            label= 'Lait Chocolat',
            givename= 'laitchoco',
            ItemCategory= 'Boissons',
            price= 5,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Bouteille_petillante.webp',
            label= 'Eau Pétillante',
            givename= 'eaupetillante',
            ItemCategory= 'Boissons',
            price= 5,
        },

        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Bouteille d\'eau',
            givename= 'water',
            ItemCategory= 'Boissons',
            price= 5,
        },


        {
            id = 16,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/umbrella.webp',
            label = 'Parapluie',
            price = 30,
            givename = "umbrella",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 17,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bloc_note.webp',
            label = 'Bloc-note',
            price = 10,
            givename = "blocnote",
            ItemCategory= 'Utilitaires'
        },
        {
            id = 18,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jumelle.webp',
            label = 'Jumelle',
            price = 200,
            givename = "jumelle",
            ItemCategory= 'Utilitaires'
        },
        {
            id = 19,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fishroad.webp',
            label = 'Canne Pêche',
            price = 50,
            givename = "fishroad",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 20,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cigar.webp',
            label = 'Cigar',
            price = 10,
            givename = "cigar",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 21,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gadget_parachute.webp',
            label = 'Parachute',
            price = 700,
            givename = "gadget_parachute",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 22,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cleaner.webp',
            label = 'Cleaner',
            price = 50,
            givename = "cleaner",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 23,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/sactete.webp',
            label = 'Sacs',
            price = 250,
            givename = "sactete",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 24,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp',
            label = 'GPS',
            price = 50,
            givename = "gps",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 25,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/malettecuir.webp',
            label = 'Malette en Cuir',
            price = 300,
            givename = "malettecuir",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 26,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/can.webp',
            label = 'Canette Vide',
            price = 10,
            givename = "can",
            ItemCategory= 'Utilitaires'
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
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sucette.webp',
            label = 'Sucette',
            price = 30,
            givename = "lollipop",
            ItemCategory= 'Nourritures'
        },
        {
            id = 2,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Glace_a_l_italienne.webp',
            label = 'Glace a l\'Italienne',
            price = 35,
            givename = "GlaceItalienne",
            ItemCategory= 'Nourritures'
        },
        {
            id = 3,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Barre_de_cereale.webp',
            label = 'Barre Céréales',
            price = 30,
            givename = "BarreCereale",
            ItemCategory= 'Nourritures'
        },
        {
            id = 4,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Chips.webp',
            label = 'Chips',
            ItemCategory= 'Nourritures',
            price = 35,
            item = "tapas"
        },
        
        {
            id = 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/twinkies.webp',
            label = 'Twinkies',
            price = 40,
            givename = "twinkies",
            ItemCategory= 'Nourritures'
        },
        {
            id = 6,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Sandwich_triangle.webp',
            label = 'Sandwich Triangle',
            ItemCategory= 'Nourritures',
            price = 40,
            item = "tapas"
        },
        {
            id = 8,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/cigarettes.webp',
            label = 'Cigarette',
            ItemCategory= 'Utilitaires',
            price = 35,
            item = "cig"
        }, 
        {
            id = 9,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Ciseaux.webp',
            label = 'Ciseaux',
            ItemCategory= 'Utilitaires',
            price = 225,
            item = "scisor"
        }, 
        --{
        --    id = 1,
        --    image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/ordinateur.webp',
        --    label = 'Ordinateur',
        --    subCategory = 'CATALOGUE LTD',
        --    item = "laptop"
        --},
        {
            id = 10,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Pince_a_cheveux.webp',
            label = 'Pince à cheveux',
            ItemCategory= 'Utilitaires',
            price = 125,
            item = "pince"
        }, 
        {
            id = 11,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Radio.webp',
            label = 'Radio',
            ItemCategory= 'Utilitaires',
            price = 50,
            item = "radio"
        },
--[[         {
            id = 10,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Recycleur.webp',
            label = 'Recycleur',
            ItemCategory= 'Utilitaires',
            price = 700,
            item = "recycleur"
        },  ]]
        {
            id = 12,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/LTD/Telephone.webp',
            label = 'Téléphone',
            ItemCategory= 'Utilitaires',
            price = 200,
            item = "phone"
        }, 
        {
            id = 13,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/boombox.webp',
            label = 'Boombox',
            ItemCategory= 'Utilitaires',
            price = 250,
            item = "boombox"
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/lait_chocolat.webp',
            label= 'Lait Chocolat',
            givename= 'laitchoco',
            ItemCategory= 'Boissons',
            price= 45,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/Bouteille_petillante.webp',
            label= 'Eau Pétillante',
            givename= 'eaupetillante',
            ItemCategory= 'Boissons',
            price= 40,
        },

        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Bouteille d\'eau',
            givename= 'water',
            ItemCategory= 'Boissons',
            price= 25,
        },


        {
            id = 17,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/umbrella.webp',
            label = 'Parapluie',
            price = 30,
            givename = "umbrella",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 18,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bloc_note.webp',
            label = 'Bloc-note',
            price = 50,
            givename = "blocnote",
            ItemCategory= 'Utilitaires'
        },
        {
            id = 19,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/jumelle.webp',
            label = 'Jumelle',
            price = 750,
            givename = "jumelle",
            ItemCategory= 'Utilitaires'
        },
        {
            id = 20,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/fishroad.webp',
            label = 'Canne Pêche',
            price = 220,
            givename = "fishroad",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 21,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cigar.webp',
            label = 'Cigar',
            price = 40,
            givename = "cigar",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 22,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gadget_parachute.webp',
            label = 'Parachute',
            price = 700,
            givename = "gadget_parachute",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 23,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/cleaner.webp',
            label = 'Produit nettoyant',
            price = 200,
            givename = "cleaner",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 24,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/sactete.webp',
            label = 'Sacs',
            price = 900,
            givename = "sactete",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 25,
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/gps.webp',
            label = 'GPS',
            price = 200,
            givename = "gps",
            ItemCategory= 'Utilitaires'
        },
        
        {
            id = 26,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/malettecuir.webp',
            label = 'Malette en Cuir',
            price = 800,
            givename = "malettecuir",
            ItemCategory= 'Utilitaires'
        },

        {
            id = 27,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/can.webp',
            label = 'Canette Vide',
            price = 30,
            givename = "can",
            ItemCategory= 'Utilitaires'
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
            ItemCategory= 'Nourritures',
            price= 100,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzamarghe.webp',
            label= 'Pizza Margherita',
            ItemCategory= 'Nourritures',
            price= 120,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizza4fromage.webp',
            label= 'Pizza 4 fromages',
            ItemCategory= 'Nourritures',
            price= 120,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzachevre.webp',
            label= 'Pizza Chèvre Miel',
            ItemCategory= 'Nourritures',
            price= 120,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/crostini.webp',
            label= 'Crostini',
            ItemCategory= 'Nourritures',
            price= 110,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/tiramisu.webp',
            label= 'Tiramisu',
            ItemCategory= 'Nourritures',
            price= 90,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/saladeburata.webp',
            label= 'Salade Burata',
            ItemCategory= 'Nourritures',
            price= 110,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/pizzanutella.webp',
            label= 'Pizza Nutella',
            ItemCategory= 'Nourritures',
            price= 110,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pizzeria/saladedefruit.webp',
            label= 'Salade de fruits',
            ItemCategory= 'Nourritures',
            price= 90,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/ltd/bouteille_eau.webp',
            label= 'Eau',
            ItemCategory= 'Boissons',
            price=90,
        },
        {
            id=11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'Sprunk',
            ItemCategory= 'Boissons',
            price=90,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/burgershot/soda.webp',
            label= 'E-cola',
            ItemCategory= 'Boissons',
            price=90,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
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
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/punch_planteur.webp',
            label= 'Punch Planteur',
            ItemCategory= 'Alcool',
            price=130,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/punch_coco.webp',
            label= 'Punch Coco',
            ItemCategory= 'Alcool',
            price=45,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/rhum_agricole.webp',
            label= 'Rhum Agricole',
            ItemCategory= 'Alcool',
            price=245,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/royalsoda_grenadine.webp',
            label= 'RoyalSoda Grenadine',
            ItemCategory= 'Boissons',
            price= 75,
        },
        {
            id= 88,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/unicorn/Limonade.webp',
            label= 'Limonade',
            ItemCategory= 'Boissons',
            price=90,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/royalsoda_annanas.webp',
            label= 'RoyalSoda Annanas',
            ItemCategory= 'Boissons',
            price= 75,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/accras_crevettes.webp',
            label= 'Accras Crevettes',
            ItemCategory= 'Nourritures',
            price= 90,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bananes_plantains.webp',
            label= 'Bananes Plantains',
            ItemCategory= 'Nourritures',
            price= 90,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/samoussa.webp',
            label= 'Samoussa',
            ItemCategory= 'Nourritures',
            price= 90,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/rougaille_saucisse.webp',
            label= 'Rougaille Saucisse',
            ItemCategory= 'Nourritures',
            price= 130,
        },
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/colombo_poulet.webp',
            label= 'Colombo Poulet',
            ItemCategory= 'Nourritures',
            price= 130,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bokit_bocane.webp',
            label= 'Bokit Bocane',
            ItemCategory= 'Nourritures',
            price= 120,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bokit_poulet.webp',
            label= 'Bokit Poulet',
            ItemCategory= 'Nourritures',
            price= 120,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/bokit_morue.webp',
            label= 'Bokit Morue',
            ItemCategory= 'Nourritures',
            price= 120,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/salade_antillaise.webp',
            label= 'Salade Antillaise',
            ItemCategory= 'Nourritures',
            price= 100,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/glace_mangue.webp',
            label= 'Glace Mangue',
            ItemCategory= 'Nourritures',
            price= 100,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/pearl/glace_coco.webp',
            label= 'Glace Coco',
            ItemCategory= 'Nourritures',
            price= 100,
        },
    }
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
            ItemCategory= 'Nourritures',
            price= 100,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Batonspoulet_Hornys.webp',
            label= 'Batons de Poulet',
            ItemCategory= 'Nourritures',
            price= 90,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Burgerpoulet_Hornys.webp',
            label= 'Burger Poulet',
            ItemCategory= 'Nourritures',
            price= 140,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Wrappoulet_Hornys.webp',
            label= 'Wrap Poulet',
            ItemCategory= 'Nourritures',
            price= 140,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Pignonpoulet_Hornys.webp',
            label= 'Pignon de Poulet',
            ItemCategory= 'Nourritures',
            price= 140,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Donut_Hornys.webp',
            label= 'Donut',
            ItemCategory= 'Nourritures',
            price= 80,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Milkshake_Hornys.webp',
            label= 'Milkshake',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Coffee_Hornys.webp',
            label= 'Café',
            ItemCategory= 'Boissons',
            price= 90,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/hornys/Soda_Hornys.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 90,
        },
    }
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
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Onion_rings.webp',
            label= 'Onion Rings',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Eggs_muffin.webp',
            label= 'Eggs Muffin',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Black_burger.webp',
            label= 'Black Burger',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Burger_Uranus.webp',
            label= 'Saturne Burger',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Burger_earth.webp',
            label= 'Earth Burger',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Cup_space.webp',
            label= 'Cup Space',
            ItemCategory= 'Nourritures',
            price= 15,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Granita_upnatom.webp',
            label= 'Granita',
            ItemCategory= 'Boissons',
            price= 15,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/upnatom/Ice_cup.webp',
            label= 'Ice Cup',
            ItemCategory= 'Boissons',
            price= 15,
        },
    }
}

local bennys_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_bennys.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
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
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}

local ocean_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_ocean.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/cleankit.webp',
            label= 'Kit de nettoyage',
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}

local cayogarage_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_bennys.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
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
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}

local sunshine_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_sunshine.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
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
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}


local harmony_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_harmonyrepair.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
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
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}

local hayes_toSend = {
    headerImage = 'https://media.discordapp.net/attachments/1142829822821797929/1146736570037194752/Ban_Hayes_Final.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
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
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}

local beekers_toSend = {
    headerImage = 'https://media.discordapp.net/attachments/1142829822821797929/1146736522419249223/Ban_Beekers_Final.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/weapon_petrolcan.webp',
            label= 'Bidon d\'essence',
            price= 100,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/spray.webp',
            label= 'Bombe de peinture',
            price= 25,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/repairkit.webp',
            label= 'Kit de réparation',
            price= 500,
            ItemCategory= 'Utilitaires',
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
            price= 30,
            ItemCategory= 'Utilitaires',
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Bennys/PostOP/sangle.webp',
            label= 'Sangle',
            price= 300,
            ItemCategory= 'Utilitaires',
        },
    },
}

local vClub_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_vclub.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Tapas.webp',
            label= 'Tapas',
            givename= 'Tapas',
            category= 'Nourritures',
            price= 10,
        },

        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price= 20,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 20,
        },

        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/BayviewBeer.webp',
            label= 'Bière',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Jaggerbomb.webp',
            label= 'Jagger',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Champagne',
            ItemCategory= 'Alcool',
            price= 500,
        },
    },
}

local club77_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_club77.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    hoverStyle = 'fill-black stroke-black',
    elements = {
        {
            id= 1,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Tapas.webp',
            label= 'Tapas',
            givename= 'Tapas',
            category= 'Nourritures',
            price= 10,
        },

        {
            id= 2,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Jus_de_fruits.webp',
            label= 'Jus de fruits',
            ItemCategory= 'Boissons',
            price= 20,
        },
        {
            id= 3,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bahamas/Soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 20,
        },

        {
            id= 4,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/bayviewlodge/BayviewBeer.webp',
            label= 'Bière',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 5,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Jaggerbomb.webp',
            label= 'Jagger',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 6,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/rhum.webp',
            label= 'Rhum',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 7,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Vodka.webp',
            label= 'Vodka',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 8,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/comrades/Whisky.webp',
            label= 'Whisky',
            ItemCategory= 'Alcool',
            price= 100,
        },
        {
            id= 9,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/lemiroir/BouteilleChampagne.webp',
            label= 'Champagne',
            ItemCategory= 'Alcool',
            price= 500,
        },
    },
}

local Tacos2Rancho_toSend = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/header_tacosrancho.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'CATALOGUE',
    elements = {
        {
            id= 10,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/fajitas.webp',
            label= 'Fajitas',
            ItemCategory= 'Nourritures',
            price= 130,
        },
        {
            id= 11,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/burrito.webp',
            label= 'Burritos',
            ItemCategory= 'Nourritures',
            price= 130,
        },
        {
            id= 12,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/quesadillas.webp',
            label= 'Quessadillas',
            ItemCategory= 'Nourritures',
            price= 150,
        },
        {
            id= 13,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/tacos.webp',
            label= 'Tacos',
            ItemCategory= 'Nourritures',
            price= 140,
        },
        {
            id= 14,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/jus_de_fruits.webp',
            label= 'Jus',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 15,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/soda.webp',
            label= 'Soda',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 16,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/laitchoco.webp',
            label= 'Lait',
            ItemCategory= 'Boissons',
            price= 100,
        },
        {
            id= 17,
            image= 'https://cdn.sacul.cloud/v2/vision-cdn/Restaurant/tacosrancho/caprisun.webp',
            label= 'Capri-Sun',
            ItemCategory= 'Boissons',
            price= 100,
        },
    },
}


zone.addZone(
    "catalogue_UwUcafe",
    vector3(-585.73931884766, -1066.1652832031, 21.344192504883),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('UwUcafe')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_BeanMachine1",
    vector3(-633.28057861328, 236.22430419922, 80.881652832031),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('BeanMachine')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_don",
    vector3(2542.1767578125, 2636.7524414063, 37.945446014404),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('don')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_LeMiroir",
    vector3(1116.68, -641.5269, 56.817),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('LeMiroir')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_Unicorn",
    vector3(118.72952270508, -1281.2736816406, 28.618839263916),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('Unicorn')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_RoyalHotel1",
    vector3(411.57034301758, 7.0044279098511, 91.935348510742),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('RoyalHotel')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_RoyalHotel2",
    vector3(415.58303833008, 10.623682975769, 91.935348510742),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('RoyalHotel')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_BayviewLodge",
    vector3(-689.65716552734, 5796.2998046875, 17.331018447876),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('BayviewLodge')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_RexDiner",
    vector3(2542.7292480469, 2588.017578125, 38.497470855713),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('rexdiner')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_Comrades",
    vector3(-1587.8231201172, -996.45562744141, 13.075222969055),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('Comrades')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_Pops",
    vector3(1588.6284179688, 6455.5844726563, 26.0140209198),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('PopsDiner')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_YellowJack",
    vector3(1985.2114257813, 3050.6540527344, 47.215091705322),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('YellowJack')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_Bahamas1",
    vector3(-1403.4389648438, -603.44555664063, 30.319976806641),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('Bahamas')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_Bahamas2",
    vector3(-1378.2464599609, -602.97540283203, 29.217601776123),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('Bahamas')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_CluckinBell",
    vector3(-147.96556091309, -262.91122436523, 43.59912109375),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('CluckinBell')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_domaine",
    vector3(-1877.85546875, 2063.8474121094, 134.91502380371),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('domaine')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_blackwood",
    vector3(-305.09658813477, 6265.2685546875, 30.526918411255),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('blackwood')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_pizzeria",
    vector3(810.19549560547, -751.40350341797, 26.78084564209),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('pizzeria')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_pearl",
    vector3(-1838.0902099609, -1197.8659667969, 13.309239387512),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('pearl')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_hornys",
    vector3(1146.49, -60.01, 30.2),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('hornys')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 3.0, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_upnatom",
    vector3(88.720268249512, 287.28649902344, 110.20943450928),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('upnatom')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_BurgerShot1",
    vector3(1244.3304443359, -364.04815673828, 69.207473754883),
    "Appuyer sur ~INPUT_CONTEXT~ pour accéder au catalogue",
    function()
        OpenCatalogue('BurgerShot')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_BurgerShot2",
    vector3(1248.4367675781, -357.15692138672, 69.21354675293),
    "Appuyer sur ~INPUT_CONTEXT~ pour accéder au catalogue",
    function()
        OpenCatalogue('BurgerShot')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_BurgerShot3",
    vector3(1241.7349853516, -359.04888916016, 69.206130981445),
    "Appuyer sur ~INPUT_CONTEXT~ pour accéder au catalogue",
    function()
        OpenCatalogue('BurgerShot')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_TacosRancho1",
    vector3(417.93206787109, -1913.4464111328, 25.471214294434),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('tacosrancho')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_TacosRancho2",
    vector3(416.1467590332, -1915.3057861328, 25.471214294434),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('tacosrancho')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_vclub",
    vector3(-18.11509513855, 275.07095336914, 94.952438354492),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('vclub')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

zone.addZone(
    "catalogue_club77",
    vector3(249.07, -3163.57, -1.19),
    "~INPUT_CONTEXT~ Catalogue",
    function()
        OpenCatalogue('club77')
    end,
    false,
    36, 0.5, { 255, 0, 0 }, 255, 1.5, true, "bulleCatalogue"
)

function OpenCatalogue(catChoice)
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
    elseif catChoice == 'rexdiner' then
        toSend = RexDiner_toSend
    elseif catChoice == 'BurgerShot' then
        toSend = BurgerShot_toSend
	elseif catChoice == 'Skyblue' then
        toSend = Skyblue_toSend
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
    elseif catChoice == 'domaine' then
        toSend = domaine_toSend
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
    elseif catChoice == 'sunshine' then
        toSend = sunshine_toSend
    elseif catChoice == 'harmony' then
        toSend = harmony_toSend
    elseif catChoice == 'beekers' then
        toSend = beekers_toSend
    elseif catChoice == 'hayes' then
        toSend = hayes_toSend
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

function GetCatalogueItems(job)
    local toSend;
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
	elseif job == 'rexdiner' then
        toSend = RexDiner_toSend
	elseif job == 'burgershot' then
        toSend = BurgerShot_toSend
    elseif job == 'skyblue' then
        toSend = Skyblue_toSend
    elseif job == 'yellowjack' then
        toSend = YellowJack_toSend
    elseif job == 'bayviewLodge' then
        toSend = BayviewLodge_toSend
    elseif job == 'pizzeria' then
        toSend = Pizzeria_toSend
    elseif job == 'pearl' then
        toSend = Pearl_toSend
    elseif job == 'upnatom' then
        toSend = Upnatom_toSend
    elseif job == 'hornys' then
        toSend = Hornys_toSend
    elseif job == 'bahamas' then
        toSend = BahamaMamas_toSend
    elseif job == 'vclub' then
        toSend = vClub_toSend
    elseif job == 'club77' then
        toSend = club77_toSend
    elseif job == 'comrades' then
        toSend = ComradesBar_toSend
    elseif job == "domaine" then 
        toSend = domaine_toSend
    elseif job == "ltdsud" then 
        toSend = LTD_toSend
    elseif job == "ltdseoul" then 
        toSend = LTD_toSend
    elseif job == "ltdmirror" then 
        toSend = LTD_toSend
    elseif job == "don" then 
        toSend = Dons_toSend
    elseif job == "blackwood" then 
        toSend = blackwood_toSend
    elseif job == 'bennys' then
        toSend = bennys_toSend
    elseif job == 'cayogarage' then
        toSend = cayogarage_toSend
    elseif job == 'ocean' then
        toSend = ocean_toSend
    elseif job == 'sunshine' then
        toSend = sunshine_toSend
    elseif job == 'harmony' then
        toSend = harmony_toSend
    elseif job == 'beekers' then
        toSend = beekers_toSend
    elseif job == 'hayes' then
        toSend = hayes_toSend
    elseif job == 'tacosrancho' then
        toSend = Tacos2Rancho_toSend
    elseif job == 'cardealerSud' then
        toSend = FormulateConcessPostOp('cardealerSud')
    elseif job == 'cardealerNord' then
        toSend = FormulateConcessPostOp('cardealerNord')
    elseif job == 'heliwave' then
        toSend = FormulateConcessPostOp('heliwave')
    end

    return toSend
end

function FormulateConcessPostOp(job)
    local toSend = {
        elements = {}
    }
    if job == "cardealerSud" then 
        for k, v in pairs(concessSud.vehicle) do
            for j,x in pairs(concessSud.vehicle[k]) do
                table.insert(toSend.elements, {
                    id = j,
                    image = "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..x.name..".webp",
                    label = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(x.name))) ~= "NULL" and GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(x.name))) or firstToUpper(x.name),
                    price = x.price,
                })
            end
        end
    elseif job == "cardealerNord" then 
        for k, v in pairs(concessNord.vehicle) do
            for j,x in pairs(concessNord.vehicle[k]) do
                table.insert(toSend.elements, {
                    id = j,
                    image = "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..x.name..".webp",
                    label = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(x.name))) ~= "NULL" and GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(x.name))) or firstToUpper(x.name),
                    price = x.price,
                })
            end
        end
    elseif job == "heliwave" then 
        print("job heliwave")
        print(heliwave.vehicle)
        for k, v in pairs(heliwave.vehicle) do
            for j,x in pairs(heliwave.vehicle[k]) do
                table.insert(toSend.elements, {
                    id = j,
                    image = x.kind == 1 and "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Bateau/"..x.name..".webp" or "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Aerien/"..x.name..".webp",
                    label = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(x.name))) ~= "NULL" and GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(x.name))) or firstToUpper(x.name),
                    price = x.price,
                })
            end
        end
    end

    return toSend
end