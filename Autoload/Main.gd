extends Node

signal signal_add_player(player_node) # How we find the player
signal signal_update_coin_count(count)
signal signal_purchase_failed()
signal signal_wave_event(event_string)
signal signal_selected_item_update(item_type)
signal signal_gas_station_destroyed()

# Player node
var player_node : CharacterBody2D = null

# Coin count
var coin_spawner_scene = load("res://Entities/Coin/CoinSpawner.tscn")
var coins : int = 0
var coin_reward : int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_add_player.connect(_on_signal_add_player)
	signal_update_coin_count.connect(_update_coin_count)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("PauseButton"):
		_pause_game_toggle()

func _pause_game_toggle():
	var log_pause : String = "CONTINUE GAME!" if get_tree().paused else "PAUSE GAME!"
	print(log_pause)
	get_tree().paused = not get_tree().paused

func _on_signal_add_player(pass_player_node):
	player_node = pass_player_node
	# Reward with some coins
	get_tree().create_timer(1.0).timeout.connect(_reward_with_coins)

func _update_coin_count(count):
	coins = clamp(coins + count, 0, 9999999999)

func _player_alive():
	return not player_node == null

func _reward_with_coins():
	if _player_alive():
		var coins = coin_spawner_scene.instantiate()
		coins.number_of_coins = coin_reward
		get_tree().get_root().add_child(coins)
		coins.randomize_postion = true
		coins.instant_pickup = true
		coins.global_position = player_node.global_position

func _try_to_buy(cost):
	var can_purchase : bool = Main.coins - cost >= 0
	if can_purchase:
		emit_signal("signal_update_coin_count", -cost)
	else:
		emit_signal("signal_purchase_failed")
	return can_purchase
