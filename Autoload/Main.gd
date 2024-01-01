extends Node

# Entities
signal signal_add_player(player_node) # How we find the player
signal signal_add_gas_station(gas_station_node) # How we find the gas station
signal signal_add_camera(camera_node)
signal signal_update_enemy_count(enemy_number)

# Money
signal signal_update_coin_count(count)
signal signal_purchase_failed()
signal signal_selected_item_update(item_type)

# Waves
signal signal_wave_event(event_number : int)
signal signal_wave_spawning(_is_active)
signal signal_trigger_wave_event()
signal signal_game_completed()

signal signal_stop_fmod()

# End game events
signal signal_player_died()
signal signal_gas_station_destroyed()

# Intro music
var music_scene = load("res://Music/Music.tscn")
var music : AudioStreamPlayer

# MadKing Screen
var company_screen_shown : bool = false

# Camera node
var camera_node : Camera2D = null
# Player node
var player_node : CharacterBody2D = null
# Gas station
var gas_station_node : StaticBody2D = null
# Enemy count
var enemy_counter : int = 0

# Coin count
var coin_spawner_scene = load("res://Entities/Coin/CoinSpawner.tscn")
var coins : int = 0
var coin_base_reward : int = 50
var coin_reward : int = coin_base_reward

# Wave number
var current_wave_number : int = 1
var current_wave_spawning : bool = false
var current_wave_active : bool = false

# Pause scene
var pause_scene = load("res://UserInterface/PauseScreen/PauseScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_add_player.connect(_on_signal_add_player)
	signal_add_gas_station.connect(_on_signal_add_gas_station)
	signal_update_coin_count.connect(_update_coin_count)
	signal_add_camera.connect(_on_signal_add_camera)
	signal_update_enemy_count.connect(_update_enemy_count)
	signal_wave_spawning.connect(_update_wave_active_state)
	signal_game_completed.connect(_game_completed_event)
	
	signal_wave_event.connect(_on_signal_wave_start)
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Game over screen
	signal_player_died.connect(_game_ended)
	# Add music
	_add_theme_music()

func _add_theme_music():
	music = music_scene.instantiate()
	add_child(music)

func _play_theme_music():
	music.play()

func _stop_theme_music():
	music.stop()

func _update_wave_active_state(_wave_active):
	current_wave_spawning = _wave_active
	_is_wave_over()

func _update_enemy_count(enemy_number):
	enemy_counter = clamp(enemy_counter + enemy_number, 0, 999999)
	_is_wave_over()

func _is_wave_over():
	# Check if the wave is active
	if current_wave_number > 0:
		if enemy_counter > 0 or current_wave_spawning:
			current_wave_active = true
		# If there are no enemies and the portals are not spawning it is not active
		if enemy_counter == 0 and not current_wave_spawning:
			call_deferred("_wave_over")
			current_wave_active = false

func _wave_over():
	Main.emit_signal("signal_wave_event", -1)
	# Reward with coins
	var extra_coins : int = round(current_wave_number * 5)
	coin_reward = coin_base_reward + extra_coins
	_reward_with_coins()
	
func _on_signal_wave_start(_number):
	if not _number == -1:
		current_wave_number = _number

func _game_ended():
	get_tree().create_timer(4.0).timeout.connect(_go_to_death_scene)

func _go_to_death_scene():
	coins = 0
	get_tree().change_scene_to_file("res://UserInterface/DeathScreen/DeathScreen.tscn")
	# Play Main Theme
	_play_theme_music()

func _input(event):
	if event.is_action_pressed("PauseButton"):
		_pause_game_toggle()

func _pause_game_toggle():
	var log_pause : String = "CONTINUE GAME!" if get_tree().paused else "PAUSE GAME!"
	get_tree().paused = not get_tree().paused
	# Add the pause screen
	if get_tree().paused:
		if not camera_node == null:
			var pause = pause_scene.instantiate()
			camera_node._canvas_layer.add_child(pause)
			print(camera_node.get_children())

func _on_signal_add_camera(pass_node):
	camera_node = pass_node
	
func _on_signal_add_gas_station(pass_node):
	gas_station_node = pass_node
	
func _on_signal_add_player(pass_node):
	player_node = pass_node
	# Reward with some coins
	get_tree().create_timer(1.0).timeout.connect(_reward_with_coins)
	# Stop music when the player is added
	_stop_theme_music()

func _update_coin_count(count):
	coins = clamp(coins + count, 0, 9999999999)

func _player_alive():
	return not player_node == null

func _reward_with_coins():
	if _player_alive():
		var spawned_coins = coin_spawner_scene.instantiate()
		spawned_coins.number_of_coins = coin_reward
		spawned_coins.randomize_postion = true
		spawned_coins.instant_pickup = true
		spawned_coins.global_position = player_node.global_position
		get_tree().current_scene.add_child(spawned_coins)

func _try_to_buy(cost):
	var can_purchase : bool = Main.coins - cost >= 0
	if can_purchase:
		emit_signal("signal_update_coin_count", -cost)
	else:
		emit_signal("signal_purchase_failed")
	return can_purchase

func _game_completed_event():
	print("Game completed! Congrats!")
	get_tree().create_timer(8.0).timeout.connect(_stop_fmod)
	get_tree().create_timer(10.0).timeout.connect(_goto_win_screen)

func _stop_fmod():
	emit_signal("signal_stop_fmod")

func _goto_win_screen():
	get_tree().change_scene_to_file("res://UserInterface/GameCompleteScreen/WinScreen.tscn")
	# Play Main Theme
	_play_theme_music()
