AddEventHandler("pma-voice:setTalkingMode", function(newTalkingRange) 
	
	voiceMode = newTalkingRange

    --[[ print(voiceMode) ]]	

	if voiceMode == 1 then
		mode = 'chuchoter'
	elseif voiceMode == 2 then
		mode = 'normal'
	elseif voiceMode == 3 then
		mode = 'crier'
	end

 	SendNUIMessage({
		type = "voice",
		data = {
			voiceRange = mode, -- Peut être 'crier', 'chuchoter', 'normal'
			isSpeaking = false
		}
	})

end

)