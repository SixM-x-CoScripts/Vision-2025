var moving = false
var shiftDown = false
var ctrlDown = false

document.onkeydown = function (data) {
    onKeyRelease(data)
}

document.onkeyup = function (data) {
    onKey(data)
}

const onKeyRelease = data => {
    if (data.code == 'ShiftLeft') {
        shiftDown = false
    }
    if (data.code == 'ControlLeft') {
        ctrlDown = false
    }
}

const onKey = (data) => {

    if (data.code == 'ShiftLeft') {
        shiftDown = true
    }
    if (data.code == 'ControlLeft') {
        ctrlDown = true
    }
    if (data.code == 'Escape') {
        if (xmlOpen) {
            $('.clipboard-container').fadeOut()
            xmlOpen = false
        } else {
            $.post(`https://${GetParentResourceName()}/closeTab`)
        }
    } else if (data.code == 'KeyZ') {
        switchModes()
    } else if (data.code == 'ArrowRight' || data.code == 'ArrowLeft') {
        if (currentMode != 'minimal') return
        var change = minimalData[currentMinimalGroup][currentMinimalIndex].isInt ? shiftDown ? 5 : 1 : shiftDown ? 5.0 : ctrlDown ? 0.1 : 0.5
        var currentValue = minimalData[currentMinimalGroup][currentMinimalIndex].value
        if (data.code == 'ArrowRight') {
        } else {
            change = 0 - change
        }
        var newValue = Math.max(currentValue + change, parseFloat(minimalData[currentMinimalGroup][currentMinimalIndex].min))
        newValue = Math.min(newValue, parseFloat(minimalData[currentMinimalGroup][currentMinimalIndex].max))
        minimalData[currentMinimalGroup][currentMinimalIndex].value = newValue

        
        const effectClass = ctrlDown ? 'slider-move-effect-light' : shiftDown ? 'slider-move-effect-hard' : 'slider-move-effect-med'
        if (currentValue != newValue){
            
            $(`#main > .minimal-digit`).addClass(effectClass)
            $(`#main > .slider`).addClass(effectClass)
            setTimeout(() => {
                $(`#main > .minimal-digit`).removeClass(effectClass)
                $(`#main > .slider`).removeClass(effectClass)
            }, 180);
        }
        $(`#main > .item-number.slider`).val(newValue.toFixed(minimalData[currentMinimalGroup][currentMinimalIndex].isInt ? 0 : 2))
        $(`#main > .minimal-digit`).html(newValue.toFixed(minimalData[currentMinimalGroup][currentMinimalIndex].isInt  ? 0 : 2))

        setHandlingValue(minimalData[currentMinimalGroup][currentMinimalIndex].property, minimalData[currentMinimalGroup][currentMinimalIndex].value)
    } else if ((['ArrowUp', 'ArrowDown', 'KeyE', 'KeyQ'].includes(data.code)) && !moving) {
        if (currentMode != 'minimal') return
        moving = true
        $('.list-item.minimal').removeClass().addClass('list-item minimal');
        $('#before').addClass('before');
        
        $('#temp').css('top', 'initial');
        $('#temp').css('bottom', 'initial');

        $('#temp').addClass('temp');
        $('#main').addClass('main');
        $('#after').addClass('after');

        const setMenuItemData = ((identifier, index) => {
            if (identifier == '#main') {
            }
            $(`${identifier} > .list-item-data > .list-title`).text(minimalData[currentMinimalGroup][index].label)
            $(`${identifier} > .list-item-data > .list-subtitle`).text(minimalData[currentMinimalGroup][index].property)
            $(`${identifier}`).data(minimalData[currentMinimalGroup][index]);

            $(`${identifier} > .item-number.slider`).attr({
                max: parseFloat(minimalData[currentMinimalGroup][index].max) || 1000,
                min: parseFloat(minimalData[currentMinimalGroup][index].min) || 0,
                step: minimalData[currentMinimalGroup][index].isInt ? 1 : 0.1                
            });
            $(`${identifier} .item-number.slider`).val(minimalData[currentMinimalGroup][index].value)
            $(`${identifier} .minimal-digit`).html(minimalData[currentMinimalGroup][index].value.toFixed(minimalData[currentMinimalGroup][index].isInt  ? 0 : 2))
        })
        
        if (data.code == 'ArrowUp') {
            $('#temp').css('bottom', -70);
            $('#temp').addClass('minimal-slide-down');
            $('#main').addClass('minimal-slide-down-scale-up');
            $('#after').addClass('minimal-slide-down-scale-down');
            $('#before').addClass('minimal-slide-down');
            
            currentMinimalIndex = currentMinimalIndex - 1
            if (currentMinimalIndex < 0) {
                currentMinimalIndex = minimalData[currentMinimalGroup].length - 1
            }

            const tempIndex = currentMinimalIndex + 2 < minimalData[currentMinimalGroup].length - 1  ? currentMinimalIndex + 2 : 0
            setMenuItemData('#temp', tempIndex)

        } else if (data.code == 'ArrowDown') {
            $('#temp').css('top', -70);
            $('#temp').addClass('minimal-slide-up');
            $('#main').addClass('minimal-slide-up-scale-up');
            $('#after').addClass('minimal-slide-up');
            $('#before').addClass('minimal-slide-up-scale-down');
            
            currentMinimalIndex = currentMinimalIndex + 1
            if (currentMinimalIndex > minimalData[currentMinimalGroup].length - 1) {
                currentMinimalIndex = 0
            }
            const tempIndex = currentMinimalIndex + 2 < minimalData[currentMinimalGroup].length - 1  ? currentMinimalIndex + 2 : 0
            setMenuItemData('#temp', tempIndex)
        } else if (data.code == 'KeyE' || data.code == 'KeyQ') {
            if (currentMode == 'minimal') {
                $('#temp').css('top', -70);

                if (data.code == 'KeyQ') {
                    handlingGroupIndex = handlingGroupIndex > 0 ? handlingGroupIndex - 1 : handlingGroups.length - 1
                    $('#q-button').addClass('pressed')
                    setTimeout(() => {
                        $('#q-button').removeClass('pressed')
                    }, 60);
                } else {    
                    handlingGroupIndex = handlingGroupIndex < handlingGroups.length - 1 ? handlingGroupIndex + 1 : 0
                    $('#e-button').addClass('pressed')
                    setTimeout(() => {
                        $('#e-button').removeClass('pressed')
                    }, 60);
                }
                currentMinimalGroup = handlingGroups[handlingGroupIndex]
                currentMinimalIndex = 0

                $('.minimal-container').fadeOut(30)
                setTimeout(() => {
                    $('.minimal-container').fadeIn(200)
                }, 300);
            }
        }

        if (data.code == 'KeyE' || data.code == 'KeyQ' ? 50 : 0) {
            setTimeout(() => {
                $('#group-name').text(currentMinimalGroup)
                setMenuItemData('#main', currentMinimalIndex)
                setMenuItemData('#after', currentMinimalIndex + 1 <= minimalData[currentMinimalGroup].length - 1 ? currentMinimalIndex + 1 : 0)
                setMenuItemData('#before', currentMinimalIndex - 1 >= 0 ? currentMinimalIndex - 1 : minimalData[currentMinimalGroup].length - 1)
            }, 50);
        } else {
            setMenuItemData('#main', currentMinimalIndex)
            setMenuItemData('#after', currentMinimalIndex + 1 <= minimalData[currentMinimalGroup].length - 1 ? currentMinimalIndex + 1 : 0)
            setMenuItemData('#before', currentMinimalIndex - 1 >= 0 ? currentMinimalIndex - 1 : minimalData[currentMinimalGroup].length - 1)
        }

        
        setTimeout(() => {
            $('.list-item.minimal').removeClass().addClass('list-item minimal');
            $('#before').addClass('before');
            $('#temp').addClass('temp');
            $('#main').addClass('main');
            $('#after').addClass('after');
            setTimeout(() => {
                moving = false
            }, 50);
        }, 300);
    }
} 