local item = {}
item.__index = item
local useitem = {}
local item_conf = require "item_conf"
local magic = require "magic"
local equipment = require "equipment"
--local db = require "db"
local itemcount = 0
local function getid()
	itemcount = itemcount + 1
	return itemcount
--	return db:incb("item.count")
end
function item.new(name)
	local titem = item_conf[name]
	if not titem then return end
	local t = setmetatable({}, item)
	for k,v in pairs(titem) do
		t[k] = v
	end
	t.id = getid()
	return t
end
function item:use(player)
	assert(player)
	return useitem[self.howtouse](player, self)
end

function useitem.getexp(player, item)
	assert(item)
	local exp = item.experience(player.attri.level)
	player:upgrade(exp)
	return exp
end
function useitem.spellbook(player, item)
	assert(item)
	local m = magic.new(item.name)
	assert(m)
	local r = player:add_magic(m)
	if r > 0 then
		player:set_spell_magic_order(r)
		return true
	else
		return false
	end
end

function useitem.equipment(player, item)
	assert(item)
	if not player:have_equipment(item.position) then
		local e = equipment.new(item.name)
		player:add_equipment(e)
		return true
	end
	return false
end

return item