extends Node2D

@export var number_of_coins : int = 1
@export var coin_gap : int = 64
@export var instant_pickup : bool = false
@export var randomize_postion : bool = false
@export var hide : bool = false

var coin_scene = load("res://Entities/Coin/Coin.tscn")
@onready var coin_sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if hide:
		return
	coin_sprite.call_deferred("queue_free")
	coin_sprite.visible = false
	call_deferred("_spawn_coins")

func _spawn_coins():
	var grid_size = ceil(sqrt(number_of_coins))
	var half_size = (grid_size * coin_gap * 0.5) - (coin_gap * 0.5)
	for x1 in range(0, grid_size):
		for y1 in range(0, grid_size):
			if x1 + y1 * grid_size < number_of_coins:
				var coin = coin_scene.instantiate()
				get_tree().current_scene.add_child(coin)
				# Does it go straight to the player
				if instant_pickup:
					coin.timer.wait_time = randf_range(0.25, 0.5)
					coin._instant_pickup()
				# Randomize the position
				var random_x_position : float = 0.0
				var random_y_position : float  = 0.0
				if randomize_postion:
					var offset_distance : float = coin_gap * 0.3 
					random_x_position = randf_range(-offset_distance, offset_distance)
					random_y_position = randf_range(-offset_distance, offset_distance)
				# Position
				coin.global_position = global_position + Vector2(x1 * coin_gap - half_size + random_x_position, y1 * coin_gap - half_size + random_y_position)
