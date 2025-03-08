export const events = [
    {
        action: '__atoshi::createNotification',
        data: {
            type: 'DANGER',
            duration: 5, // in seconds
            content: 'Touche ~K B',
            icon: `<path
        d="M9.50677 3.28355C8.68741 2.51634 7.62408 2.09578 6.49602 2.09677C4.46587 2.09856 2.71323 3.49055 2.22932 5.42147C2.19409 5.56203 2.06886 5.66129 1.92395 5.66129H0.422054C0.225534 5.66129 0.0762439 5.48288 0.112597 5.28974C0.679695 2.27825 3.32373 0 6.5 0C8.24158 0 9.82315 0.685016 10.9901 1.80021L11.9262 0.864133C12.3225 0.467869 13 0.748522 13 1.30894V4.82258C13 5.16999 12.7184 5.45161 12.371 5.45161H8.85732C8.29691 5.45161 8.01626 4.77407 8.41252 4.37778L9.50677 3.28355ZM0.629032 7.54839H4.14268C4.70309 7.54839 4.98374 8.22593 4.58748 8.62222L3.49323 9.71648C4.31259 10.4837 5.376 10.9043 6.50409 10.9033C8.53319 10.9014 10.2865 9.51036 10.7707 7.57858C10.8059 7.43802 10.9311 7.33876 11.0761 7.33876H12.578C12.7745 7.33876 12.9238 7.51717 12.8874 7.71031C12.3203 10.7218 9.67627 13 6.5 13C4.75842 13 3.17685 12.315 2.00989 11.1998L1.07381 12.1359C0.677546 12.5321 0 12.2515 0 11.6911V8.17742C0 7.83001 0.281623 7.54839 0.629032 7.54839Z"
        fill="white"
      />`,
        },
    },
    {
        action: '__atoshi::createNotification',
        data: {
            type: 'POLICE',
            content: 'BRAQUAGE DE SUPERETTE',
            name: 'BRYAN ANDERSON',
            adress: 'ROCKFORD DRIVE AVENUE',
            duration: 40,
            distance: 4245
        },
    },
    {
        action: '__atoshi::createNotification',
        data: {
            type: 'JOB',
            name: "Ammunation",
            logo: "src/assets/example.png",
            phone: "4321",
            content: "Ammunation test notification bla bla bla plus d'espace",
            typeannonce: "INFORMATION",
            duration: 30,

        },
    },
    {
        action: '__atoshi::createNotification',
        data: {
            type: 'ROUGE',
            duration: 5, // in seconds
            content: 'Touche ~K B',
            icon: `<svg xmlns="http://www.w3.org/2000/svg" width="74" height="45" viewBox="0 0 74 45" fill="none">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M58.3566 23.3695C56.3852 27.5737 48.4536 32.6673 36.7717 32.6673C25.1631 32.6673 16.906 27.6379 15.1684 23.4383C6.39777 23.8325 0.09375 29.0775 0.09375 32.1951C0.09375 37.3667 16.5117 44.7023 36.7717 44.7023C57.0271 44.7023 73.4496 37.3667 73.4496 32.1951C73.4496 29.0362 67.1456 25.0108 58.3566 23.3695Z" fill="white"/>
        <path fill-rule="evenodd" clip-rule="evenodd" d="M46.2964 0.381683C43.9307 0.381683 39.0434 2.00468 36.829 2.00468C34.6145 2.00468 29.7272 0.381683 27.366 0.381683C22.2586 0.381683 19.0677 6.67195 18.6229 9.07894L18.5312 20.2061C21.1079 22.526 25.9173 25.4419 31.1897 25.882C33.0236 26.0333 34.9584 26.125 36.9711 26.125C38.9746 26.125 40.9048 26.0333 42.7433 25.882C48.0157 25.4373 52.252 22.8836 54.9754 20.284L54.9524 9.22106C54.5582 6.7178 51.358 0.381683 46.2964 0.381683Z" fill="white"/>
        </svg>`,
        },
    },
    {
        action: '__atoshi::createNotification',
        data: {
            type: 'WARN',
            duration: 50, // in seconds
            content: 'Touche ~K SPACE',
            icon: `<path
        d="M9.50677 3.28355C8.68741 2.51634 7.62408 2.09578 6.49602 2.09677C4.46587 2.09856 2.71323 3.49055 2.22932 5.42147C2.19409 5.56203 2.06886 5.66129 1.92395 5.66129H0.422054C0.225534 5.66129 0.0762439 5.48288 0.112597 5.28974C0.679695 2.27825 3.32373 0 6.5 0C8.24158 0 9.82315 0.685016 10.9901 1.80021L11.9262 0.864133C12.3225 0.467869 13 0.748522 13 1.30894V4.82258C13 5.16999 12.7184 5.45161 12.371 5.45161H8.85732C8.29691 5.45161 8.01626 4.77407 8.41252 4.37778L9.50677 3.28355ZM0.629032 7.54839H4.14268C4.70309 7.54839 4.98374 8.22593 4.58748 8.62222L3.49323 9.71648C4.31259 10.4837 5.376 10.9043 6.50409 10.9033C8.53319 10.9014 10.2865 9.51036 10.7707 7.57858C10.8059 7.43802 10.9311 7.33876 11.0761 7.33876H12.578C12.7745 7.33876 12.9238 7.51717 12.8874 7.71031C12.3203 10.7218 9.67627 13 6.5 13C4.75842 13 3.17685 12.315 2.00989 11.1998L1.07381 12.1359C0.677546 12.5321 0 12.2515 0 11.6911V8.17742C0 7.83001 0.281623 7.54839 0.629032 7.54839Z"
        fill="white"
      />`,
        },
    },
    {
        action: '__atoshi::createNotification',
        data: {
            type: 'HAPPY',
            duration: 50, // in seconds
            content: 'Touche ~K SPACE et ~sCouleur',
            icon: `<path
        d="M9.50677 3.28355C8.68741 2.51634 7.62408 2.09578 6.49602 2.09677C4.46587 2.09856 2.71323 3.49055 2.22932 5.42147C2.19409 5.56203 2.06886 5.66129 1.92395 5.66129H0.422054C0.225534 5.66129 0.0762439 5.48288 0.112597 5.28974C0.679695 2.27825 3.32373 0 6.5 0C8.24158 0 9.82315 0.685016 10.9901 1.80021L11.9262 0.864133C12.3225 0.467869 13 0.748522 13 1.30894V4.82258C13 5.16999 12.7184 5.45161 12.371 5.45161H8.85732C8.29691 5.45161 8.01626 4.77407 8.41252 4.37778L9.50677 3.28355ZM0.629032 7.54839H4.14268C4.70309 7.54839 4.98374 8.22593 4.58748 8.62222L3.49323 9.71648C4.31259 10.4837 5.376 10.9043 6.50409 10.9033C8.53319 10.9014 10.2865 9.51036 10.7707 7.57858C10.8059 7.43802 10.9311 7.33876 11.0761 7.33876H12.578C12.7745 7.33876 12.9238 7.51717 12.8874 7.71031C12.3203 10.7218 9.67627 13 6.5 13C4.75842 13 3.17685 12.315 2.00989 11.1998L1.07381 12.1359C0.677546 12.5321 0 12.2515 0 11.6911V8.17742C0 7.83001 0.281623 7.54839 0.629032 7.54839Z"
        fill="white"
      />`,
        },
    },
]

export const Notifications = [
    {
        type: 'ROUGE',
        color: 'linear-gradient(180deg, #FF0000 0%, #FF0000 100%)',
    },
    {
        type: 'VERT',
        color: 'linear-gradient(180deg, #38DC66 0%, #33963C 100%)',
    },
    {
        type: 'JAUNE',
        color: 'linear-gradient(180deg, #FBD604 0%, #FBCB04 100%)',
    },
    {
        type: 'BLEU',
        color: 'linear-gradient(180deg, #2FF5E4 0%, #44C7F0 100%)',
    },
    {
        type: 'VIOLET',
        color: 'linear-gradient(180deg, #9D49EA 0%, #872ADB 100%)',
    },
    {
        type: 'BLANC',
        color: 'linear-gradient(180deg, #fff 0%, #fff 100%)',
    },
    {
        type: 'CLOCHE',
        color: 'linear-gradient(180deg, #2FF5E4 0%, #44C7F0 100%)',
    },
    {
        type: 'DOLLAR',
        color: 'linear-gradient(180deg, #FBD604 0%, #FBCB04 100%)',
    },
    {
        type: 'SYNC',
        color: 'linear-gradient(180deg, #38DC66 0%, #33963C 100%)',
    },
    {
        type: 'BURGER',
        color: 'linear-gradient(180deg, #38DC66 0%, #33963C 100%)',
    },
    {
        type: 'RMIC',
        color: 'linear-gradient(180deg, #FF0000 0%, #FF0000 100%)',
    },
    {
        type: 'VMIC',
        color: 'linear-gradient(180deg, #38DC66 0%, #33963C 100%)',
    }

]

export const getTextColor = (type: string) => {
    return Notifications.find((_noti) => _noti.type === type)?.color
}

export const parseNotificationContentKeys = (content: string) => {
    if (!content) return content
    const REG = /~K\s*(\w+)/g
    const matchedArray = content.match(REG)

    if (!matchedArray) return content

    for (const matchedKey of matchedArray) {
        content = content.replace(
            REG,
            `<span class="special-key">${matchedKey}</span>`,
        )
        content = content.replace('~K', '')
    }

    return content
}

export const parseNotificationContentColors = (content: string, type: string) => {
    const REG = /~[sc]/g
    const matchedArray = content?.match(REG)
    const color = getTextColor(type)
    if (!color) return ({ content, hasSpecialColor: false, color: undefined })
    content = parseNotificationContentKeys(content)
    console.log(content)


    if (!matchedArray) return { content, hasSpecialColor: false, color }

    for (const matchedKey of matchedArray) {
        content =
            matchedKey === '~c'
                ? content.replace(`${matchedKey}`, `</span>`)
                : content.replace(
                    `${matchedKey}`,
                    `<span class="special-color" style="--color: ${color}">`,
                )
    }

    console.log(content)

    return { content, hasSpecialColor: true, color }
}