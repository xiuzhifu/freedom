local player_conf = {
	job_count = 4,
	[1] = {--default_male_warrior
		level = 1,
		job = 1,
		hp = 2000,
		mp = 100,
		criticaldamage = 300,
		criticalrate = 30,
		physicaldamage = 200,
		magicalresistance = 20
	},
	[2] = {--default_female_warrior
	level = 1,
	job = 2,
	hp = 2000,
	mp = 889,
	physicaldamage = 80
	},
	[3] = {--default_male_magician
		level = 1,
		job = 4,
		hp = 2000,
		mp = 100,
		physicaldamage = 100
	},
	[4] = {--default_female_magician
	level = 1,
	job = 8,
	hp = 2000,
	mp = 889,
	physicaldamage = 80
	}
}

return player_conf