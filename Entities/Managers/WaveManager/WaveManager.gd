extends Node2D

@export var spawn_timer: float

var timer = 0.0

# array of waves
# each wave is an array of enemies (represented by EnemySpawnInfo)
# each enemy has a type, position, and time to spawn
@export var waves: Array[Wave]
# current spawn index
var spawn_index: int = -1

# spawn waves algorithm:
# for each wave in waves
# 	display wave.description and wave.name
# 	for each enemy info in wave.enemies
# 		wait enemy info.time
# 		spawn enemy.type at enemy.position
# 		for each repeat in enemy.number_to_spawn
# 			wait enemy.repeat_time
# 			spawn enemy.type at enemy.position

# variable to store all alive enemyes in current wave
var alive_enemies : Array = []

# function that checks alive enemies and returns true if all enemies are destroyed
func is_wave_complete():
	return true
	if alive_enemies.size() == 0:
		return true
	for enemy in alive_enemies:
		if enemy == null:
			pass
		if enemy.is_queued_for_deletion():
			return false;
		return false

	Main.emit_signal("signal_wave_event", "Wave complete!")
	print("wave complete")
	alive_enemies.clear()
	return true

var spawning = false

func _spawn_enemy(enemy_info: EnemySpawnInfo):
	# get enemies from enemy_info
	var enemy_instance : Node2D# = enemy_scene.instantiate()
	if (enemy_info.enemies.size() == 0):
		print("no enemies to spawn")
		return
	# if the array size is 1, then spawn that enemy
	if (enemy_info.enemies.size() == 1):
		enemy_instance = (enemy_info.enemies[0]).instantiate()
	# if the array size is greater than 1, then spawn a random enemy from the array
	else:
		var random_index = randi() % enemy_info.enemies.size()
		enemy_instance = enemy_info.enemies[random_index].instantiate()


	# set the position of the enemy
	if (enemy_info.portals.size() == 0):
		print("no portals to spawn at")
		return
	# if the portals array size is 1, spawn at that position
	if (enemy_info.portals.size() == 1):
		enemy_instance.position = enemy_info.portals[0].position
	else:
	# if the portals array size is greater than 1, spawn at a random position on the portals from the array
		var random_index = randi() % enemy_info.portals.size()
		enemy_instance.position = enemy_info.portals[random_index].position
	
	print("spawning "+ enemy_info.type + "at " + str(enemy_instance.position))
	get_tree().get_root().add_child(enemy_instance)
	alive_enemies.append(enemy_instance)
	await get_tree().create_timer(enemy_info.total_time / float(enemy_info.number_to_spawn)).timeout


var current_group_id = 0

func spawn_wave(wave_number: int):
	var current_wave = waves[wave_number]
	Main.emit_signal("signal_wave_event", str(current_wave.name) + ": new wave spawning")
	for enemy_info in current_wave.enemies:
		await _spawn_group(enemy_info)
	wave_number += 1

func _spawn_group(enemy_info: EnemySpawnInfo):
	spawning = true
	Main.emit_signal("signal_wave_event", str(enemy_info.type) + ": new group spawning")
	for i in range(enemy_info.number_to_spawn):
		await _spawn_enemy(enemy_info)
	spawning = false
	Main.emit_signal("signal_wave_event", str(enemy_info.type) + ": Spawned all enemies in this group")

# Called when the node enters the scene tree for the first time.
func _ready():
	# every 5 seconds, spawn an enemy_scene
	spawn_wave(0)
	# set the total number of enemies to spawn

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
	# if the enter key is pressed, then check
	# if the wave is complete, then spawn the next wave
	# if the wave is not complete, then do nothing

	# pass

	# if the enter key is pressed, spawn wave and increment the spawn index
	# if Input.is_action_just_pressed("ui_accept"):
		# if (!spawning):
		# 	if (is_wave_complete()):
		# 		spawn_index += 1
		# 		if (spawn_index >= waves.size()):
		# 			spawn_index = waves.size()+1
		# 			Main.emit_signal("signal_wave_event", "All waves complete!")
		# 		else:
		# 			spawn_wave(spawn_index)
		# pass
