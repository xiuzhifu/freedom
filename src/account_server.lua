local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local redis = require "redis"
local sproto = require  "sproto"

local  REQUEST = {}
local host
local send_request
local db
local gate

function db_call(cmd, ...)
	return db[cmd](db, ...)
end

local function auth(username, password)
	local name = "account."..username   
	local id = db_call("get", name) 
	if id then 
		local pw = db_call("get",name.."."..id..".password")
		if password == pw then return id end
	end
	return false
end

local function new_account(name, password)
	local account = "account."..name
	local ok = db_call("exists", account)
	if not ok then
		local id = db_call("incr", "account.count")
		db_call("set", account, id)
		db_call("set", account.."."..id..".password", password)
		db_call("rpush", "account.userlist", id)
		return true
		
	else
		return false
	end
end
local account_server = {}
function account_server.start(g, proto)
	host = sproto.new(proto.c2s):host "package"
	send_request = host:attach(sproto.new(proto.s2c))
	gate = g
end

function account_server.open(fd)
	skynet.call(gate, "lua", "forward", fd, fd)
end

function REQUEST:createaccount()
	print("createaccount", self.username, self.password)
	local r = new_account(self.username, self.password)
	if r then
		return {ok = true}
	else
		return {ok = false}
	end
end

function REQUEST:login()
	print("login", self.username, self.password)
	local r = auth(self.username, self.password)
	if r then
		print(self.fd, r)
		skynet.call("watchdog", "lua", "startagent", {fd = self.fd, id = r})	
		print("login ok ")
		return { ok = true, id = r}
	else
		print("login fail ")
		return { ok = false}
	end
end

local function request(name, args, response, session)
	local f = assert(REQUEST[name])
	args.fd = session
	local r = f(args)
	if response then
		return response(r)
	end
end

local function send_package(fd, pack)
	local size = #pack
	print(size, "size.........")
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack
	socket.write(fd, package)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return host:dispatch(msg, sz)
	end,
	dispatch = function (session, source, type, name, args, response)
		print(name)
		if type == "REQUEST" then
			local result  = request(name, args, response, source)
			if result then
				send_package(source, result)
			else
				skynet.error(result)
			end
		else
			assert(type == "RESPONSE")
			error "This example doesn't support request client"
		end
	end
}

skynet.start(function()
	skynet.dispatch("lua", function(_, _, cmd, ...)
		local f = assert(account_server[cmd])
		if f then f(...) end 
	end)
	db = redis.connect({
		host = "127.0.0.1" ,
		port = 6379 ,
		db = 0
	})
		
	local ok  = db:exists("account.count")
	if not ok then 
		db:set( "account.count", "0")
	end
	print("start account server ok")
	skynet.register "account_server"
end)
