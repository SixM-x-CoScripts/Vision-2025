window.onload = (e) => {
	window.addEventListener('message', onMessageRecieved);
};

let config = {
	timeFormat: 0,
	dateFormat: 0
};
let lastZoomBarLength = 243; // (243px, default for 1920:1080)
const months = {
	1: 'JAN', 2: 'FEB', 3: 'MAR', 4: 'APR', 5: 'MAY', 6: 'JUN', 7: 'JUL', 8: 'AUG', 9: 'SEP', 10: 'OCT', 11: 'NOV', 12: 'DEC'
};

function FormatDate(day, month, year) {
	let date;
	switch(config.dateFormat) {
		case 0:
			date = month+"/"+day+"/"+year.slice(-2); // 0 = MM/DD/YY
			break;
		case 1:
			date = day+"/"+month+"/"+year.slice(-2); // 1 = DD/MM/YY
			break;
		case 2:
			date = year.slice(-2)+"/"+month+"/"+day; // 2 = YY/MM/DD
			break;
		case 3:
			date = day+"-"+months[month]+"-"+year;  // 2 = DD-Mon-YYYY
			break;
		default:
			console.log("Error: date format was invalid!");
	}
	
	$("#date").text(date);
};

function UpdateZuluTime() {
	const date = new Date();
	const hours = date.getUTCHours().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	const minutes = date.getUTCMinutes().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	const seconds = date.getUTCSeconds().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	const time = hours+":"+minutes+":"+seconds+" Z";
	$("#time").text(time);

	const day = date.getUTCDate().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	let month = date.getUTCMonth()+1; month = month.toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	const year = date.getUTCFullYear().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });

	FormatDate(day, month, year);
};

function UpdateOSTime() {
	const date = new Date();
	let hours = date.getHours().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	let minutes = date.getMinutes().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	let seconds = date.getSeconds().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });

	let time = hours+":"+minutes+":"+seconds
	$("#time").text(time);
};

function UpdateOSDate() {
	const date = new Date();
	const day = date.getDate().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	let month = date.getMonth()+1; month = month.toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
	const year = date.getFullYear().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });

	FormatDate(day, month, year);
};

function onMessageRecieved(event) {
	let data = event.data;

	if (data != undefined) {
		switch(data.action) {
			case 'updateData':
				$.each(data.set, function(id, value) {
					$("#"+id).text(value);
			 	});

				// Show/hide/change license plate
				if (data.info.numberplate == false) {
					$("#numberplate-wrapper").hide();
				} else if (data.info.numberplate != undefined) {
					$("#ta-numberplate").text(data.info.numberplate);
					if (!$("#numberplate-wrapper").is(":visible")) {
						$("#numberplate-wrapper").show();
					};
				};

				// Handle time and date
				if (data.info.time) {
					UpdateOSDate();
					$("#time").text(data.info.time);
				} else {
					if (config.timeFormat == 0) {
						UpdateZuluTime();
					} else {
						UpdateOSTime();
						UpdateOSDate();
					};
				};
				break;
			case 'updateDataFrame':
				// Camera Pitch
				$('#pitch-line').css('transform', 'rotate(' + data.pitch + 'deg)');

				// Camera Relative Heading
				$('#heading-line').css('transform', 'rotate(' + data.heading + 'deg)');

				// Bearing
				$('#bearing-img').attr('src', 'images/bearing.svg#svgView(viewBox(' + (data.bearing - 89) + ', 0, 180, 8))');
				$('#bearing-directions').attr('src', 'images/bearing-directions.svg#svgView(viewBox(' + (data.bearing - 90) + ', 0, 180, 10))');
				break;
			case 'setVisionState':
				$("#vision-state").text(data.state); // Sets text in bottom left corner
				break;
			case 'setZoomBarLevel':
				let barLength = $("#zoom-bar").width() || lastZoomBarLength;
				let barPercent = barLength / 100;
				if (barLength != lastZoomBarLength) {
					lastZoomBarLength = barLength;
				};

				barLength = barLength - barPercent * 17.5 // Reduce the bar length by 17.5% to compensate for overflow
				let pixels = barLength / 100 * data.percentage + barPercent * 5;
				$("#zoom-arrow").css("margin-left", pixels + "px");
				break;
			case 'open':
				$("#wrapper").show();
				break;
			case 'close':
				$("#wrapper").hide();
				break;
			case 'startLockScanning':
				$("#lock-bar-container").show();
				$("#lock-bar-progress").stop().css({"width": 0}).animate({
					width: 11 +'%'
					}, {
					duration: parseInt(200),
				});
				break;
			case 'updateLockScanning':
				const end = data.value * 10 + 1
				$("#lock-bar-progress").stop().animate({
					width: end+'%'
					}, {
					duration: parseInt(200),
					easing : "linear"
				});
				break;
			case 'lockScanningFinished':
				$("#lock-bar-container").hide();
				break;
			case 'setCameraLockState':
				if (data.state == true) {
					$("#lock-state").addClass("lock-state-active");
				} else {
					$("#lock-state").removeClass("lock-state-active");
				};
				$("#lock-type").text(data.type);
				break;
			case 'setCameraLabel':
				$("#camera-label").text(data.label);
				break;
			case 'setConfigData':
				$.each(data.set, function(id, value) {
					$("#"+id).text(value);
				});

				if (data.showLatitudeLongitude == true) {
					$("#hi-latitude").show();
					$("#hi-longitude").show();
					$("#ta-latitude").show();
					$("#ta-longitude").show();
				} else {
					$(".street").css('display', 'inline-block');
				};

				if (data.showLicensePlate == false) {
					$("#numberplate-wrapper").hide();
				};

				if (data.hideMinimap == false) {
					$("#camera-info").css("bottom", data.zoomBarOffset+"%");
				};

				if (data.showInstructions == true) {
					$("#relative-info").css("bottom", "6%");
					if (data.hideMinimap == true) {
						$("#camera-info").css("bottom", "6%");
					};
				};

				config.timeFormat = data.timeFormat;
				config.dateFormat = data.dateFormat;
				break;
			default:
				console.log("Error: spesifed action was not found!", data.action);
		}
	} else {
		console.log("Error: data was not defined!");
	};
};
