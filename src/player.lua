local actor = require "actor"
local game_utils = require "game_utils"
local damageflow = require "damageflow"
local player_conf = require "player_conf"
local player_upgradeexp_conf = require "player_upgradeexp_conf"
local damageflow = require "damageflow"

local player = {}
player.__index = player

setmetatable(player, actor)

function player.new(id)	
	local t = actor.new()
	t.spellmagicorder = {}
	t.currentspellmagicorder = 1
	t.bag = {}--包裹
    t.equipments = {}--装备
	if id and player_conf[id] and player_upgradeexp_conf[id] then 
		game_utils.copy_attri(t.attri, player_conf[id])
		t.attri.nextexperience = player_upgradeexp_conf[id][t.attri.level]
	end	
	setmetatable(t, player)	
	return t
end

function player:clone( )
	local t = player.new()
	t.currentspellmagicorder = self.currentspellmagicorder
	t.magics = self.magics
	t.bag = self.bag
	t.equipments = self.equipments
	t.spellmagicorder = self.spellmagicorder
	t.id = self.id
	t.name = self.name
	game_utils.copy_attri(t.attri, self.attri) 
	return t
end

function player:upgrade(exp)
	if self.attri.level >= player_upgradeexp_conf[self.attri.job].max then
		print(self.name..'已经升级到最高级，不再获得经验')
		return
	end
	print(self.name..' 获得 '..tostring(exp)..' exp.')
	self.attri.currentexperience = self.attri.currentexperience + exp
	if self.attri.currentexperience >= self.attri.nextexperience then
		self.attri.level = self.attri.level + 1
		self.attri.nextexperience = player_upgradeexp_conf[self.attri.job][self.attri.level]
		self.attri.currentexperience = 0
		print(self.name..'升级到'..tostring(self.attri.level)..'级')
		return true
	else
		return false
	end
end

function player:addtobag(item)
	if item then
   		self.bag[item.id] = item
	end
end

function player:delfrombag(itemid)
	if self.bag[itemid] then
		self.bag[itemid] = nil
	end
end

function player:add_equipment(equipment)
    equipment:add_attri(self)
    self.equipments[equipment.position] = equipment
end

function player:del_equipment(equipment)
    equipment.del_attri(self)
    self.equipments[equipment.position] = nil
end

function player:have_equipment(position)
	if self.equipments[position] then
		return true
	else
		return false
	end
end

function player:set_spell_magic_order(magicid, order)
	if self:get_magic(magicid) then
		if order then
			table.insert(self.spellmagicorder, order, magicid)
		else
			table.insert( self.spellmagicorder, magicid)
		end
		self:reinitspellmagic()
		return true
	end
	return false
end

function player:getmagicdamage(nextmagic)
	local magicid = self.spellmagicorder[self.currentspellmagicorder + 1]
	if nextmagic then
		self.currentspellmagicorder = (self.currentspellmagicorder + 1) % #self.spellmagicorder 
	end
	if magicid then
		return self:spell_magic(magicid)
	else
		return damageflow.none
	end
end

function player:reinitspellmagic()
	self.currentspellmagicorder = 0
end

function player:fight(target, df)
	local damagetype, damage = self:getmagicdamage(true)
	if damagetype ~= damageflow.none then
		damage = target:beingspelldamage(damage)
		damageflow.add(df, damagetype, self.id, target.id, damage)
	else
		actor.fight(self, target, df)
	end
end


return player