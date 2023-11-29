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

# Enemies
var current_enemy_index : int = 0

# Portals
var all_portals_list : Array = []
var active_portals_list : Array = []

# Initatialize
func _ready():
	all_portals_list = _find_all_portals()

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
	# Open all active portals
	_open_all_active_portals()
	# Get the first group
	if not current_wave_total_group_count > 0:
		print("No Groups Added")
		return
	# Find the current wave
	current_group_index = 0
	# Start the first group
	_start_next_group()

func _on_enemy_group_timer_timeout():
	print("Enemy Group [" + str(current_group_index) + "] Start")
	# Create an array of all the current enemy types in a random order
	current_group_enemy_list = _create_randomized_group_enemy_list()
	# Start spawning enemies
	_on_enemy_spawn_timer_timeout()

func _on_enemy_spawn_timer_timeout():
	# Recursive loop of spawning enemies
	if current_enemy_index < current_group_enemy_list.size():
		# Get current enemy
		var current_enemy_type = current_group_enemy_list[current_enemy_index]
		# Spawn
		var portal
		if current_group.spawn_method == GroupSpawn.spawn_type.CONSECUTIVE_ALL:
			var random_index = randi() % active_portals_list.size()
			portal = active_portals_list[random_index]
		# Spawn it
		_spawn_enemy(current_enemy_type, portal)
		# Set the next enemy timer off
		enemy_spawn_timer.start()
		# Set to next enemy
		current_enemy_index += 1
	else:
		# Mark the end of the group
		print("Enemy Group [" + str(current_group_index) + "] End")
		# Go to next group
		current_group_index += 1
		if current_group_index < current_wave.enemy_group_list.size():
			_start_next_group()
		else:
			# Wave number
			Main.emit_signal("signal_wave_event", "Wave Complete: " + str(current_wave_index))
			# Close all the open portals
			_close_all_portals()
			# Update the wave count
			current_wave_index += 1

func _start_next_group():
	# Find the current wave
	current_group = current_wave.enemy_group_list[current_group_index]
	# Start spawning with a delay before each group
	enemy_group_timer.wait_time = current_group.group_delay_time # Delay between groups. Universal
	enemy_group_timer.start() # On time_out the enemies will start spawning
	# Set the Enemy spawn delay time
	enemy_spawn_timer.wait_time = current_group.spawn_delay_time
	# Reset enemy count
	current_enemy_index = 0

func _spawn_enemy(current_enemy_type, portal):
	var enemy = enemy_scene.instantiate()
	enemy.enemy_type = current_enemy_type
	# Add Enemy to the WaveManager
	add_child(enemy)
	# Portal position
	enemy.global_position = portal.global_position
	# Print current enemy number
	print(str(current_enemy_type) + " Number : " + str(current_enemy_index))

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
	var portal_list = []
	for child in get_tree().current_scene.get_children():
		for i in portal_names.size():
			if portal_names[i] == child.name:
				portal_list.push_back(child)
	return portal_list

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

func _open_all_active_portals():
	for portal in active_portals_list:
		portal._set_portal_state_open(true)

func _close_all_portals():
	for portal in all_portals_list:
		portal._set_portal_state_open(false)
