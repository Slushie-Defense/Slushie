extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var wm = $WaveManager	
	var curGroup
	var curWave
	
	curWave = Wave.new(true, false, false, false, true);
	curWave.appendGroup(0, 0, 6, 0, 0, 0, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, true, true, true, false);
	curWave.appendGroup(0, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
