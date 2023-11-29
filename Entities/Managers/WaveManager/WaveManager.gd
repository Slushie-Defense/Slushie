extends Node2D

# array of waves
# each wave is an array of enemies (represented by GroupSpawn)
# each enemy has a type, position, and time to spawn
@export var waves: Array[Wave]

# Delay between each group
@onready var enemy_group_timer : Timer = $EnemyGroupTimer
# Delay between each enemy
@onready var enemy_spawn_timer : Timer = $EnemySpawnTimer

# Enemies
var enemy_scene = load("res://Entities/Enemy/Enemy.tscn")

# Waves
var current_wave
var current_wave_index : int = 0
var current_wave_total_group_count : int = 0

# Groups
var current_group
var current_group_enemy_list : Array = []
var current_group_index : int = 0

# Active portals
var all_portals_list : Array = []
var active_portals_list : Array = []

func _ready():
	_find_all_portals()

# Start the Wave
func _input(event):
	if event.is_action_pressed("StartButton"):
		_spawn_wave(current_wave_index)

# spawns a wave, which syncronously loops through the groups
func _spawn_wave(wave_number: int):
	# Message that he wave is starting
	Main.emit_signal("signal_wave_event", "Start Wave: " + str(wave_number))
	# Exit if there are no waves
	if not waves.size() > 0:
		print("No Waves Added")
		return
	# Get the current wave
	current_wave = waves[wave_number]
	# Number of Groups inside the wave
	current_wave_total_group_count = current_wave.enemy_group_list.size()
	# Find all the active portals in this wave
	active_portals_list = _update_active_portals_list()
	print("Number of active portals: " + str(active_portals_list.size()))
	# Get the first group
	if current_wave_total_group_count > 0:
		# Find the current wave
		current_group_index = 0
		current_group = current_wave.enemy_group_list[current_group_index]
		# Start spawning with a delay before each group
		enemy_group_timer.wait_time = current_group.group_delay_time # Delay between groups. Universal
		enemy_group_timer.start() # On time_out the enemies will start spawning
	# Update the wave count
	wave_number += 1

# spawns a group of enemies within a wave
func _spawn_group(enemy_info: GroupSpawn):
	Main.emit_signal("signal_wave_event", "New group spawning")
	for i in range(enemy_info.number_to_spawn):
		await _spawn_enemy(enemy_info)
	Main.emit_signal("signal_wave_event",  "Spawned all enemies in this group")


func _on_enemy_group_timer_timeout():
	print("Spawned group!")
	# Create an array of all the current enemy types in a random order
	current_group_enemy_list = _create_randomized_group_enemy_list()
	
	
	#_spawn_group(current_group)
		# Find portals through strings

func _on_enemy_spawn_timer_timeout():
	pass # Replace with function body.

func _create_randomized_group_enemy_list():
	# Get all the enemy types
	var randomized_enemy_list = [] # Clear
	# Basic Enemies
	for i in abs(current_group.basic):
		randomized_enemy_list.push_back(UnitData.enemy_list.BASIC)
	# Grunt Enemies
	for i in abs(current_group.grunt):
		randomized_enemy_list.push_back(UnitData.enemy_list.GRUNT)
	# Spitter Enemies
	for i in abs(current_group.spitter):
		randomized_enemy_list.push_back(UnitData.enemy_list.SPITTER)
	# Tank Enemies
	for i in abs(current_group.tank):
		randomized_enemy_list.push_back(UnitData.enemy_list.TANK)
	# Floater Enemies
	for i in abs(current_group.floater):
		randomized_enemy_list.push_back(UnitData.enemy_list.FLOATER)
	# Randomize array
	randomized_enemy_list.shuffle()
	# Send back
	return randomized_enemy_list

func _find_all_portals():
	var portal_names = ["TopPortal", "MiddleTopPortal", "MiddlePortal", "MiddleBottomPortal", "BottomPortal"]
	for child in get_tree().current_scene.get_children():
		for i in portal_names.size():
			if portal_names[i] == child.name:
				all_portals_list.push_back(child)

func _update_active_portals_list():
	# Get the active portals of this wave
	var active_list = [] # Clear current active portals
	# Find all the porals in the level
	for portal in all_portals_list:
		# "TopPortal", "MiddleTopPortal", "MiddlePortal", "MiddleBottomPortal", "BottomPortal"
		match portal.name:
			"TopPortal":
				if current_wave.top_portal:
					active_list.push_back(portal)
			"MiddleTopPortal":
				if current_wave.middle_top_portal:
					active_list.push_back(portal)
			"MiddlePortal":
				if current_wave.middle_portal:
					active_list.push_back(portal)
			"MiddleBottomPortal":
				if current_wave.middle_bottom_portal:
					active_list.push_back(portal)
			"BottomPortal":
				if current_wave.bottom_portal:
					active_list.push_back(portal)
	return active_list

func _open_all_portals():
	for portal in all_portals_list:
		portal._set_portal_state_open(true)

func _close_all_portals():
	for portal in all_portals_list:
		portal._set_portal_state_open(false)



# since the spawned enemies will be childed to the object, we can use get_child_count to check the status of the enemies in the wave
func check_wave_complete():
	if (get_child_count() == 0):
		Main.emit_signal("signal_wave_event", "Wave complete!")
		current_wave_index += 1

# gets the enemy scene from the enemy type, instantiates it, and childs it to $WaveManager
func _add_enemy(enemy_info : GroupSpawn):
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


	var enemy_position = Vector2.ZERO
				
	
	if (active_portals_list.size() == 0):
		print("no portals to spawn at")
		return
	# if the portals array size is 1, spawn at that position
	if (active_portals_list.size() == 1):
		enemy_position = active_portals_list[0].position
	else:
	# if the portals array size is greater than 1, spawn at a random position on the portals from the array
		var random_index = randi() % enemy_info.portals.size()
		enemy_position = active_portals_list[random_index].position
	
	# add variance to the position
	enemy_position.x += randi() % 100 - 50

	add_child(enemy_instance)
	enemy_instance.global_position = enemy_position

# spawn the enemy with a delay (coroutine)
func _spawn_enemy(enemy_info: GroupSpawn):
	for i in range(enemy_info.number_to_spawn_at_once):
		_add_enemy(enemy_info)
		await get_tree().create_timer(enemy_info.total_time / float(enemy_info.number_to_spawn_at_once)).timeout
