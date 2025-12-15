local ButtonsNotUpdated = 1

local old_NoGoLamp = -999
local old_GoLamp = -1
local old_tensKnobStatus = -1
local old_onesKnobStatus = -1
local last_run_time = 0.5
local lastNoGoTime = 0
local lampDelay = 0.2 -- másodperc a két lámpa üzenet között
local file

local function export_F14TacanPanel()
	file = io.open(lfs.writedir() .. "Logs/F14TacanPanel.log", "w")
	file:write(logMessage .. "\n")	
	
	if file then
        -- Kezdő üzenet írása
        file:write("ok...Starting F14TacanPanel export.\n")  
		
		local mainPanel = GetDevice(0)
		
		local NoGoLamp = mainPanel:get_argument_value(8051)
		file:write(" NoGoLamp: " .. NoGoLamp .. "\n")
		local GoLamp = mainPanel:get_argument_value(8050)
		file:write(" GoLamp: " .. GoLamp .. "\n")
		
		local tensKnobStatus = mainPanel:get_argument_value(8888)
		file:write(" tensKnobStatus: " .. tensKnobStatus .. "\n")
		local onesKnobStatus = mainPanel:get_argument_value(8889)
		file:write(" onesKnobStatus: " .. onesKnobStatus .. "\n")
		
		local current_time = _G.shared_game_time or 0

		-- NoGoLamp küldése
		if NoGoLamp ~= old_NoGoLamp then
			if _G.socket_inhibit == false then
				_G.socket_inhibit = true
				xsocket.try(x:send(string.format("16=%s,", NoGoLamp)))
				old_NoGoLamp = NoGoLamp
				lastNoGoTime = current_time
				_G.socket_inhibit = false
			end
		end

		-- GoLamp küldése csak, ha eltelt a delay a NoGo után
		if GoLamp ~= old_GoLamp and (current_time - lastNoGoTime >= lampDelay) then
			if _G.socket_inhibit == false then
				_G.socket_inhibit = true
				xsocket.try(x:send(string.format("17=%s,", GoLamp)))
				old_GoLamp = GoLamp 
				_G.socket_inhibit = false
			end
		end
		
		if ButtonsNotUpdated == 1 then
			if tensKnobStatus ~= old_tensKnobStatus then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("20=%s,", tensKnobStatus)))
					old_tensKnobStatus = tensKnobStatus
					_G.socket_inhibit = false
				end
			end
			
			if onesKnobStatus ~= old_onesKnobStatus then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("21=%s,", onesKnobStatus)))
					old_onesKnobStatus = onesKnobStatus
					_G.socket_inhibit = false
				end
			end
		end
		
	end
	file:write("ok...F14 Tacan Panel export completed.\n")
    file:close()
end


do
    local prev_next_frame = LuaExportAfterNextFrame
    LuaExportAfterNextFrame = function()
		local current_time = _G.shared_game_time

		if current_time == nil then 
			logMessage = "fail...shared game time-nak nincs értéke"
		else
			logMessage = "shared game time:" .. current_time
		end	

		if current_time > last_run_time then
			export_F14TacanPanel()
			last_run_time = current_time
		end

		if prev_next_frame then
			prev_next_frame()
		end
	end
end
