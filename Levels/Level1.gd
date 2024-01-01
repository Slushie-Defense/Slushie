extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var wm = $WaveManager	
	var curGroup
	var curWave
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(20, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(10, 0, 0, 0, 0, 5, 0.5, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
