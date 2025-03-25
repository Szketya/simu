--local gombosBRT = gombosBRT or false
--local gombosBRTbeallitva = gombosBRTbeallitva or false
local old_channe182l_value = old_channe182l_value or 0
local final_channel_selector182 = new_channel_selector182 or 0
local change_channel_selector182 = change_channel_selector182 or 0
local modifier_channel_selector182 = modifier_channel_selector182 or 0
local old_channel_selector182 = old_channel_selector182 or 0
local freki182 = 0.00001
local chan182inh = chan182inh or false
local old182Bright = old182Bright or 0
local old182Function = old182Function or 0
local test182 = 0
local blokkolas = false
local last_run_time = 0.2
local old_formatted_freq_182 = ""
local file

local function export_Arc182_display()
	
	--if gombosBRT == true and gombosBRTbeallitva == false then
	--xsocket.try(x:send("5=1,"))
	--gombosBRTbeallitva = true
	--end

	file = io.open(lfs.writedir() .. "Logs/ARC182.log", "w")
	file:write(logMessage .. "\n")		

    if file then
        -- Kezdő üzenet írása
        file:write("ok...Starting ARC 182 radio export.\n")   

        -- UHF ARC-182 frekvencia lekérése
        local arc_182 = GetDevice(4)

		if arc_182 then
			file:write("ok...ARC-182 (device4) beolvasva\n")
		else
			file:write("fail...ARC-182 (device4) nem létezik\n")
		end

        local freq_182 = arc_182:get_frequency()

		if freq_182 == "nan" then 
			file:write("fail...arc_182:getfrequency nem ad vissza értéket\n") 
		else
			file:write("ok...ARC-182 frekciája sikeresen lekérve\n")
		end

		file:write("ok...freq_182 változó értéke: " .. freq_182 .. "\n")
		--freq_182 = string.sub(freq_182, 1, 6)
		freq_182 = tonumber(freq_182)
		
		freq_182 = math.floor(freq_182/1000 + 0.5)

		if GetDevice(0) then
			file:write("ok...kapcsoló állapotok (Device0) sikeresen beolvasva.\n státuszok:\n")
		else
			file:write("fail...kapcsoló állapotok (device0) beolvasása sikertelen\n")
		end
  
        -- Channel Selector lekérdezése
        local channel_selector182 = GetDevice(0):get_argument_value(352)
        file:write(" channel_selector182: " .. channel_selector182 .. "\n")
        
        -- Mode Selector lekérdezése
        local mode_selector182 = GetDevice(0):get_argument_value(353)
        file:write(" mode_selector182: " .. mode_selector182 .. "\n")
        
		
		local bright182 = GetDevice(0):get_argument_value(360)
        file:write(" bright182: " .. bright182 .. "\n")
		if bright182 ~= old182Bright then
			if _G.socket_inhibit == false then
				_G.socket_inhibit = true
				--xsocket.try(x:send(string.format("7=%s,", bright182)))
				_G.socket_inhibit = false
			end
		old182Bright = bright182
		end
		
		local Function182 = GetDevice(0):get_argument_value(358)
        file:write(" Function182: " .. Function182 .. "\n")
		if Function182 ~= old182Function then
			if Function182 == 0 then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("8=%s,", Function182)))
					_G.socket_inhibit = false
				end
			end
			
			if Function182 == 1 then 
			test182 = 1
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("9=%s,", test182)))
					_G.socket_inhibit = false
				end
			else 
			test182 = 0
			end
			old182Function = Function182
		end
		
		
		-- A frekvencia formázása 3 tizedesjegyig
        local formatted_freq_182 = freq_182
		
			local epsilon = 0.0001 -- Tolerancia értéke
			if math.abs(mode_selector182 - 0.6) < epsilon then
			
				if chan182inh == true then
					if _G.socket_inhibit == false then
						_G.socket_inhibit = true
						xsocket.try(x:send(string.format("11=0,")))
						_G.socket_inhibit = false
					end
				chan182inh = false
				end
			
			change_channel_selector182 = channel_selector182 - old_channel_selector182
			
				if change_channel_selector182 < -0.5 then 
					modifier_channel_selector182 = modifier_channel_selector182 + 1
					
					
				elseif change_channel_selector182 > 0.5 then 
					modifier_channel_selector182 = modifier_channel_selector182 - 1
				end
				final_channel_selector182 = modifier_channel_selector182 + channel_selector182
				old_channel_selector182 = channel_selector182
				
				
				local channel_value182 = math.floor(final_channel_selector182 * 12 + 0.5)
				file:write(" final_channel_selector182 " .. final_channel_selector182 .. "\n")

					 if channel_value182 ~= old_channe182l_value then
						local change = channel_value182 - old_channe182l_value
							
						if change == 29  then
							freki182 = 0.00001
						elseif change == -29 then
							freki182 = 0.00030
						elseif (change == 1 or change == -1) and (channel_value182 >= 0 and channel_value182 <= 29) then 
							freki182 = freki182 + (change * 0.00001)
							--file:write("change " .. change .. "\n")
							old_channe182l_value = channel_value182 -- Mindkét ágban frissül
						end

					end

				formatted_freq_182 = string.format("%.5f", freki182)

				
			elseif chan182inh == false then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("11=1,")))
					_G.socket_inhibit = false
				end
				chan182inh = true
			end
		
		if type(formatted_freq_182) == "number" and formatted_freq_182 < 100000 then
			formatted_freq_182 = "0" .. formatted_freq_182
		end	
		
		if test182 == 1 or Function182 == 0 then 
		blokkolas = true
		end
		
		if blokkolas == true and test182 ~= 1 and Function182 ~= 0 then
			if _G.socket_inhibit == false then
				_G.socket_inhibit = true
				xsocket.try(x:send(string.format("6=%s,", formatted_freq_182)))
				_G.socket_inhibit = false
			end
		blokkolas = false
		end
		
		
			if test182 ~= 1 and Function182 ~= 0 and old_formatted_freq_182 ~= formatted_freq_182 then
				if _G.socket_inhibit == false then
					_G.socket_inhibit = true
					xsocket.try(x:send(string.format("6=%s,", formatted_freq_182))) -- x socketre küldés
					_G.socket_inhibit = false
				end
			old_formatted_freq_182 = formatted_freq_182
			end
        
        -- Debug üzenet a teszt befejezéséhez
        file:write("ok...Radio export ARC182 completed.\n")
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
			logMessage = "ok...shared game time:" .. current_time
		end		

		if current_time > last_run_time then
		export_Arc182_display()
		last_run_time = current_time
		end

		if prev_next_frame then
			prev_next_frame()
		end
	end
end
