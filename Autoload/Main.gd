extends Node

signal signal_add_player(player_node) # How we find the player
signal signal_update_coin_count(count)

var coins : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_add_player.connect(_on_signal_add_player)
	signal_update_coin_count.connect(_update_coin_count)

func _on_signal_add_player(pass_player_node):
	pass

func _update_coin_count(count):
	coins = clamp(coins + count, 0, 999999999)
	print("Total Coins: " + str(coins))
