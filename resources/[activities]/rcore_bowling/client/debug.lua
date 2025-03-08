function RenderLaneDebug(
    startPos, startLeftPoint, startRightPoint, startGutterLeft, startGutterRight,
    endPos, endLeftPoint, endRightPoint, endGutterLeft, endGutterRight, off
)
    DrawBox(
        startPos - off,
        startPos + off,
        255, 0, 0, 150
    )
    
    DrawBox(
        endPos - off,
        endPos + off,
        255, 0, 0, 150
    )
    
    DrawBox(
        startLeftPoint - off,
        startLeftPoint + off,
        0, 0, 255, 150
    )
    
    DrawBox(
        startRightPoint - off,
        startRightPoint + off,
        0, 255, 0, 150
    )
    
    DrawBox(
        endLeftPoint - off,
        endLeftPoint + off,
        0, 0, 255, 150
    )
    
    DrawBox(
        endRightPoint - off,
        endRightPoint + off,
        0, 255, 0, 150
    )

    DrawPoly(
        startRightPoint, 
        endLeftPoint, 
        startLeftPoint, 
        255, 255, 255, 50
    )
    
    DrawPoly(
        startRightPoint, 
        endRightPoint, 
        endLeftPoint, 
        255, 255, 255, 50
    )

    DrawLine(
        startGutterLeft, 
        endGutterLeft, 255, 0, 0, 255
    )

    DrawLine(
        startGutterRight, 
        endGutterRight, 255, 0, 0, 255
    )
    

    DrawLine(
        startLeftPoint, 
        endLeftPoint, 255, 255, 255, 255
    )

    DrawLine(
        startRightPoint, 
        endRightPoint, 255, 255, 255, 255
    )
end

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         local lane = Lanes.GABZ_7
--         if lane.StartPos then
--             RenderDebugOiling(lane)
--         end
--     end
-- end)

function RenderDebugOiling(lane)
	local off = vector3(0.05, 0.05, 0.05)
	RenderLaneDebug(
		lane.StartPos, lane.StartLeftPoint, lane.StartRightPoint, lane.StartGutterLeft, lane.StartGutterRight,
		lane.EndPos, lane.EndLeftPoint, lane.EndRightPoint, lane.EndGutterLeft, lane.EndGutterRight, off
	)

    -- local xxxx = vector3(
    --     lane.StartPos.x + math.cos(math.rad(lane.StartBaseAngle)) * 1.0 * (3.162 * 4 + 2.82 * 2 + 0.881), 
    --     lane.StartPos.y + math.sin(math.rad(lane.StartBaseAngle)) * 1.0 * (3.162 * 4 + 2.82 * 2 + 0.881),
    --     lane.StartPos.z
    -- )
    

    -- local yyyyy = vector3(
    --     lane.EndPos.x + math.cos(math.rad(lane.StartBaseAngle)) * 1.0 * (3.162 * 4 + 2.82 * 2 + 0.881), 
    --     lane.EndPos.y + math.sin(math.rad(lane.StartBaseAngle)) * 1.0 * (3.162 * 4 + 2.82 * 2 + 0.881),
    --     lane.EndPos.z
    -- )

    -- print(xxxx)
    -- print(yyyyy)

    -- DrawBox(
    --     xxxx - 0.005,
    --     xxxx + 0.005, 255, 255, 0, 255
    -- )
    
    -- local xxxx = vector3(
    --     lane.StartPos.x + math.cos(math.rad(lane.StartBaseAngle)) * 1.0 * ((3.162 * 4 + 2.82 * 2 + 0.881) - #(lane.StartPos - lane.StartLeftPoint)), 
    --     lane.StartPos.y + math.sin(math.rad(lane.StartBaseAngle)) * 1.0 * ((3.162 * 4 + 2.82 * 2 + 0.881) - #(lane.StartPos - lane.StartLeftPoint)),
    --     lane.StartPos.z
    -- )

    -- DrawBox(
    --     xxxx - 0.005,
    --     xxxx + 0.005, 255, 255, 0, 255
    -- )
    
    -- local xxxx = vector3(
    --     lane.StartPos.x + math.cos(math.rad(lane.StartBaseAngle)) * 1.0 * ((3.162 * 4 + 2.82 * 2 + 0.881) + #(lane.StartPos - lane.StartLeftPoint)), 
    --     lane.StartPos.y + math.sin(math.rad(lane.StartBaseAngle)) * 1.0 * ((3.162 * 4 + 2.82 * 2 + 0.881) + #(lane.StartPos - lane.StartLeftPoint)),
    --     lane.StartPos.z
    -- )

    -- DrawBox(
    --     xxxx - 0.005,
    --     xxxx + 0.005, 255, 255, 0, 255
    -- )

	-------- RENDERING of oiling pattern
	local lineLength = #(lane.StartPos - lane.EndPos)


	for x = -lane.Width, lane.Width+0.1, 0.1 do
		local offsetStartPos = vector3(
			lane.StartPos.x + math.cos(math.rad(lane.StartBaseAngle)) * 1.0 * x, 
			lane.StartPos.y + math.sin(math.rad(lane.StartBaseAngle)) * 1.0 * x,
			lane.StartPos.z
		)

		for i = 0, tonumber(math.ceil(lineLength)), 0.2 do
			local pointPos = vector3(
				offsetStartPos.x + math.cos(math.rad(lane.StartBaseAngle + 90)) * 1.0 * i, 
				offsetStartPos.y + math.sin(math.rad(lane.StartBaseAngle + 90)) * 1.0 * i,
				offsetStartPos.z
			)

			local oilingType = GetOilingType(vector2(x, i))
			local color = {255, 255, 255, 20}

			if oilingType == 1 then
				color = {100, 180, 150, 100}
			end
			
			if oilingType == 2 then
				color = {0, 255, 255, 100}
			end

			if oilingType == 3 then
				color = {0, 0, 255, 100}
			end

			-- DrawBox(
			-- 	pointPos - vector3(0.05, 0.09, 0.05),
			-- 	pointPos + vector3(0.05, 0.09, 0.05),
			-- 	color[1], color[2], color[3], color[4]
			-- )
		end
	end
end