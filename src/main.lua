local skynet = require "skynet"

local max_client = 64

skynet.start(function()
	print("Server start")
	local console = skynet.newservice("console")
	skynet.newservice("debug_console",8000)
	
	--pcall(skynet.newservice, "testfight")
	skynet.newservice "dbpool" --启动db 
	skynet.newservice "account_server"	
	skynet.kill(skynet.newservice "gen_fightscene")
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	print("Watchdog listen on ", 8888)
	skynet.exit()
end)
