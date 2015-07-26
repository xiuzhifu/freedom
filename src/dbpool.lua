local skynet = require "skynet"
local db_conf = require "db_conf"
local redis = require "redis"
local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local dbcount = 0
local dbpool = {}

local function  createdb( )
	local dbs = {}
	function dbs.command(id, cmd, ...)
		local db = assert(dbs[id % dbcount + 1])
		return db[cmd](db, ...)
	end
		
	for i = 1, #db_conf do
		dbcount = dbcount + 1
		dbs[i] = redis.connect(db_conf[i])
	end
	return dbs
end

skynet.start(function()
	local dbpoolcount = skynet.getenv("dbpoolcount")
	local current = 1
	for i=1,dbpoolcount do		
		dbpool[i] = createdb()
	end
	skynet.register "db"
	skynet.dispatch("lua", function(session, source, ...)
		local d = dbpool[current % dbpoolcount + 1]
		current = current + 1		
		skynet.retpack(d.command(...))
	end)	
end)