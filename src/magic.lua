local magic = {}
magic.__index = magic
local item_conf = require "item_conf"

function magic.new(name)
	assert(item_conf[name])
	local tmagic = item_conf[name].magic
	if tmagic then
		local t = setmetatable({}, magic)
		for k,v in pairs(tmagic) do
			t[k] = v
		end
		return t
	end
	return nil
end

function magic:spell(player)
	return self.damage(player, self.level)
end

return magic