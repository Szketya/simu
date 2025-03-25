--local gombosBRT = gombosBRT or false
--local gombosBRTbeallitva = gombosBRTbeallitva or false
local korrekcio_flag = korrekcio_flag or 0
local fentisav = fentisav or 0
local old_channel_value = old_channel_value or 0
local freki = 0.00001
local oldBright = oldBright or 0
local oldFunction = oldFunction or 0
local old_channel_value = old_channel_value or 0
local chan159inh = chan159inh or false
local last_run_time = 0.2
local file
local old_test = old_test or 0
local old_formatted_freq_159 = old_formatted_freq_159 or ""
local blokkolas159 = blokkolas159 or false
local logMessage = ""



local function export_Arc159_display()
	--if gombosBRT == true and gombosBRTbeallitva == false then
	--xsocket.try(x:send("5=1,"))
	--gombosBRTbeallitva = true
	--end
	file = io.open(lfs.writedir() .. "Logs/ARC159.log", "w")
	file:write(logMessage .. "\n")	

    if file then
        -- Kezdő üzenet írása
        file:write("ok...Starting ARC159 radio export.\n")      

        -- UHF ARC-159 frekvencia lekérése
        local arc_159 = GetDevice(3)

		if arc_159 then
			file:write("ok...ARC-159 (device3) beolvasva\n")
		else
			file:write("fail...ARC-159 (device3) nem létezik\n")
		end
		
        local freq_159 = arc_159:get_frequency()

		if freq_159 == "nan" then 
			file:write("fail...arc_159:getfrequency nem ad vissza értéket\n") 
		else
			file:write("ok...ARC-159 frekciája sikeresen lekérve\n")
		end

		freq_159 = string.sub(freq_159, 1, 6)
		freq_159 = tonumber(freq_159)
		
		if GetDevice(0) then
			file:write("ok...kapcsoló állapotok (Device0) sikeresen beolvasva.\n státuszok:\n")
		else
			file:write("fail...kapcsoló állapotok (device0) beolvasása sikertelen\n")
		end
			
        -- Channel Selector lekérdezése
        local uhf_channel_selector = GetDevice(0):get_argument_value(2032)
        file:write(" uhf_channel_selector: " .. uhf_channel_selector .. "\n")
        
        -- Mode Selector lekérdezése
        local uhf_mode_selector = GetDevice(0):get_argument_value(2033)
        file:write(" uhf_mode_selector: " .. uhf_mode_selector .. "\n")
        
        -- Volume Selector lekérdezése
        local uhf_volume_selector = GetDevice(0):get_argument_value(2031)
        file:write(" uhf_volume_selector: " .. uhf_volume_selector .. "\n")
		
		local show_channel_freq = GetDevice(0):get_argument_value(8115)
        file:write(" show_channel_freq: " .. show_channel_freq .. "\n")
		
		local bright = GetDevice(0):get_argument_value(2027)
        file:write(" bright: " .. bright .. "\n")
		if bright ~= oldBright then
			if _G.socket_inhibit == false then
				_G.socket_inhibit = true
				--xsocket.try(x:send(string.format("2=%s,", bright)))
				_G.socket_inhibit = false
			end
		oldBright = bright
		end
		
		local Function = GetDevice(0):get_argument_value(2034)
		file:write(" function: " .. Function .. "\n")

		if Function ~= oldFunction then
			if Function == 0 then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("3=%s,", Function)))
					_G.socket_inhibit = false
				end
			end
			oldFunction = Function
		end
		
		local test = GetDevice(0):get_argument_value(2027)
        file:write(" test: " .. test .. "\n")
		if test ~= old_test then
			if test == 1 then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("4=%s,", test)))
					_G.socket_inhibit = false
				end
			end
			old_test = test
		end
		
        local formatted_freq_159 = freq_159
		
			if uhf_mode_selector == 0 and show_channel_freq == 0 then
			
				if chan159inh == true then
					if _G.socket_inhibit == false then
						_G.socket_inhibit = true
						xsocket.try(x:send(string.format("10=0,")))
						chan159inh = false
						_G.socket_inhibit = false
					end
				end
			
				if korrekcio_flag == 1 and uhf_channel_selector < 0.9 then
					uhf_channel_selector = uhf_channel_selector + 1
					fentisav = 1
				elseif korrekcio_flag == 0 and uhf_channel_selector > 0.9 and fentisav == 0 then
					korrekcio_flag = 1	
					
				elseif fentisav == 1 and uhf_channel_selector > 0.9 then
					korrekcio_flag = 0
					
				elseif fentisav == 1 and uhf_channel_selector < 0.9 then
					fentisav = 0
				end
				
				local channel_value = math.floor(uhf_channel_selector * 12 + 0.5)
				

					 if channel_value ~= old_channel_value then
						local change = channel_value - old_channel_value
							
						if change == 19  then
							freki = 0.00001
						elseif change == -19 then
							freki = 0.00020
						elseif (change == 1 or change == -1) and (channel_value >= 0 and channel_value <= 19) then 
							freki = freki + (change * 0.00001)
							--file:write("change " .. change .. "\n")
						end

					end
					old_channel_value = channel_value

				formatted_freq_159 = string.format("%.5f", freki)

			elseif chan159inh == false then	
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("10=1,")))
					chan159inh = true
					_G.socket_inhibit = false
				end
			end
			
		if test == 1 or Function == 0 then 
		blokkolas159 = true
		end
		
		if blokkolas159 == true and test~= 1 and Function ~= 0 then
			if _G.socket_inhibit == false then
				_G.socket_inhibit = true
				xsocket.try(x:send(string.format("1=%s,", formatted_freq_159)))
				blokkolas159 = false
				_G.socket_inhibit = false
			end
		end
		
        file:write("ok...kiküldött frekvencia üzenet: 1=" .. formatted_freq_159 .. ",\n") -- fájlba írás
		if _G.socket_inhibit == false then
			_G.socket_inhibit = true
			if test ~= 1 and Function ~= 0 and old_formatted_freq_159 ~= formatted_freq_159 then
			xsocket.try(x:send(string.format("1=%s,", formatted_freq_159))) -- x socketre küldés
			old_formatted_freq_159 = formatted_freq_159
			end
			_G.socket_inhibit = false
		end
		
        file:write("ok...ARC 159 Radio export completed.\n")
        file:close()
    end
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
		export_Arc159_display()
		last_run_time = current_time
		end

		if prev_next_frame then
			prev_next_frame()
		end
	end
end

