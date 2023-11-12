class_name WaveManager
extends Node2D

# array of waves
# each wave is an array of enemies (represented by EnemySpawnInfo)
# each enemy has a type, position, and time to spawn
@export var waves: Array[Wave]

var spawning = false

# since the spawned enemies will be childed to the object, we can use get_child_count to check the status of the enemies in the wave
func check_wave_complete():
	if (spawning):
		return false
	if (get_child_count() == 0):
		Main.emit_signal("signal_wave_event", "Wave complete!")
		current_wave_index+=1
		return true
	else:
		return false

# gets the enemy scene from the enemy type, instantiates it, and childs it to $WaveManager
func _add_enemy(enemy_info : EnemySpawnInfo):
	var enemy_instance : Node2D
	# get enemies from enemy_info
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
		
	# add variance to the position
	enemy_instance.position.x += randi() % 100 - 50

	#print("spawning "+ enemy_info.type + "at " + str(enemy_instance.position))
	add_child(enemy_instance)

# spawn the enemy with a delay (coroutine)
func _spawn_enemy(enemy_info: EnemySpawnInfo):
	for i in range(enemy_info.number_to_spawn_at_once):
		_add_enemy(enemy_info)
	await get_tree().create_timer(enemy_info.total_time / float(enemy_info.number_to_spawn)).timeout


# spawns a wave, which syncronously loops through the groups
func spawn_wave(wave_number: int):
	spawning = true
	var current_wave = waves[wave_number]
	Main.emit_signal("signal_wave_event", str(current_wave.name) + ": new wave spawning")

	# spawn the groups sequentially
	for enemy_info in current_wave.enemies:
		await _spawn_group(enemy_info)
	wave_number += 1
	spawning = false
	Main.emit_signal("signal_wave_event", str(current_wave.name) + ": wave completed spawning")

# spawns a group of enemies within a wave
func _spawn_group(enemy_info: EnemySpawnInfo):
	Main.emit_signal("signal_wave_event", str(enemy_info.type) + ": new group spawning")
	for i in range(enemy_info.number_to_spawn + 1):
		await _spawn_enemy(enemy_info)
	Main.emit_signal("signal_wave_event", str(enemy_info.type) + ": Spawned all enemies in this group")

var current_wave_index = 0
# Called when the node enters the scene tree for the first time.
func spawn_next_wave():
	spawn_wave(current_wave_index)

func _process(delta):
	if (spawning):
		return

