extends Node

signal signal_add_player(player_node) # How we find the player
signal signal_update_coin_count(count)
signal signal_wave_event(event_string)
signal signal_selected_item_update(item_name)
signal signal_gas_station_destroyed()

# Coin count
var coins : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_add_player.connect(_on_signal_add_player)
	signal_update_coin_count.connect(_update_coin_count)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_text_clear_carets_and_selection"):
		_pause_game_toggle()

func _pause_game_toggle():
	var log_pause : String = "CONTINUE GAME!" if get_tree().paused else "PAUSE GAME!"
	print(log_pause)
	get_tree().paused = not get_tree().paused

func _on_signal_add_player(pass_player_node):
	pass

func _update_coin_count(count):
	coins = clamp(coins + count, 0, 999999999)

