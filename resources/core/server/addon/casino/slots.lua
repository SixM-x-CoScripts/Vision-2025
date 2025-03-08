local activeSlot = {}

SWRegisterServCallback('sunwiseSlots:isSeatUsed',function(source, cb, index)
	if activeSlot[index] ~= nil then
		if activeSlot[index].used then
			cb(true)
		else
			activeSlot[index].used = true
			cb(false)
		end
	else
		activeSlot[index] = {}
		activeSlot[index].used = true
		cb(false)
	end
end)

RegisterNetEvent('sunwiseSlots:notUsing')
AddEventHandler('sunwiseSlots:notUsing',function(index)
	if activeSlot[index] ~= nil then
		activeSlot[index].used = false
	end
end)

RegisterNetEvent('sunwise:casino:StartSlots')
AddEventHandler('sunwise:casino:StartSlots',function(index, data)
	if index and data and data.bet and CasinoConfig.GetChipsCount(source) >= tonumber(data.bet) then
		if activeSlot[index] == nil then
			activeSlot[index] = {}
		end
		if activeSlot[index] then
			CasinoConfig.RemoveChips(source,tonumber(data.bet))
			local w = {a = math.random(1,16),b = math.random(1,16),c = math.random(1,16)}
			
			local rnd1 = math.random(1,100)
			local rnd2 = math.random(1,100)
			local rnd3 = math.random(1,100)
			
			--if ConfigSlots.Offset then
				if rnd1 > 70 then w.a = w.a + 0.5 end
				if rnd2 > 70 then w.b = w.b + 0.7 end
				if rnd3 > 70 then w.c = w.c + 0.5 end
			--end
			
			TriggerClientEvent('sunwiseSlots:startSpin', source, index, w)
			activeSlot[index].win = w
		else
			TriggerClientEvent("core:slots:resetSpin", source)
		end
	else
		TriggerClientEvent("core:slots:resetSpin", source)
		TriggerClientEvent("blackjack:notify",source,CasinoConfigSH.Lang.BadAmount)
	end
end)



RegisterNetEvent('sunwiseSlots:CheckWin')
AddEventHandler('sunwiseSlots:CheckWin',function(index, data, dt)
	if activeSlot[index] then
		--print(math.floor(data.a), math.floor(data.b), math.floor(data.c))
		--print(activeSlot[index].win.a, activeSlot[index].win.b, activeSlot[index].win.c)
		if activeSlot[index].win then
			-- 3 equals
			if math.floor(data.a) == math.floor(data.b) and math.floor(data.b) == math.floor(data.c) then 
				TriggerClientEvent("blackjack:notify",source,string.format(CasinoConfigSH.Lang.WonAmount, 300))
				CasinoConfig.GiveChips(source, 300)
			-- 2 equals
			elseif math.floor(data.a) == math.floor(data.b) or math.floor(data.a) == math.floor(data.c) or math.floor(data.b) == math.floor(data.c) then
				TriggerClientEvent("blackjack:notify",source,string.format(CasinoConfigSH.Lang.WonAmount, 200))
				CasinoConfig.GiveChips(source, 150)
			end
		end
	end
end)

local SlotsWins = { -- DO NOT TOUCH IT
	[1] = '2',
	[2] = '3',
	[3] = '6',
	[4] = '2',
	[5] = '4',
	[6] = '1',
	[7] = '6',
	[8] = '5',
	[9] = '2',
	[10] = '1',
	[11] = '3',
	[12] = '6',
	[13] = '7',
	[14] = '1',
	[15] = '4',
	[16] = '5',
}

local SlotsMult = { -- Multipliers based on GTA:ONLINE
	['1'] = 25,	
	['2'] = 50,
	['3'] = 75,
	['4'] = 100,
	['5'] = 250,
	['6'] = 500,
	['7'] = 1000,
}

function CheckForWin(w, data)
	local a = SlotsWins[w.a]
	local b = SlotsWins[w.b]
	local c = SlotsWins[w.c]
	local total = 0
	if a == b and b == c and a == c then
		if SlotsMult[a] then
			total = data.bet*SlotsMult[a]
		end		
	elseif a == '6' and b == '6' then
		total = data.bet*5
	elseif a == '6' and c == '6' then
		total = data.bet*5
	elseif b == '6' and c == '6' then
		total = data.bet*5
		
	elseif a == '6' then
		total = data.bet*2
	elseif b == '6' then
		total = data.bet*2
	elseif c == '6' then
		total = data.bet*2
	end
	if total > 0 then
		TriggerClientEvent("blackjack:notify",source,string.format(CasinoConfigSH.Lang.WonAmount, total))
		CasinoConfig.GiveChips(source, total)
	end
end