local buff_conf = require "buff_conf"
local game_utils = require "game_utils"
local buff = {
	--[[
	hp = 0,--体力值
    mp = 0,--魔法值
    hprate = 0, --每秒回血
    mprate = 0, --每秒回蓝
    criticaldamage = 0,--暴击最高伤害
    criticalrate = 0,--暴击概率
    physicaldamage = 0,--物理伤害
    spelldamage = 0,--魔法伤害
    attactspeed = 0,--攻击速度
    magicalresistance = 0,--魔法抗性
    armor = 0,--护甲  
    time = 0--持续时间
	]]
}

local bufflist =  {}

function buff.new(buff1)
	if not buff1 then return nil end
	local t = {
	buff = buff1,--buff 
    starttime = 0,--开始时间
    actor = nil
    }
	setmetatable(t, buff)
	return t
end

function buff:start(time)
	self.starttime = time
end

function buff:check_bufftime(time)
	if self.starttime + self.buff.time >= time then
		return true
	else
		return false
	end
end

function buff:add_buff(actor)
	self.actor = actor
    game_utils.add_attri(actor.attri, self.buff) 	 
end

function buff:del_buff()
    game_utils.del_attri(self.actor.attri, self.buff) 
end

return buff


