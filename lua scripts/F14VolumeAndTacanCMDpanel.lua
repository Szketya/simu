local old_PLTlamp = -1
local old_NFOlamp = -1
local last_run_time = 0.4
local file

local function export_F14VolumeAndTacanCMD()
	file = io.open(lfs.writedir() .. "Logs/F14VolumeAndTacanCMD.log", "w")
	file:write(logMessage .. "\n")	
	
	if file then
        -- Kezdő üzenet írása
        file:write("ok...Starting F14VolumeAndTacanCMD export.\n")  
		
		local mainPanel = GetDevice(0)
		
		local PLTlamp = mainPanel:get_argument_value(290)
		file:write(" PLTlamp: " .. PLTlamp .. "\n")
		local NFOlamp = mainPanel:get_argument_value(291)
		file:write(" NFOlamp: " .. NFOlamp .. "\n")
		
		
		if PLTlamp ~= old_PLTlamp then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("18=%s,", PLTlamp)))
					old_PLTlamp = PLTlamp
					_G.socket_inhibit = false
			end
		end
		
		if NFOlamp ~= old_NFOlamp then
			if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("19=%s,", NFOlamp)))
					old_NFOlamp = NFOlamp
					_G.socket_inhibit = false
			end
		end
		
		
	end
	file:write("ok...VolumeAndTacanCMD export completed.\n")
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
		export_F14VolumeAndTacanCMD()
		last_run_time = current_time
		end

		if prev_next_frame then
			prev_next_frame()
		end
	end
end