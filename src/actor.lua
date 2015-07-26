local buff = require "buff"
local damageflow =  require "damageflow"

local actor = {
    --[[
    level = 0;
    job = 0;
    currentexperience = 0;
    nextexperience = 0;
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
    buff = {},
    magics = {},--技能
    bag = {},--包裹
    equipments = {},--装备
    ]]
}

actor.__index = actor
function actor.new()
    local t = {}
    t.level = 0
    t.job = 0
    t.currentexperience = 0
    t.nextexperience = 0
    t.hp = 0--体力值
    t.mp = 0--魔法值
    t.hprate = 0 --每秒回血or每回合回血
    t.mprate = 0 --每秒回蓝or每回合回血
    t.criticaldamage = 0--暴击最高伤害
    t.criticalrate = 0--暴击概率
    t.physicaldamage = 0--物理伤害
    t.spelldamage = 0--魔法伤害
    t.attactspeed = 0--攻击速度
    t.magicalresistance = 0--魔法抗性
    t.armor = 0--护甲
    t.buff = {}
    t = {attri = t}
    t.name = ""
    t.magics = {}--技能
    math.randomseed(os.time())
    return setmetatable(t, actor)
end

function actor:isalive()
    return self.attri.hp > 0
end

function actor:getphysicaldamage()
    local damage = self.attri.physicaldamage
    local rate = math.random(1, 100)
    if rate <= self.attri.criticalrate then
        damage = damage + damage * self.attri.criticaldamage * rate / 10000
        return damageflow.criticaldamage, damage
    end
    return damageflow.damage, damage
end

function actor:beingphysicaldamage(damage)
    damage = damage - self.attri.armor
    self.attri.hp = self.attri.hp - damage
    return damage
end

function actor:getspelldamage()
    return self.attri.spelldamage
end

function actor:beingspelldamage(damage)
    damage = damage - self.attri.magicalresistance
    self.attri.hp = self.attri.hp - damage
    return damage
end

function actor:add_buff(buff)
    buff:start()
    buff:add_actor(self)
    table.insert(self.buff, buff)
end

function actor:check_buff(time)
    for i, v in ipairs(self.buff) do
        if v:check_bufftime(time) then
            v:del_buff()
            v = nil
        end
    end 
end

function actor:add_magic(magic)   
    if not self.magics[magic.id] then
        self.magics[magic.id] = magic
        return magic.id
    else
        return 0
    end
end

function actor:get_magic(magicid)
    return self.magics[magicid]
end

function actor:del_magic(magiclid)
    self.magics[magicid] = nil
end

function actor:spell_magic(magicid)
    local magic = self.magics[magicid]
    if magic then
        return magic:spell(self)
    else
        return damageflow.none
    end
end

function actor:fight(target, df)
    local damagetype ,damage = self:getphysicaldamage()
    if damagetype ~= damageflow.none then
	   damage = target:beingphysicaldamage(damage)
	   damageflow.add(df, damagetype, self.id, target.id, damage)
	end
end

return actor




