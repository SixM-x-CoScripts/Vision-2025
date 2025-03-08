var index = 0;

var AppInput = new Vue({
	el: '#input',
	data:
	{
        identifier: null,
	    titleMenu: "rcore",
	    float: "middle_screen",
	    position: "middle_screen",
	    ChooseText: "Accept",
	    CloseText: "Close",
	    message: "",
	    visible: false,
	    defaultTextInfront: '$',

	},

    methods: {
        Choose: function(){
            $.post('http://rcore_beerpong/inputmethod', JSON.stringify({
                identifier: this.identifier,
                message: this.message,
            }));
        },
        Close: function(){
            $.post('http://rcore_beerpong/close', JSON.stringify({
                identifier: this.identifier,
            }));
        },
    },
});

var App = new Vue({
	el: '#menu',
	data:
	{
        identifier: null,
	    titleMenu: "rcore",
	    float: "left",
	    position: "middle",
	    visible: false,
		menu: [],
	},
});

function setActiveMenuIndex(index, active_){
    for(var i = 0; i < App.menu.length; i++){ App.menu[i].active = false }
    if(App.menu[index] != null) App.menu[index].active = active_
}

function sendAlert(msg, style = 'success') {
    $.notify( { message: msg,}, {
        type: style,
        showProgressbar: false,
        newest_on_top: true,
        animate:
        {
            enter: "animated bounceInRight",
            exit: "animated bounceOutRight",
        }
    });
}

function changePage(page){
	if(page == 1){
		$("#start").hide();
		$("#middle").show();
	}
	if(page == 2){
		$("#middle").hide();
		$("#last").show();
	}
	if(page == 3){
		$("#modal-container").addClass('out');
		$('body').removeClass('modal-active');
		$.post("http://rcore_beerpong/closefocus")
	}
}

function ResetGuideView(){
	$("#start").show();
	$("#middle").hide();
	$("#last").hide();
}

// Guide
$(function(){
    function display(bool) {
        AppInput.visible = bool;
    }
    display(false);
	window.addEventListener('message', function(event) {
        var item = event.data;

		if(item.type === "play_sound"){
            var audio = new Audio('./sounds/' + item.file);
            audio.volume = 0.2;
            audio.play();
		}

		if(item.type === "show_guide"){
            $('#modal-container').removeAttr('class').addClass("one");
            $('body').addClass('modal-active');
            ResetGuideView();
		}
	})
});


// Notification
$(function(){
    function display(bool) {
        AppInput.visible = bool;
    }
    display(false);
	window.addEventListener('message', function(event) {
        var item = event.data;

		if(item.type === "error_message"){
		    sendAlert(item.message, item.alert);
		}
	})
});

// Menu
$(function(){
    function display(bool) {
        App.visible = bool;
    }
    display(false);
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type_menu === "reset"){
            App.menu = [];
        }

        if(item.type_menu === "add"){
            App.menu.push({
                label: item.label,
                number: item.index,
                secondLabel: item.secondLabel,
                active: false,
            });
        }

        if(item.type_menu === "title"){
            App.titleMenu = item.title
        }

        if (item.type_menu === "ui"){
            display(item.status);
            if(item.properties){
                App.float = item.properties.float;
                App.position = item.properties.position;
            }
            App.identifier = item.identifier;
            index = 0;
            setActiveMenuIndex(0, true)
        }

	    if(App.visible && !AppInput.visible){
            if (item.type_menu === "enter"){
                $.post('http://rcore_beerpong/clickItem', JSON.stringify({
                    index: App.menu[index].number,
                    identifier: App.identifier,
                }));
            }

            if (item.type_menu === "up"){
                var lastIndex = index;
                index --;
                if(index < 0) {
                    index = App.menu.length -1
                    document.getElementById('scrolldiv').scrollTop = 90000;
                    }else{
                    document.getElementById('scrolldiv').scrollTop -= 33;
                }
                setActiveMenuIndex(index, true)

                $.post('http://rcore_beerpong/selectNew', JSON.stringify({
                    index: App.menu[index].number,
                    identifier: App.identifier,
                    newIndex: App.menu[index].number,
                    oldIndex: App.menu[lastIndex].number,
                }));
            }

            if (item.type_menu === "down"){
                var lastIndex = index;
                index ++;
                if(index > App.menu.length -1) {
                    index = 0
                    document.getElementById('scrolldiv').scrollTop = 0;
                    }else{
                    document.getElementById('scrolldiv').scrollTop += 33;
                }

                setActiveMenuIndex(index, true)

                $.post('http://rcore_beerpong/selectNew', JSON.stringify({
                    index: App.menu[index].number,
                    identifier: App.identifier,
                    newIndex: App.menu[index].number,
                    oldIndex: App.menu[lastIndex].number,
                }));
            }
		}
	})
});

// Input
$(function(){
    function display(bool) {
        AppInput.visible = bool;
    }
    display(false);
	window.addEventListener('message', function(event) {
        var item = event.data;

        if(item.type_menu === "title_input"){
            AppInput.titleMenu = item.title
        }

        if (item.type_menu === "ui_input"){
            display(item.status);
            if(item.properties){
                AppInput.float = item.properties.float;
                AppInput.position = item.properties.position;
                AppInput.ChooseText = item.properties.ChooseText;
                AppInput.CloseText = item.properties.CloseText;
            }
            AppInput.identifier = item.identifier;
        }
	})
});