
local default_output_file = nil
local tipus_beallitva = false
local socket_game_time = socket_game_time or 0
local futtatas = 0.01

  local file = io.open(lfs.writedir() .. "Logs/socket.log", "w")
  file:write("ok...socket.log sikeresen létrehozva\n")

  package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
  package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"
  xsocket = require("socket")
  xhost = "127.0.0.1"
  xport = 5335
  x = xsocket.try(xsocket.connect( xhost, xport))
  x:setoption("tcp-nodelay",true)
  
  
  if x then
    file:write("ok...socket port sikeresen beállítva\n")
    else
    file:write("fail...socket port megnyitása sikertelen\n")
    end


function LuaExportStart()

  _G.socket_inhibit = false
	
    aircraft  = LoGetObjectById(LoGetPlayerPlaneId()) 

    if aircraft then
        if x then
            xsocket.try(x:send("type=" .. aircraft.Name .. ","))
            file:write("ok...aircraft name sikeresen beállítva\n")
			file:write("ok...repült típus: " .. aircraft.Name .. "\n")
        else
			file:write("fail...aircraft name valtozót nem sikerült elküldeni\n")
        end
	  
		if aircraft.Name == "Mi-24P" then
			pcall(function()
			dofile(lfs.writedir()..[[Scripts\Mi24WP.lua]])  --Mi-24P
			end)
		end
		
		if aircraft.Name == "F-14B" or aircraft.Name == "F-14A-135-GR" then --F-14A-135-GR
			pcall(function()
			dofile(lfs.writedir()..[[Scripts\ARC159.lua]])
			end)

			pcall(function()
			dofile(lfs.writedir()..[[Scripts\ARC182.lua]])
			end)
		end

    else
		file:write("fail...aircraft változó nem ad vissza értéket\n")
    end
	
	
	file:write("ok...Panelek Lua scriptjei importálva\n")

end

function LuaExportStop()
    xsocket.try(x:send("quit=")) 
    x:close()
    file:close()
end

function LuaExportActivityNextEvent(t)
	local tNext = t
  
     _G.shared_game_time = tNext   -- Globális változóba mentés
	
	tNext = tNext + futtatas
	return tNext
end
