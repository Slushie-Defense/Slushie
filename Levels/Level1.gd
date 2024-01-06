extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var wm = $WaveManager	
	var curGroup
	var curWave
	
	#Finalized Waves will have a description
	
	"""
	Wave 1 - Machine Gun Fodder
	Learning:
		Best to put the machine gun (only turret you can afford) in between two portals
		Machine gun will take damage unless you distract the monsters somewhat
		Grunt spawns at the end to give you an idea of how much tougher it is
	"""
	curWave = Wave.new(false, true, true, false, false);
	curWave.description = "I hear something to the east..."
	curWave.appendGroup(20, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(10, 0, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 1, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 2 - Fodder and Grunts Trickle In
	Goal: 
		Rush of fodder and grunts at the same time
	Learning:
		Player may have to build turret during wave, or distract enemies to avoid turret damage
	"""
	curWave = Wave.new(false, true, true, true, false);
	curWave.description = "Is it just me or are there more portals?"
	curWave.appendGroup(6, 0, 0, 0, 0, 3, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 6, 0, 0, 0, 0, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(6, 6, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 3 - Tank Intro
	Goal: 
		Tanks shortly followed by grunts. Two waves of this.
	Learning:
		Player can win with just basic turrets, but 1 cannon can help signfiicantly
	"""
	curWave = Wave.new(false, true, true, true, false);
	curWave.description = "There's something really big coming..."
	curWave.appendGroup(0, 0, 0, 2, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 6, 0, 0, 0, 3, 3, GroupSpawn.spawn_type.ALL_AT_ONCE)	
	curWave.appendGroup(0, 0, 0, 2, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 6, 0, 0, 0, 3, 3, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 4 - Infantry Squad
	Goal: 
		Strengthen defenses for a large group of grunts, fodder, and tanks
	Learning:
		Time for player to kill stuff and earn some money, try to minimize damage.
		Finishes off with a group of floaters where player learns they need rapid fire
	"""
	curWave = Wave.new(false, true, true, true, false);
	curWave.description = "Sounds like a stampede..."
	curWave.appendGroup(0, 0, 0, 3, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(12, 0, 0, 0, 0, 2, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 12, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 0, 0, 0, 24, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 5 - Shield Break
	Goal: 
		A tank and a quick number of grunts appear from two of the extreme ends
		Optimal defense up to this point should be centered, so this will require adaptation
		Player can build more turrets, or put a single shield up to stall
	Learning:
		If player uses, shield, they'll see the benefit of its tankiness
		Both options work at this point, since firepower is high
		Either option player realizes importance of watching portal locations
	"""
	curWave = Wave.new(false, false, false, true, true);
	curWave.description = "Did those portals move?"
	curWave.appendGroup(0, 0, 0, 6, 0, 5, 2, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 24, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 6 - Seige Intro
	Goal: 
		Short wave to demonstrate the power of seige enemies
	Learning:
		No particular strat, just to learn that seige enemies exist
	"""
	
	curWave = Wave.new(false, true, false, true, false);
	curWave.description = "What the heck is that?"
	curWave.appendGroup(0, 12, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 0, 4, 0, 0, 3, 2, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 7 - Shock Troop
	Goal: 
		Wave of everything
	Learning:
		A bit of everything to deal with, in a strategic order to destroy Steve
	"""
	
	curWave = Wave.new(true, true, false, true, true);
	curWave.description = "I see all kinds of problems coming."
	curWave.appendGroup(0, 0, 0, 12, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(12, 12, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(0, 0, 8, 0, 0, 3, 2, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 0, 0, 0, 24, 3, 2, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 8 - Money Wave
	Goal: 
		Bit of everything again, but with all portals. Meant to earn lots of
		money so you can load up your defenses. Will be a bit easier, but feel
		chaotic beacuse all the portals are spewing foes.
	Learning:
				
	"""
	
	curWave = Wave.new(true, true, true, true, true);
	curWave.description = "This is easy, ol Steve's got this."
	curWave.appendGroup(5, 5, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(0, 0, 0, 0, 10, 3, 1, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(20, 20, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(0, 0, 0, 0, 20, 3, 0.5, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(0, 5, 0, 0, 0, 0, 0.5, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 0.5, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(0, 5, 0, 0, 0, 0, 0.5, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 0.5, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(0, 5, 0, 0, 0, 0, 0.5, GroupSpawn.spawn_type.RANDOM_SAME)
	curWave.appendGroup(0, 0, 0, 5, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 0, 10, 0, 0, 5, 2, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 0, 0, 5, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(5, 5, 5, 5, 5, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 9 - Final Wave
	Goal: 
		Groups of strategic attacks, followed by a chaos wave
	Learning:
				
	"""
	
	curWave = Wave.new(true, true, true, true, true);
	curWave.description = "All this work is making me thirsty..."
	curWave.appendGroup(0, 15, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 0, 0, 5, 0, 3, 0.3, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(0, 15, 3, 0, 0, 5, 0.3, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(0, 0, 0, 5, 0, 3, 0.3, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(0, 15, 0, 0, 20, 5, 0.3, GroupSpawn.spawn_type.RANDOM_ANY)
	curWave.appendGroup(50, 20, 10, 5, 20, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)	
	curWave.appendGroup(0, 20, 20, 10, 40, 7, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	#wm.current_wave_index = 5
	#$CoinSpawner.number_of_coins = 0
	#Main.coins = 2595
