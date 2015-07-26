local drop_loot_conf = require "drop_loot_conf"
return function()
	local gen_drop_loot_code = 'local drop_loot = {}\n'
	local s
	for i,v in pairs(drop_loot_conf) do
		s = 'function drop_loot.get_'..i..'()\n\tlocal ret = {} \n'
		local m, n, first, second, s1
		for k,v1 in pairs(v) do
			m, n = string.find(v1, '/')
			first = string.sub(v1, 1, m - 1)				
			second = string.sub(v1, n + 1, string.len(v1))
			s1 = '\tlocal v = math.random(1,'..second..') \n'..
			'\tif v <= ' .. first ..' then table.insert(ret, "'..k..'") end \n'
			s = s..s1
		end
		s = s..'\treturn ret\n end\n'
		gen_drop_loot_code = gen_drop_loot_code..s
	end
	gen_drop_loot_code = gen_drop_loot_code..'return drop_loot'
	--print(gen_drop_loot_code)
	return assert(load(gen_drop_loot_code))()	
end