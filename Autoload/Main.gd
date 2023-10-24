extends Node

signal signal_add_player(player_node) # How we find the player

var player_node : CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_add_player.connect(_on_signal_add_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_signal_add_player(pass_player_node):
	player_node = pass_player_node
