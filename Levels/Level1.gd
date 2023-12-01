extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var wm = $WaveManager	
	var curGroup
	var curWave
	
	curWave = Wave.new(false, false, true, false, false);
	curWave.appendGroup(5, 0, 0, 0, 0, 5, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	curWave.appendGroup(0, 3, 0, 0, 0, 3, 1)
	wm.waves.append(curWave)
	
	curWave = Wave.new(false, true, true, true, false);
	curWave.appendGroup(17, 0, 0, 0, 0, 3, 1, GroupSpawn.spawn_type.ALL_AT_ONCE)
	wm.waves.append(curWave)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
