
local skynet = require "skynet"
skynet.start(function()
	skynet.newservice "login_server"
	skynet.call("login_server", "lua", "start")
	skynet.call("login_server", "lua", "new_account", "空气", "空气")
	local ret = skynet.call("login_server", "lua", "auth", "空气", "空气")
	print(ret)
	skynet.exit()
end)