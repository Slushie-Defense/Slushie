extends Node

var enemy_scene = load("res://Entities/Enemy/Enemy.tscn")
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
var alive_enemies: Array[PackedScene] = []

# TODO: test this function because I'm not sure how to fight?
# function that checks alive enemies and returns true if all enemies are destroyed
func is_wave_complete():
	if (spawning):
		return false
	if alive_enemies.size() == 0:
		return false
	for enemy in alive_enemies:
		if enemy != null || !enemy.is_queued_for_deletion():
			return false

	print("wave complete no more enemies")
	return true

var spawning = false

func _spawn_wave(wave: Wave):
	spawning = true;
	print("spawning" + str(wave.name))
	print(wave.name)
	print(wave.description)
	for enemy_info in wave.enemies:
		await get_tree().create_timer(enemy_info.time).timeout
		for i in range(enemy_info.number_to_spawn):
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.position = enemy_info.position
			print("spawning "+ enemy_info.type + "at " + str(enemy_info.position))
			add_child(enemy_instance)
			alive_enemies.append(enemy_instance)
			await get_tree().create_timer(enemy_info.repeat_time).timeout
	spawning = false			
	print("all enemies in this wave have been spawned")



# Called when the node enters the scene tree for the first time.
func _ready():
	# every 5 seconds, spawn an enemy_scene
	_spawn_wave(waves[0])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_wave_complete()):
		spawn_index += 1
		if (spawn_index >= waves.size()):
			spawn_index = 0
			print("All waves complete!")
		else:
			_spawn_wave(waves[spawn_index])
	pass

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(2000, 500)
	add_child(enemy)
