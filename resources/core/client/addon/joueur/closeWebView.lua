function closeWebview()
	print('closeWebview')
	SendNuiMessage(json.encode({
		type = 'closeWebview',
	}))
end

RegisterNetEvent('core:closeWebview', function ()
	closeWebview()
end)

exports('closeWebview', function ()
	closeWebview()
end)