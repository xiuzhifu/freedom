local game_utils = {
	
}

function game_utils.add_attri(actor, attri)
	if attri.hp then actor.hp = actor.hp + attri.hp end--体力值
    if attri.mp then actor.mp = actor.mp + attri.mp end--魔法值
   	if attri.hprate then actor.hprate = actor.hprate + attri.hprate end --每秒回血
    if attri.mprate then actor.mprate = actor.mprate + attri.mprate end --每秒回蓝
    if attri.criticaldamage then actor.criticaldamage = actor.criticaldamage + attri.criticaldamage end--暴击最高伤害
    if attri.criticalrate then actor.criticalrate = actor.criticalrate + attri.criticalrate end--暴击概率
    if attri.physicaldamage then actor.physicaldamage = actor.physicaldamage + attri.physicaldamage end--物理伤害
    if attri.spelldamage then actor.spelldamage = actor.spelldamage + attri.spelldamage end--魔法伤害
    if attri.attactspeed then actor.attactspeed = actor.attactspeed + attri.attactspeed end--攻击速度
    if attri.magicalresistance then actor.magicalresistance = actor.magicalresistance + attri.magicalresistance end--魔法抗性
    if attri.armor then actor.armor = actor.armor + attri.armor end--护甲  
end

function game_utils.del_attri(actor, attri)
	if attri.hp then actor.hp = actor.hp - attri.hp end--体力值
    if attri.mp then actor.mp = actor.mp - attri.mp end--魔法值
   	if attri.hprate then actor.hprate = actor.hprate - attri.hprate end --每秒回血
    if attri.mprate then actor.mprate = actor.mprate - attri.mprate end --每秒回蓝
    if attri.criticaldamage then actor.criticaldamage = actor.criticaldamage - attri.criticaldamage end--暴击最高伤害
    if attri.criticalrate then actor.criticalrate = actor.criticalrate - attri.criticalrate end--暴击概率
    if attri.physicaldamage then actor.physicaldamage = actor.physicaldamage - attri.physicaldamage end--物理伤害
    if attri.spelldamage then actor.spelldamage = actor.spelldamage - attri.spelldamage end--魔法伤害
    if attri.attactspeed then actor.attactspeed = actor.attactspeed - attri.attactspeed end--攻击速度
    if attri.magicalresistance then actor.magicalresistance = actor.magicalresistance - attri.magicalresistance end--魔法抗性
    if attri.armor then actor.armor = actor.armor - attri.armor end--护甲  
end

function game_utils.copy_attri(di, si, force)
	if si.level or force then di.level = si.level end--级别
    if si.job or force then di.job = si.job end--职业
    if si.hp or force then di.hp = si.hp end--体力值
    if si.mp or force then di.mp = si.mp end--魔法值
    if si.hprate or force then di.hprate = si.hprate end --每秒回血
    if si.mprate or force then di.mprate = si.mprate end --每秒回蓝
    if si.criticaldamage or force then di.criticaldamage = si.criticaldamage end--暴击最高伤害
    if si.criticalrate or force then di.criticalrate = si.criticalrate end--暴击概率
    if si.physicaldamage or force then di.physicaldamage = si.physicaldamage end--物理伤害
    if si.spelldamage or force then di.spelldamage = si.spelldamage end--魔法伤害
    if si.attactspeed or force then di.attactspeed = si.attactspeed end--攻击速度
    if si.magicalresistance or force then di.magicalresistance = si.magicalresistance end--魔法抗性
    if si.armor or force then di.armor = si.armor end--护甲  
end

return game_utils