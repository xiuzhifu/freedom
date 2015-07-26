--[[
gen_drop_loot.lua 根据 gen_drop_conf.lua的配置动态生成概率判断代码编译
可通过打印gen_drop_loot_code变量查看生成的代码
]]
local drop_loot = (require "gen_drop_loot")()
return drop_loot

