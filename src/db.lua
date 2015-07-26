local db_conf = require "db_conf"
local redis = require "redis"
local skynet = require "skynet"

local dbs = {}
local dbcount = 0
function dbs.command(id, cmd, ...)
	local db = assert(dbs[id % dbcount + 1])
	return db[cmd](db, ...)
end

for i = 1, #db_conf do
	dbcount = dbcount + 1
	for i,v in ipairs(db_conf[i]) do
		print(i,v)
	end
	dbs[i] = redis.connect(db_conf[i])
end

return dbs