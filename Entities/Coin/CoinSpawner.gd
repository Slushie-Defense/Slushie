extends Node2D

@export var number_of_coins_horizontally : int = 6
@export var number_of_coins_vertically : int = 9
@export var coin_gap : int = 128

var coin_scene = load("res://Entities/Coin/Coin.tscn")
@onready var coin_sprite : Sprite2D = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	coin_sprite.visible = false
	coin_sprite.call_deferred("queue_free")
	call_deferred("_spawn_coins")

func _spawn_coins():
	for x1 in range(0, number_of_coins_horizontally):
		for y1 in range(0, number_of_coins_vertically):
			print(str(x1) + ":" + str(y1))
			var coin = coin_scene.instantiate()
			get_tree().get_root().add_child(coin)
			coin.global_position = global_position + Vector2(x1 * coin_gap, y1 * coin_gap)
