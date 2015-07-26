local item_conf = require "item_conf"
local game_utils = require "game_utils"
local equipment = {
totalid = 1
}
equipment.__index = equipment
--get a new equipment
function equipment.new(id)
	assert(item_conf[id])
	local t = setmetatable({}, equipment)
	t.id = equipment.totalid	
	equipment.totalid = equipment.totalid + 1
	for k,v in pairs(item_conf[id]) do
		t[k] = v
	end
	return t
end

function equipment:add_attri(actor)
	game_utils.add_attri(actor.attri, self)
end

function equipment:del_attri(actor)
	game_utils.del_attri(actor.attri, self)
end

return equipment

