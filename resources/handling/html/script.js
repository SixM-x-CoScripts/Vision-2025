const CFG = {
    debugMode: false,
    enableKeysHints: true
}

var LoadedHandlingData = {}
var handlingGroups = []
var minimalData = {}
var handlingGroupIndex = 0
var currentMinimalIndex = 0
var currentMinimalGroup = 'Other'
var currentMinimalData = {}
var xmlOpen = false
var currentMode = 'tablet'

var isAdmin = false

var PerformanceData = {}

var myChart = {}

var driftMode = false

$(function () {

    window.onmessage = function (event) {
        const item = event.data;
        if (item.action === "displayMin") {
            LoadedHandlingData = item.handlingData
            handlingGroups = item.handlingGroups
            PerformanceData = item.performanceData
            isAdmin = item.isAdmin
            driftMode = item.driftMode
            setMinimalHandlingEditor(item.handlingGroups, item.handlingData)
            $(".minimal-container").fadeIn();
        } else if (item.action === "displayTab") {
            if (myChart.destroy) myChart.destroy();
            LoadedHandlingData = item.handlingData
            handlingGroups = item.handlingGroups
            PerformanceData = item.performanceData
            isAdmin = item.isAdmin
            driftMode = item.driftMode
            setupTabletHandlingEditor(item.handlingGroups, item.handlingData, PerformanceData)
            $(".tablet").fadeIn();
        } else if (item.action === 'presets') {
            setupPresets(item.presets)
        } else if (item.action == 'keyPress') {
            onKey({code: item.button})
        } else if (item.action == 'keyRelease') {
            onKeyRelease({code: item.button})
        } else if (item.action === "close") {
            setTimeout(() => {
                $('#properties').html(`
                <div class="tablet-window-title">
                    <span>Handling Editor</span>${isAdmin ? '<span id="generate-xml">XML <i class="fas fa-code"></i></span>' : ''} <span id="save-button">Save <i class="fas fa-save"></i></span>
                </div>
                `)
                $('#shared').html(`
                <span class="tablet-window-title">Shared presets</span>
                <div class='loading-wrapper'><div class="lds-dual-ring"></div></div>
                `)
                $('#presets').html(`
                <span class="tablet-window-title">Saved presets</span>
                <div class='loading-wrapper'><div class="lds-dual-ring"></div></div>
                `)
            }, 750);
            $(".minimal-container").fadeOut();
            $(".tablet").fadeOut();
            
        }
    };

    

    $('.x-btn').on('click', e => {
        $.post(`https://${GetParentResourceName()}/closeTab`)
    })

    if (CFG.debugMode) {

        LoadedHandlingData = CHandlingData
        handlingGroups = ['Other',
            'Engine',
            'Suspension',
            'Traction',
            'Aero',
            'Damage',
        ]

        PerformanceData = {Aero: 100, MaxSpeed: 85, Braking: 40}

        if (CFG.debugMode == 'tablet') {
            setupTabletHandlingEditor(handlingGroups, CHandlingData, PerformanceData)
            $(".tablet").fadeIn();
        } else {
            setMinimalHandlingEditor(handlingGroups, CHandlingData)
            $(".minimal-container").fadeIn();
            $(".handling-group-wrapper").fadeIn();
        }
    }
});

const switchModes = () => {
    if (currentMode == 'tablet') {
        myChart.destroy()
        setMinimalHandlingEditor(handlingGroups, LoadedHandlingData)
        
        $('.handling-group-wrapper').fadeIn()
        $('.minimal-container').fadeIn()
        $('.minimal-container').removeClass('slide-down', 300)
        $('.tablet').fadeOut()
        setTimeout(() => {
            $('.list-item.minimal.before').removeClass('collapse')
            $('.list-item.minimal.after').removeClass('collapse')
        }, 300);

    } else {
        setupTabletHandlingEditor(handlingGroups, LoadedHandlingData, PerformanceData)

        $('.list-item.minimal.before').addClass('collapse')
        $('.list-item.minimal.after').addClass('collapse')
        $('.handling-group-wrapper').fadeOut()
        setTimeout(() => {
            $('.minimal-container').addClass('slide-down', 300)
        }, 320);


        setTimeout(() => {
            $('.tablet').fadeIn()
            setTimeout(() => {
                $('.minimal-container').hide()
            }, 400);
        }, 300);
    }
} 

const setHandlingValue = (hKey, hValue) => {
    $.post(`https://${GetParentResourceName()}/setHandlingValue`, JSON.stringify({
        key: hKey,
        value: hValue,
    }))
}

const selectText = (containerid) => {
    if (document.selection) { // IE
        var range = document.body.createTextRange();
        range.moveToElementText(document.getElementById(containerid));
        range.select();
    } else if (window.getSelection) {
        var range = document.createRange();
        range.selectNode(document.getElementById(containerid));
        window.getSelection().removeAllRanges();
        window.getSelection().addRange(range);
    }
}

const parseXml = (xml, arrayTags) => {
    let dom = null;
    if (window.DOMParser) dom = (new DOMParser()).parseFromString(xml, "text/xml");
    else if (window.ActiveXObject) {
        dom = new ActiveXObject('Microsoft.XMLDOM');
        dom.async = false;
        if (!dom.loadXML(xml)) throw dom.parseError.reason + " " + dom.parseError.srcText;
    }
    else throw new Error("cannot parse xml string!");

    function parseNode(xmlNode, result) {
        if (xmlNode.nodeName == "#text") {
            let v = xmlNode.nodeValue;
            if (v.trim()) result['#text'] = v;
            return;
        }

        let jsonNode = {},
            existing = result[xmlNode.nodeName];
        if (existing) {
            if (!Array.isArray(existing)) result[xmlNode.nodeName] = [existing, jsonNode];
            else result[xmlNode.nodeName].push(jsonNode);
        }
        else {
            if (arrayTags && arrayTags.indexOf(xmlNode.nodeName) != -1) result[xmlNode.nodeName] = [jsonNode];
            else result[xmlNode.nodeName] = jsonNode;
        }

        if (xmlNode.attributes) for (let attribute of xmlNode.attributes) jsonNode[attribute.nodeName] = attribute.nodeValue;

        for (let node of xmlNode.childNodes) parseNode(node, jsonNode);
    }

    let result = {};
    for (let node of dom.childNodes) parseNode(node, result);

    return result;
}

const OBJtoXML = (obj, padding) => {
    padding = padding || 0
    var space = '';
    for (i = 0; i < padding; i++) {
        space += '&nbsp;&nbsp;&nbsp;&nbsp;'
    }
    var xml = '';
    const insideElementEntries = ['x', 'y', 'z', 'type', 'value']
    const countNotInsideElements = (o) => {
        var retval = 0
        for (const [key, data] of Object.entries(o)) {
            if (!insideElementEntries.includes(key)) retval ++;
        }
        return retval
    }
    for (var prop in obj) {
        if (!insideElementEntries.includes(prop)) {
            const closedElem = countNotInsideElements(obj[prop]) > 0 || obj[prop]['#text']
            var addDash = closedElem ? '' : ' /'
            var insideEntries = ''
            if (obj[prop] instanceof Array) {
            } else {
                for (const entry of insideElementEntries) {
                    if (obj[prop][entry]) {
                        insideEntries += ` ${entry}="<span class='xml-value'>${obj[prop][entry]}</span>"`
                    }
                }
                xml += `${space}<span class='xml-elem'><<span class='xml-name'>${prop}</span>${insideEntries}${addDash}></span>${obj[prop]['#text'] ? '': '\n'}`
            }
            if (obj[prop] instanceof Array) {
                for (var array in obj[prop]) {
                    var addDash = countNotInsideElements(obj[prop][array]) > 0 ? '' : ' /'
                    xml += `${space}<span class='xml-elem'><<span class='xml-name'>${prop}</span> ${obj[prop][array].value ? ` value="<span class='xml-value'>${obj[prop][array].value}</span>"${addDash}` : obj[prop][array].type ? ` type="<span class='xml-value'>${obj[prop][array].type}"${addDash}</span>` : ''}></span>\n`;
                    xml += OBJtoXML(new Object(obj[prop][array]), padding + 1);
                    if (countNotInsideElements(obj[prop][array]) > 0 ) {
                        xml += `${space}<span class='xml-elem'><&#47;<span class='xml-name'>${prop}</span>></span>\n`;
                    }
                }
            } else if (typeof obj[prop] == "object" && !obj[prop]['#text']) {
                xml += OBJtoXML(new Object(obj[prop]), padding + 1);
            } else {
                xml += obj[prop]['#text'] || obj[prop];
            }
            if (closedElem) {
                xml += obj[prop] instanceof Array ? '' : `${obj[prop]['#text'] ? '' : space}<span class='xml-elem'><&#47;<span class='xml-name'>${prop}</span>></span>\n`;
            }
        }
    }
    var xml = xml.replace(/<\/?[0-9]{1,}>/g, '');
    return xml
}


const setMinimalHandlingEditor = (groups, handlingData) => {
    currentMode = 'minimal'
    var minimalHandlingData = [];

    $.post(`https://${GetParentResourceName()}/setNUIfocus`, JSON.stringify({
        enabled: false,
    }))

    handlingGroups = groups
    for (i = 0; i < groups.length; i++) {
        const group = groups[i];
        minimalHandlingData[group] = [];
    }
    
    for (const [key, data] of Object.entries(handlingData)) {
        if (key.substring(0, 3) != 'vec') {
            data.Group = data.Group || 'Other'
            if (minimalHandlingData[data.Group]) {
                minimalHandlingData[data.Group].push({
                    label: data.Label,
                    property: key,
                    min: data.Min.value,
                    max: data.Max.value,
                    isInt: key.charAt(0) == 'n',
                    group: data.Group,
                    value: data.value || Math.max(1, data.Min.value),
                })
            }
        }
    }

    for (let i = handlingGroups.length-1; i >= 0; i--) {
        if (minimalHandlingData[handlingGroups[i]].length <= 0){
            handlingGroups.splice(i, 1)
        }
    }
    minimalData = minimalHandlingData
    currentMinimalGroup = groups[0]
    
    $('#main > .list-item-data > .list-title').text(minimalData[currentMinimalGroup][0].label)
    $('#main > .list-item-data > .list-subtitle').text(minimalData[currentMinimalGroup][0].property)
    $('#main > .list-item-data > .list-subtitle').text(minimalData[currentMinimalGroup][0].property)
    $('#main').data('property', minimalData[currentMinimalGroup][0].property)
    
    $('#after > .list-item-data > .list-title').text(minimalData[currentMinimalGroup][1].label)
    $('#after > .list-item-data > .list-subtitle').text(minimalData[currentMinimalGroup][1].property)
    $('#after').data('property', minimalData[currentMinimalGroup][1].property)
    
    $('#before > .list-item-data > .list-title').text(minimalData[currentMinimalGroup][minimalData[currentMinimalGroup].length - 1].label)
    $('#before > .list-item-data > .list-subtitle').text(minimalData[currentMinimalGroup][minimalData[currentMinimalGroup].length - 1].property)
    $('#before').data('property', minimalData[currentMinimalGroup][minimalData[currentMinimalGroup].length - 1].property)
}

const setupTabletHandlingEditor = (groups, handlingData, performanceData) => {
    $.post(`https://${GetParentResourceName()}/setNUIfocus`, JSON.stringify({
        enabled: true,
    }))
    $('#properties').html(`
    <div class="tablet-window-title">
        <span>Handling Editor</span>
        ${isAdmin ? '<span id="generate-xml">XML <i class="fas fa-code"></i></span>' : ''}
        <span id="save-button">Save <i class="fas fa-save"></i></span>
        ${groups.includes('Drift') ? `<span id="drift-mode"><span>Drift Mode</span>
            <label class="switch">
                <input id='drift-mode-switch' type="checkbox">
                <span class="switch-slider round"></span>
            </label>
        </span>` : ''}
    </div>
    `)

    $('#drift-mode-switch').prop('checked', driftMode).change(e => {
        driftMode = $('#drift-mode-switch').is(":checked")
        $.post(`https://${GetParentResourceName()}/setDriftMode`, JSON.stringify({
            enabled: driftMode,
        }))
    })

    currentMode = 'tablet'

    var performanceGroups = []
    var performanceScores = []
    for (const [key, data] of Object.entries(performanceData)) {
        performanceGroups.push(key)
        performanceScores.push(data)
    }
    // <block:setup:1>
    const DATA_COUNT = 5;
    const NUMBER_CFG = {count: DATA_COUNT, min: 0, max: 100};

    const labels = performanceGroups;
    const data = {
        labels: labels,
        datasets: [
            {
                label: 'Car performance score',
                data: performanceScores,
                backgroundColor: 'rgba(255,195,0,0.35)',
            }
        ]
    };
    // </block:setup>

    // <block:config:0>
    let delayed
    const config = {
        type: 'radar',
        data: data,
        options: {
            animation: {
                onComplete: () => {
                    delayed = true;
                },
                delay: (context) => {
                    let delay = 0;
                    if (context.type === 'data' && context.mode === 'default' && !delayed) {
                        delay = context.dataIndex * 200 + context.datasetIndex * 100;
                    }
                    return delay;
                },
            },
            scale: {
                ticks: {

                    beginAtZero: true,
                    max: 100,
                    min: 0,
                }
            },
            responsive: false,
            scales: {
                r:{
                    suggestedMin: 0,
                    suggestedMax: 100,
                    grid: {
                        borderColor: 'red'
                    },
                    angleLines: {
                        color: 'rgba(38,42,52,0.05)'
                    },
                    gridLines: {
                        display: false
                    },
                    pointLabels: {
                        display: true,
                        font: {
                            size: 13,
                            weight: 'bold'
                        },
                    },
                    ticks: {
                        beginAtZero: true,
                        max: 100,
                        min: 0,
                        display: false,
                        maxTicksLimit: 5,
                        color: 'red'
                    },
                },
            },
            plugins: {
                legend: {
                    display: false,
                },
                title: {
                    display: false,
                }
            }
        },
    };
    // </block:config>

    const ctx = $('#performance-chart');

    myChart = new Chart(ctx, config)

    for (i = 0; i < groups.length; i++) {
        var groupEl = `
        <div id='group-${groups[i]}' class='handling-group'>
            <span class="tablet-window-title group">${groups[i]}</span>
        </div>
        `
        $('#properties').append(groupEl);
    }
    
    for (const [key, data] of Object.entries(handlingData)) {
        const isInt = key.charAt(0) == 'n'
        const isString = key.substring(0, 3) == 'str'
        const isVec = key.substring(0, 3) == 'vec'
        var element = `
        <li class='list-item ${isVec ? 'vec' : 'range'}'>
            <span>
                <span class='list-title'>${data.Label}</span>
                <span class='list-subtitle'>${key || ''}</span>
                <i class="fa-solid fa-circle-question list-item-hint"><span class='list-subtitle'>${data.Description || ''} (${data.Min.value} - ${data.Max.value})</span></i>
            </span>
            ${isVec ? 
                `
                <input id='${key}-x-input' type="${isString ? 'text' : 'number'}" class="item-number number vec-input" data-type="texture" value="0">
                <input id='${key}-y-input' type="${isString ? 'text' : 'number'}" class="item-number number vec-input" data-type="texture" value="0">
                <input id='${key}-z-input' type="${isString ? 'text' : 'number'}" class="item-number number vec-input" data-type="texture" value="0">
                ` :
                `${!isString ? `
                    <input id='${key}-slider' type="range" class="item-number slider" data-type="item" value="0">
                ` : ''}
                <input id='${key}-input' type="${isString ? 'text' : 'number'}" class="item-number number" data-type="texture" value="0">`
            }
        </li>
        `;
        if (data.Group) {
            if ($(`#group-${data.Group}`).length) {
                $(`#group-${data.Group}`).append(element);
            }
        } else {
            $(`#group-Other`).append(element);
        }
        if (!isString && !isVec) {
            data.value = data.value || 0
            $(`#${key}-slider`).attr({
                max: data.Max ? data.Max.value : 1000,
                min: data.Min ? data.Min.value : 0,
                step: isInt ? 1 : 0.0001,
            });
            
            $(`#${key}-input`).attr({
                max: data.Max ? data.Max.value : 1000,
                min: data.Min ? data.Min.value : 0,
                step: isInt ? 1 : 0.1,
            });
        }

        if (isVec) {
            var vector = data.value
            $(`.vec-input`).attr({
                max: data.Max ? data.Max.value : 20,
                min: data.Min ? data.Min.value : -20,
                step: 0.1
            })
            $(`#${key}-x-input`).val(data.value.x.toFixed(4)).on('input', (e) => {
                vector.x = e.target.value
                setHandlingValue(key, vector)
            });
            $(`#${key}-y-input`).val(data.value.y.toFixed(4)).on('input', (e) => {
                vector.y = e.target.value
                setHandlingValue(key, vector)
            });
            $(`#${key}-z-input`).val(data.value.z.toFixed(4)).on('input', (e) => {
                vector.z = e.target.value
                setHandlingValue(key, vector)
            });
        } else {
            $(`#${key}-input`).on('input', (e) => {
                $(`#${key}-slider`).val(e.target.value);
                setHandlingValue(key, e.target.value)
            });

            // On drag
            $(`#${key}-slider`).on('input', (e) => {
                // $(`#${key}-input`).val(e.target.value);
                $(`#${key}-input`).val(isInt ? parseInt(e.target.value) : parseFloat(e.target.value).toFixed(4));

            });
            
            // On drag and release
            $(`#${key}-slider`).on('change', (e) => {
                setHandlingValue(key, e.target.value)
            });
        }
        if (!isString && !isVec) {
            $(`#${key}-input`).val(data.value.toFixed(isInt ? 0 : 4));
            $(`#${key}-slider`).val(data.value.toFixed(isInt ? 0 : 4));
        }

    }

    $('#generate-xml').on('click', (e) => {
        xmlOpen = true
        if (!CFG.debugMode) {
            fetch(`https://${GetParentResourceName()}/getCurrentVehMeta`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({test:'test'})}
                ).then(resp => resp.json()).then(res => {
                    var defaultMeta = parseXml(DefaultHandlings[res.class] ?? DefaultHandlings.main)
                    for (const [key, data] of Object.entries(res.hData)) {
                        if (key.charAt(0) == 'n' || key.charAt(0) == 'f' || key.charAt(0) == 'v') {
                            if (defaultMeta.Item[key]) {
                                if (key.charAt(0) == 'v') {
                                    defaultMeta.Item[key].x = data.x.toFixed(8)
                                    defaultMeta.Item[key].y = data.y.toFixed(8)
                                    defaultMeta.Item[key].z = data.z.toFixed(8)
                                } else {
                                    defaultMeta.Item[key].value = typeof(data.value) == 'number' ? data.value.toFixed(key.charAt(0) == 'n' ? 0 : 8) : data.value
                                }
                            } else {
                                console.error(key + ' not found')
                            }
                        }
                    }
                    defaultMeta.Item.handlingName['#text'] = `<span style="color: red">${res.model}</span>`
                    $('#clipboard-textfield').html(OBJtoXML(defaultMeta))
                    selectText('clipboard-textfield')
                    $('.clipboard-container').fadeIn()
            });
            $('#clipboard-textfield').html(OBJtoXML(defaultMeta))
            selectText('clipboard-textfield')
            $('.clipboard-container').fadeIn()
            const clipElem = document.getElementById("clipboard-textfield");
        }
    });
    
    $('#copy-xml').on('click', (e) => {
        selectText('clipboard-textfield')
        document.execCommand("copy");
    });

    $('#save-button').on('click', (e) => {
        cuteAlert({
            type: 'question',
            title: 'Enter preset name',
            input: 'Preset name...',
            confirmText: 'Okay',
            cancelText: 'Cancel',
        }).then((e, t) => {
            if (e.success) {
                $.post(`https://${GetParentResourceName()}/savePreset`,  JSON.stringify({
                    name: e.input,
                }))
            }
        });
    });

    $('.x-btn-clipboard').on('click', e => {
        $('.clipboard-container').fadeOut()
        xmlOpen = false
    })
}

const setupPresets = (presets) => {
    $('#presets').html(`<span class="tablet-window-title">Saved presets</span>`)
    $('#shared').html(`<span class="tablet-window-title">Shared presets</span>`)
    for (i = 0; i <presets.length; i++) {
        const presetId = presets[i].id
        var element = `
        <li class="list-item">
            <span class="list-title">${presets[i].handlingName}</span>
            <span class="list-subtitle">${presets[i].carName}</span>
            ${presets[i].creator ?  `<span class="list-subtitle">by ${presets[i].creator}</span>` : `<span id='preset-${presetId}-share' class="action-icon share"><i class="fas fa-share-square"></i></span>`}
            <span id='preset-${presetId}-load' class="action-icon load"><i class="fas fa-arrow-circle-down"></i></span>
            <span id='preset-${presetId}-delete' class="action-icon delete"><i class="fas fa-trash"></i></span>
        </li>
        `
        if (presets[i].creator) {
            $('#shared').append(element);
            $('#presets').append(element);
        } else {
            $('#presets').append(element);
        }

        $(`#preset-${presets[i].id}-load`).on('click', (e) => {
            cuteAlert({
                type: 'question',
                title: 'Please confirm',
                message: 'Load the selected preset into the handling editor?',
                confirmText: 'Okay',
                cancelText: 'Cancel',
            }).then((e, t) => {
                if (e.success) {
                    $.post(`https://${GetParentResourceName()}/loadPreset`, JSON.stringify({
                        id: presetId
                    })) 
                }
            });
        }) 
        
        $(`#preset-${presets[i].id}-share`).on('click', (e) => {
            cuteAlert({
                type: 'question',
                title: 'Enter player ID',
                message: 'Please enter player server ID to share this preset with?',
                input: 'Player ID...',
                confirmText: 'Okay',
                cancelText: 'Cancel',
            }).then((e, t) => {
                if (e.success) {
                    $.post(`https://${GetParentResourceName()}/sharePreset`, JSON.stringify({
                        playerId: parseInt(e.input),
                        presetId: presetId
                    }))
                }
            });
        }) 
        
        $(`#preset-${presets[i].id}-delete`).on('click', (e) => {
            cuteAlert({
                type: 'question',
                title: 'Please confirm Deletion',
                message: 'Do you really want to delete the selected preset?',
                confirmText: 'Delete',
                cancelText: 'Cancel',
            }).then((e, t) => {
                if (e.success) {

                    $('#presets').html(`
                    <span class="tablet-window-title">Saved presets</span>
                    <div class='loading-wrapper'><div class="lds-dual-ring"></div></div>
                    `)

                    $('#shared').html(`
                    <span class="tablet-window-title">Shared presets</span>
                    <div class='loading-wrapper'><div class="lds-dual-ring"></div></div>
                    `)
                    $.post(`https://${GetParentResourceName()}/deletePreset`, JSON.stringify({
                        id: presetId
                    }))
                }
            });
        }) 
    }
}