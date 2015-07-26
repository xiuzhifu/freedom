local actor = require "actor"
local drop_loot = require "drop_loot"
local item = require "item"
local monster_conf = require "monster_conf"
local game_utils = require "game_utils"
local logger = require "logger"

local monster =  {monstercount = 0}
monster.__index = monster
setmetatable(monster, actor)

function monster.new(id)
	local t  =  actor.new()
	monster.monstercount = monster.monstercount + 1
	t.id = - monster.monstercount 
	setmetatable(t, monster)
	if id and monster_conf[id] then 
		game_utils.copy_attri(t.attri, monster_conf[id]) 
		t.drop = monster_conf[id].drop
	end
	return t
end

function monster:clone( )
	local t = monster.new()
	t.drop = self.drop
	monster.monstercount = monster.monstercount + 1
	t.id = - monster.monstercount 
	t.name = self.name 
	game_utils.copy_attri(t.attri, self.attri) 
	return t
end

function monster:set_default_attri(id)
	if id == 1 then
		if not self.attri.level then return end
		self.attri.hp = self.attri.hp * self.attri.level
	end
end

function monster:get_drop(items)
	local loot = self.drop 
	if loot then
		local goods = drop_loot["get_"..loot]()
		if goods then
			local t
			if items then
				t = items
			else
				t = {}
			end
			for _,v in ipairs(goods) do
				local it = item.new(v)
				if it then
					table.insert(t, it)
				else
					logger.log("do not have "..v.." item in item_conf")
				end
			end
			return t
		end
	end
end

return monster



