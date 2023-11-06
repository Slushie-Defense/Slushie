extends Node2D

@export var spawn_timer: float

var timer = 0.0

# array of waves
# each wave is an array of enemies (represented by EnemySpawnInfo)
# each enemy has a type, position, and time to spawn
@export var waves: Array[Wave]
# current spawn index
var spawn_index: int = 0

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
	# if the array size is 1, then spawn that enemy
	# if the array size is greater than 1, then spawn a random enemy from the array
	var enemy_instance : Node2D# = enemy_scene.instantiate()
	if (enemy_info.enemies.size() == 0):
		print("no enemies to spawn")
		return
	if (enemy_info.enemies.size() == 1):
		enemy_instance = (enemy_info.enemies[0]).instantiate()
	else:
		var random_index = randi() % enemy_info.enemies.size()
		enemy_instance = enemy_info.enemies[random_index].instantiate()

	enemy_instance.position = enemy_info.portals[0].position
	print("spawning "+ enemy_info.type + "at " + str(enemy_info.portals[0].position))
	get_tree().get_root().add_child(enemy_instance)
	alive_enemies.append(enemy_instance)
	await get_tree().create_timer(enemy_info.total_time / float(enemy_info.number_to_spawn)).timeout


var current_group_id = 0

func _spawn_enemy_info_group(wave: Wave):
	spawning = true
	Main.emit_signal("signal_wave_event", str(wave.name) + ": new group spawning")


	for enemy_info in wave.enemies:
		for i in range(enemy_info.number_to_spawn):
			_spawn_enemy(enemy_info)

	spawning = false
	Main.emit_signal("signal_wave_event", str(wave.name) + ": Spawned all enemies in this group")

func spawn_wave(wave_number: int):
	var current_wave = waves[wave_number]
	Main.emit_signal("signal_wave_event", str(current_wave.name) + ": new wave spawning")
	for enemy_info in current_wave.enemies:
		_spawn_enemy_info_group(current_wave)

	wave_number += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# every 5 seconds, spawn an enemy_scene
	spawn_wave(0)
	# set the total number of enemies to spawn

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!spawning):
		if (is_wave_complete()):
			spawn_index += 1
			if (spawn_index >= waves.size()):
				spawn_index = 0
				Main.emit_signal("signal_wave_event", "All waves complete!")
			else:
				spawn_wave(spawn_index)
	pass
