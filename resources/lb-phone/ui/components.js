if (!globalThis.componentsLoaded) {
    globalThis.componentsLoaded = true;

    function fetchNui(event, data, scriptName) {
        const options = {
            method: 'POST',
            body: JSON.stringify(data ?? {})
        };

        return new Promise((resolve, reject) => {
            fetch(`https://${scriptName ?? globalThis.resourceName}/${event}`, options)
                .then((res) => res.json())
                .then(resolve)
                .catch((err) => {
                    console.log(err);
                    return;
                });
        });
    }

    let currentPopUpInputCb = null;

    function setPopUp(data) {
        currentPopUpInputCb = null;

        if (!data?.buttons) return;

        for (let i = 0; i < data.buttons.length; i++) {
            if (data.buttons[i].cb) data.buttons[i].callbackId = i;
        }

        if (data.input?.onChange) {
            currentPopUpInputCb = data.input.onChange;
            data.input.onChange = true;
        }

        fetchNui('SetPopUp', data, 'lb-phone').then((buttonId) => {
            if (!data.buttons[buttonId]?.cb) return;
            data.buttons[buttonId].cb();
        });
    }

    function setContextMenu(data) {
        if (!data?.buttons) return;

        for (let i = 0; i < data.buttons.length; i++) {
            if (data.buttons[i].cb) data.buttons[i].callbackId = i;
        }

        fetchNui('SetContextMenu', data, 'lb-phone').then((buttonId) => {
            if (!data.buttons[buttonId]?.cb) return;
            data.buttons[buttonId].cb();
        });
    }

    function setContactModal(number) {
        if (!number) return;

        fetchNui('SetContactModal', number, 'lb-phone');
    }

    function useComponent(cb, data) {
        if (!cb || !data?.component) return;

        fetchNui('ShowComponent', data, 'lb-phone')
            .then((data) => {
                cb(data);
            })
            .catch((err) => {
                console.log(err);
                cb(null);
            });
    }

    function selectGallery(data) {
        useComponent(data.cb, { ...data, component: 'gallery' });
    }

    function selectGIF(cb) {
        useComponent(cb, { component: 'gif' });
    }

    function selectEmoji(cb) {
        useComponent(cb, { component: 'emoji' });
    }

    function useCamera(cb, data) {
        useComponent(cb, { ...data, component: 'camera' });
    }

    function colorPicker(cb, data) {
        useComponent(cb, { ...data, customApp: true, component: 'colorpicker' });
    }

    function contactSelector(cb, data) {
        useComponent(cb, { ...data, component: 'contactselector' });
    }

    function getSettings() {
        return new Promise((resolve, reject) => {
            fetchNui('GetSettings', {}, 'lb-phone').then(resolve).catch(reject);
        });
    }

    function getLocale(path, format) {
        return new Promise((resolve, reject) => {
            fetchNui('GetLocale', { path, format }, 'lb-phone').then(resolve).catch(reject);
        });
    }

    function sendNotification(data) {
        data.app = globalThis.appName;
        if (!data?.title && !data?.content) return console.log('Invalid notification data');
        fetchNui('SendNotification', data, 'lb-phone');
    }

    let settingListeners = [];

    function onSettingsChange(cb) {
        if (!cb) return;

        settingListeners.push(cb);
    }

    globalThis.addEventListener('message', (event) => {
        const data = event.data;
        const type = data.type;

        if (type === 'settingsUpdated') {
            settingListeners.forEach((cb) => cb(data.settings));
        } else if (type === 'popUpInputChanged') {
            if (currentPopUpInputCb) currentPopUpInputCb(data.value);
        }
    });

    function toggleInput(toggle) {
        fetchNui('toggleInput', toggle, 'lb-phone');
    }

    let addedHandlers = [];

    function refreshInputs(inputs) {
        inputs.forEach((input) => {
            if (addedHandlers.includes(input)) return console.log('already added handler for', input);

            input.addEventListener('focus', () => toggleInput(true));
            input.addEventListener('blur', () => toggleInput(false));
        });
    }

    refreshInputs(document.querySelectorAll('input, textarea'));

    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            mutation.addedNodes.forEach((node) => {
                if (node.childNodes.length > 0) refreshInputs(node.querySelectorAll('input, textarea'));
                if (node.tagName === 'INPUT' || node.tagName === 'TEXTAREA') refreshInputs([node]);
            });
        });
    });

    observer.observe(document.body, { childList: true, subtree: true });

    function createCall(data) {
        fetchNui('CreateCall', data, 'lb-phone');
    }

    globalThis.SetPopUp = setPopUp;
    globalThis.SetContextMenu = setContextMenu;
    globalThis.SetContactModal = setContactModal;
    globalThis.UseComponent = useComponent;
    globalThis.SelectGallery = selectGallery;
    globalThis.SelectGIF = selectGIF;
    globalThis.SelectEmoji = selectEmoji;
    globalThis.GetSettings = getSettings;
    globalThis.GetLocale = getLocale;
    globalThis.SendNotification = sendNotification;
    globalThis.OnSettingsChange = onSettingsChange;

    globalThis.postMessage('componentsLoaded', '*');
}
