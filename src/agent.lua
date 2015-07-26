local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"
local fightscene_conf = require "fightscene_conf"

local host
local send_request

local CMD = {}
local REQUEST = {}
local agent = {}
local client_fd
local playerid =  -1
local sceneid = -1
local agentid 
local fightsceneid 
local playername 

function db_call(...)
	return skynet.call("db", "lua", playerid, ...)
end

function REQUEST:getplayerinfo()
	if not fightsceneid then return {ok = false} end	
	local r = skynet.call(fightsceneid, "lua", "get_player", playerid)
	if r then
		local c = {}
		for k,v in pairs(r) do
			c[k] = v
		end
		c.name = playername

		c.id = playerid
		c.fightrate = fightscene_conf[sceneid].fight_rate
		return { ok = true ,player = c }
	else
		return { ok = false, player = {}}	
	end
end

function REQUEST:getfightround()	
	if not fightsceneid then return {} end
	local r = skynet.call(fightsceneid, "lua", "getfightround", playerid)
	return {monster = r.monster, damageflow = r.damageflow}
end

function REQUEST:createplayer()
	local name = self.username
	local job = self.job
	local l = db_call("exists", "player."..playerid)
	if l then return {id = -2} end
	fightsceneid = "fightscene1"
	sceneid = 1
	local r = skynet.call(fightsceneid, "lua", "new_player", name, job, playerid)
	if r then 
		playername = skynet.call(fightsceneid, "lua", "online", playerid, agentid)
		db_call("set", "player."..playerid, playerid)
		db_call("set", "player."..playerid..".sceneid", 1)
		return {id = playerid} 
	end
	return {id = -1}
end

function REQUEST:changescene()
	if sceneid ~= -1 then
		skynet.call(fightsceneid, "lua", "delete_player", playerid)
		skynet.call("fightscene"..tostring(self.id), "lua", "load_player", playerid)
	end
end

local function request(name, args, response)
	local f = assert(REQUEST[name])
	local r = f(args)
	if response then
		return response(r)
	end
end

local function send_package(pack)
	local size = #pack
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack

	socket.write(client_fd, package)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return host:dispatch(msg, sz)
	end,
	dispatch = function (_, _, type, ...)
		if type == "REQUEST" then
			local ok, result  = pcall(request, ...)
			if ok then
				if result then
					send_package(result)
				end
			else
				skynet.error(result)
			end
		else
			assert(type == "RESPONSE")
			error "This example doesn't support request client"
		end
	end
}

function agent.loadplayer()
	local ok = db_call("exists", "player."..playerid)
	if ok then	
		sceneid	= db_call("get", "player."..playerid..".sceneid")
		fightsceneid = "fightscene"..sceneid
		sceneid = tonumber(sceneid)
		print(fightsceneid)
		playername = skynet.call(fightsceneid, "lua", "online", playerid, agentid)
		if ok then return {id = playerid} end
	end
	print("loadplayer fail"..tostring(playerid))
	return {id = -1}
end

function agent.offline()
	local r = skynet.call(fightsceneid, "lua", "offline", playerid)
	print("offline :"..tostring(playerid))
end

function CMD.start(gate, d, proto, id)
	host = sproto.new(proto.c2s):host "package"
	send_request = host:attach(sproto.new(proto.s2c)) 
	client_fd = d.fd
	playerid =  d.id
	agentid = id
	skynet.call(gate, "lua", "forward", d.fd) 
	agent.loadplayer()
end

function CMD.exit()
	agent.offline()
end

function CMD.drop(drop)
	send_package(send_request("drop", drop))
end

function CMD.sysmessage(s)
	send_package(send_request("sysmessage",{msg = s}))
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
