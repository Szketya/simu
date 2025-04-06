local old_PUSLampLeft = -1
local old_PUSLampRight = -1
local old_pylon4 = -1
local old_pylon3 = -1
local old_pylon2 = -1
local old_pylon1 = -1
local old_USLPloaded = -1
local old_USLPinop = -1
local old_armed = -1
local last_run_time = 0.2
local file

local function export_Mi24WP()
	file = io.open(lfs.writedir() .. "Logs/Mi24WP.log", "w")
	file:write(logMessage .. "\n")	
	
	if file then
        -- Kezdő üzenet írása
        file:write("ok...Starting Mi24WP export.\n")  
		
		local mainPanel = GetDevice(0)
		
		local PUSLampLeft = mainPanel:get_argument_value(535)
		file:write(" PUSLampLeft: " .. PUSLampLeft .. "\n")
		local PUSLampRight = mainPanel:get_argument_value(534)
		file:write(" PUSLampRight: " .. PUSLampRight .. "\n")
		
		local pylon4 = mainPanel:get_argument_value(539)
		file:write(" pylon4: " .. pylon4 .. "\n")
		local pylon3 = mainPanel:get_argument_value(540)
		file:write(" pylon3: " .. pylon3 .. "\n")
		local pylon2 = mainPanel:get_argument_value(543)
		file:write(" pylon2: " .. pylon2 .. "\n")
		local pylon1 = mainPanel:get_argument_value(544)
		file:write(" pylon1: " .. pylon1 .. "\n")
		
		local USLPloaded = mainPanel:get_argument_value(533)
		file:write(" USLPloaded: " .. USLPloaded .. "\n")
		local USLPinop = mainPanel:get_argument_value(532)
		file:write(" USLPinop: " .. USLPinop .. "\n")
		
		local armed = mainPanel:get_argument_value(548)
		file:write(" armed: " .. armed .. "\n")
		
		
		
		if PUSLampLeft ~= old_PUSLampLeft then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("535=%s,", PUSLampLeft)))
					old_PUSLampLeft = PUSLampLeft 
					_G.socket_inhibit = false
			end
		end
		
		if PUSLampRight ~= old_PUSLampRight then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("534=%s,", PUSLampRight)))
					old_PUSLampRight = PUSLampRight 
					_G.socket_inhibit = false
			end
		end
		
		if pylon4 ~= old_pylon4 then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("539=%s,", pylon4)))
					old_pylon4 = pylon4
					_G.socket_inhibit = false
			end
		end
		
		if pylon3 ~= old_pylon3 then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("540=%s,", pylon3)))
					old_pylon3 = pylon3
					_G.socket_inhibit = false
			end
		end
		
		if pylon2 ~= old_pylon2 then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("543=%s,", pylon2)))
					old_pylon2 = pylon2
					_G.socket_inhibit = false
			end
		end
		
		if pylon1 ~= old_pylon1 then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("544=%s,", pylon1)))
					old_pylon1 = pylon1
					_G.socket_inhibit = false
			end
		end
		
		if USLPloaded ~= old_USLPloaded then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("533=%s,", USLPloaded)))
					old_USLPloaded = USLPloaded
					_G.socket_inhibit = false
			end
		end
		
		if USLPinop ~= old_USLPinop then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("532=%s,", USLPinop)))
					old_USLPinop = USLPinop
					_G.socket_inhibit = false
			end
		end
		
		if armed ~= old_armed then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("548=%s,", armed)))
					old_armed = armed
					_G.socket_inhibit = false
			end
		end
		
		
	end
	file:write("ok...Mi24 Weapon Panel export completed.\n")
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
		export_Mi24WP()
		last_run_time = current_time
		end

		if prev_next_frame then
			prev_next_frame()
		end
	end
end