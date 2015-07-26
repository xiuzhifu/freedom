package.cpath = "./../skynet/luaclib/?.so"
package.path =package.path.. ";./../skynet/lualib/?.lua;"

local socket = require "clientsocket"
local bit32 = require "bit32"
local proto = require "proto"
local sproto = require "sproto"
local damageflow = require "damageflow"

local player = nil
local mon = nil
local df = nil

local sessionpool = {}

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local fd = assert(socket.connect("127.0.0.1", 8888))

local function send_package(fd, pack)
	local size = #pack
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack

	socket.send(fd, package)
end

local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end

local function recv_package(last)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local r = socket.recv(fd)
	if not r then
		return nil, last
	end
	if r == "" then
		error "Server closed"
	end
	return unpack_package(last .. r)
end

local session = 0

local function send_request(name, args, func)
		session = session + 1
		sessionpool[session] = func
		local str = request(name, args, session)
		send_package(fd, str)
end

local last = ""
local server = {}
local back = {
	black = 40,
	red = 41,
	green = 42,
	yellow = 43,
	blue = 44,
	purple = 45,
	deepgreen = 46,
	white = 47
}

local frontcolor = {
	black = 30,
	red = 31,
	green = 32,
	yellow = 33,
	blue = 34,
	purple = 35,
	deepgreen = 36,
	white = 37
}

function printcolor(s, frontcolor, backcolor)
	print('\x1B[40'..tostring(backcolor)..';'..tostring(frontcolor)..'m'..s..'\x1B[0m')
end

function printred(...)
	printcolor(table.concat({...}, " "), frontcolor.red, back.black)
end

function printblue(...)
	printcolor(..., frontcolor.blue, back.white)
end

function printyellow(...)
	printcolor(..., frontcolor.yellow, back.red)
end

function printgreen(...)
	printcolor(..., frontcolor.green, back.red)
end

function server:drop()
	printred('get exp:',self.exp)
	print("get gold: ", self.gold)
	if not self.items then return end
	for i,v in ipairs(self.items) do
		printyellow('get item :'..v.name..'  count:'..tostring(v.count))
	end
end

function server:sysmessage()
	printred(self.msg)
end
local function print_request(name, args)
	local f = server[name]
	if f and args then
		f(args)
	end
end

local function print_response(session1, args)
	if (sessionpool[session1]) then
		sessionpool[session1](args)
		sessionpool[session1] = nil
	end
end

local function print_package(t, ...)
	if t == "REQUEST" then
		print_request(...)
	else
		assert(t == "RESPONSE")
		print_response(...)

	end
end

local function dispatch_package()
	while true do
		local v
		v, last = recv_package(last)
		if not v then
			break
		end

		print_package(host:dispatch(v))
	end
end
local wait1 = 0
function wait()
	while wait1 == 0 do
		socket.usleep(100)
		dispatch_package()
	end
	wait1 = 0
end

function notwait()
	wait1 = 1
end
function createaccount()
	send_request("createaccount", { username = "空气", password = "iloveyou" }, function(args)
		notwait()
		login()
	end)
	wait()
end

function login()
	send_request("login", { username = "空气", password = "iloveyou" }, function(args)
		notwait()
		if not args.ok then createaccount() end 
	end)
	wait()
end

function createplayer()
send_request("createplayer", { username = "空气", job = 1}, function (args)
		if args.id > 0 then print "create actor succeed" end
		notwait()
	end)
	wait()
end

function getplayerinfo()
	send_request("getplayerinfo", {}, function (args)
		if args.ok then 
			print("getplayerinfo ok")
			player = args.player
		else
			createplayer()
			getplayerinfo()
		end
		notwait()
	end)	
	wait()	
end

function getfightround()
	send_request("getfightround", {}, function (args)
		mon = args.monster
		df = args.damageflow
		notwait()
	end)	
	wait()
end

login()
getplayerinfo()
socket.usleep(1000 * 1000 * 5)
getfightround()
while true do
	dispatch_package()
	if player and mon then
		printred(player.name..'属性:  level  '..tostring(player.level)..'  exp.  '..tostring(player.currentexperience)..
			"  nextexp.  "..tostring(player.nextexperience))
		local actors= {}
		actors[player.id] = player
		for i,v in ipairs(mon) do
			actors[v.id] = v
		end
		
		for i,v in ipairs(df) do
			printblue(actors[v.src].name.."(hp: "..tostring(actors[v.src].hp)..")".." 对 "..
				actors[v.dest].name.."(hp: "..tostring(actors[v.dest].hp)..")".."使用"..
		damageflow.get_damage_name(v.type).."造成"..v.damage..damageflow.get_damage_type(v.type))
			actors[v.dest].hp = actors[v.dest].hp - v.damage
			if actors[v.dest].hp <= 0 then 
				printblue(actors[v.dest].name.."死亡")
			socket.usleep(1000 * 1000)
			end
		end
		print("休息:"..tostring(player.fightrate).."秒")
		
		player = nil
		mon = nil
		df = nil
		getplayerinfo()
		getfightround() 
	end
	local s = player.fightrate
	while s ~= 0 do
		socket.usleep(1000 * 1000)
		printgreen("剩余:"..tostring(s).."秒")
		dispatch_package()
		s = s - 1
	end
	--[[
	local cmd = socket.readstdin()
	if cmd then
		send_request("get", { what = cmd })
	else
		socket.usleep(100)
	end
	]]
end
