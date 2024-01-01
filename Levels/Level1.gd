extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var wm = $WaveManager	
	var curGroup
	var curWave
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(15, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(1, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
