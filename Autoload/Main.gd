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
var coin_scene = load("res://Entities/Coin/Coin.tscn")
var coins : int = 0
var coin_reward : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_add_player.connect(_on_signal_add_player)
	signal_update_coin_count.connect(_update_coin_count)
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Reward with some coins
	get_tree().create_timer(1.0).timeout.connect(_reward_with_coins)

func _input(event):
	if event.is_action_pressed("ui_text_clear_carets_and_selection"):
		_pause_game_toggle()

func _pause_game_toggle():
	var log_pause : String = "CONTINUE GAME!" if get_tree().paused else "PAUSE GAME!"
	print(log_pause)
	get_tree().paused = not get_tree().paused

func _on_signal_add_player(pass_player_node):
	player_node = pass_player_node

func _update_coin_count(count):
	coins = clamp(coins + count, 0, 9999999999)

func _reward_with_coins():
	if not player_node == null:
		var angle_increment = 360.0 / coin_reward
		for i in range(0, coin_reward):
			var coins = coin_scene.instantiate()
			player_node.add_child(coins)
			# Spawn the coins around the player
			var distance_from_player : int = 96
			var angle = i * angle_increment
			coins.global_position = player_node.global_position + Vector2(distance_from_player, 0).rotated(deg_to_rad(angle))

func _try_to_buy(cost):
	var can_purchase : bool = Main.coins - cost >= 0
	if can_purchase:
		emit_signal("signal_update_coin_count", -cost)
	else:
		emit_signal("signal_purchase_failed")
	return can_purchase
