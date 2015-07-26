local skynet = require "skynet"
local fightscene_conf = require "fightscene_conf"

skynet.start(function()
	for i=1,#fightscene_conf do
		skynet.newservice("fightscene", i)
	end
end)






