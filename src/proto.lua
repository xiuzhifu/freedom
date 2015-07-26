local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

.tplayer {
	id 0 : integer
	name 1 : string
	job 2 : integer
	level 3 : integer
	currentexperience 4 : integer
	nextexperience 5 : integer
	hp 6 : integer
	mp 7 : integer
	hprate 8 : integer
	mprate 9 : integer
	criticaldamage 10 : integer
	criticalrate 11 : integer
	physicaldamage 12 : integer
	spelldamage 13 : integer
	attactspeed 14 : integer
	magicalresistance 15 : integer
	armor 16 : integer

	fightrate 17: integer
}
.tdamageflow {
	type 0: integer
	src 1: integer
	dest 2: integer
	damage 3: integer
}

.tmonster {
	id 0: integer
	name 1: string
	level 2: integer
	hp 3: integer
	mp 4: integer
}

login 1 {
	request {
		username 0 : string
		password 1 : string
	}
	response {
		ok 0 : boolean
	}
}

createaccount 2 {
	request {
		username 0 : string
		password 1 : string
	}
	response {
		ok 0 : boolean
	}
}

createplayer 3 {
	request {		
		username 0: string
		job 1: integer
	}
	response {
		id 0: integer
	}
}

getplayerinfo 4 {
	request {
	}
	response {
		ok 0: boolean
		player 1: tplayer
	}
} 

changescene  5 {
	request {
		sceneid 0: integer
	}
	response {
		ok 0: boolean
	}
}

getfightround  6 {
	request {
		id 0: integer
	}
	response {
		monster 0: *tmonster
		damageflow 1: *tdamageflow
	}
}

]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

.titem {
	id 0: integer
	name 1: string
	count 2: integer
}

sysmessage 1 {
	request {
		msg 0: string
	}
}

drop 2 {
	request {
		exp 0: integer
		gold 1: integer
		items 2: *titem
	}
}

]]
--[[
local f = io.open("proto.txt", "w")
f:write(proto.c2s)
f:close()
]]
return proto
