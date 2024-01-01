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
	Advanced:
		Player could spend money earned during wave to more turrets to speed up the round
	"""
	curWave = Wave.new(false, true, true, false, false);
	curWave.appendGroup(16, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(16, 0, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 1, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 2 - Fodder and Grunts Trickle In
	Goal: 
		Bunch of fodders and grunts attack, eventually attack together
	Learning:
		Player should have enough to buy one fence, or add projectile/instant turrets
		Starts off easy, will need to build during round to survive minimal damage
	Advanced:
		
	"""
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(20, 0, 0, 0, 0, 3, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 10, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(20, 10, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	"""
	Wave 3 - Shock Troops and Tank Intro
	Goal: 
		Tank spawns, followed by fodder and grunts
	Learning:
		Player to learn effectiveness of projectile turrets vs tanks
	Advanced:
		
	"""
	curWave = Wave.new(false, true, true, true, false);
	curWave.appendGroup(0, 0, 0, 6, 0, 5, 3, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(60, 60, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
