local monster = require "monster"
local player = require "player"
local damageflow = require "damageflow"


local master = player.new(1)
master.attri.criticalrate = 60
master.attri.criticaldamage = 200
master.name = "主角"
local  mon  = monster.new("monster1")
mon.name = "小怪"
local df = {} 

while master:isalive() and mon:isalive() 
do
	print(master.attri.hp, mon.attri.hp)
	master:fight(mon, df)
	mon:fight(master, df)
end

if not mon:isalive() then
	local drop = mon:get_drop()
end

local actors = {[master.id] = master, [mon.id] = mon}
for i,v in ipairs(df) do
	print(actors[v.src].name.." 对 "..actors[v.dest].name.."使用".. 
		damageflow.get_damage_name(v.type).."造成"..v.damage..damageflow.get_damage_type(v.type))
end

local drop = mon:get_drop()
if drop then
	for _,v in ipairs(drop) do
		master:addtobag(v)
	end
end

local skynet = require "skynet"
skynet.start(function()
	skynet.abort()
end)