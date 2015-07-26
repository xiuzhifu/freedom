--[[
	1 技能书
]]
local damageflow = require "damageflow"

local NECKLACE = 1
local LEFTRING = 2
local RIGHTRING = 3
local SHOE = 4
local BELT = 5
local HELMET = 6
local DRESS = 7
local WEAPON = 8
	
local item_conf = {
	NECKLACE = 1,
	LEFTRING = 2,
	RIGHTRING = 3,
	SHOE = 4,
	BELT = 5,
	HELMET = 6,
	DRESS = 7,
	WEAPON = 8,
	['exp1'] = { -- type = 0 is direct use item like exp and gold
		type = -1,
		subtype = 1,
		experience = function()
			return 100
		end,
		howtouse = 'getexp'
	},
	['exp2'] = {
		type = -1,
		subtype = 2,
		experience = function(lv)
			return 100 + lv * 10
		end,
		howtouse = 'getexp'
	},	
	['exp3'] = {
		type = -1,
		subtype = 2,
		experience = function(lv)
			return 100 + math.random(1, 100)
		end,
		howtouse = 'getexp'
	},	
	["暴击术"] = {
		type = 1,
		subtype = 1,
		name = "暴击术",
		howtouse = "spellbook",
		explanation = "对敌人造成200%基础攻击力伤害",
		need = {
			level = 10,
			job = 1 + 2 + 4 + 8,
		},
		magic = {
			id = 1,
			level = 1,
			maxlevel = 10,
			needmp = 20,
			currlevelexp = 0,
			nextlevelexp = 0,
			getnextlevelexp = function(level)
				return 200 + level * 100
			end,
			damage = function(owner, lv)
				return damageflow.criticalmaigc, owner.attri.physicaldamage * (lv + 1)
			end
		}
	},
	["C4"] = {
		type = 1,
		subtype = 2,
		name = "C4",
		howtouse = "spellbook",
		explanation = "对敌人造成超高爆炸伤害",
		need = {
			level = 10,
			job = 1 + 2 + 4 + 8,
		},
		magic = {
			id = 2,
			level = 1,
			maxlevel = 10,
			needmp = 20,
			currlevelexp = 0,
			nextlevelexp = 0,
			getnextlevelexp = function(level)
				return 200 + level * 100
			end,
			damage = function(owner, lv)
				return damageflow.c4, owner.attri.physicaldamage * 5
			end
		}
	},
	["布衣(男)"] = {
		type = 2,
		subtype = 1,
		id = 2,
		position = DRESS,
		howtouse = "equipment",
		name = '布衣(男)',
		job = 0,
		need = {
			level = 3,
			job = 1 + 2 + 4 + 8,
		},
		hp = 100
	},
	["小木棍"] = {
		type = 2,
		subtype = 2,
		id = 2,
		position = WEAPON,
		howtouse = "equipment",
		name = '小木棍',
		job = 0,
		need = {
			level = 3,
			job = 1 + 2 + 4 + 8,
		},
		physicaldamage = 100
	},
}

return item_conf