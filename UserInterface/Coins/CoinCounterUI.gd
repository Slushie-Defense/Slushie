extends Node2D

@onready var coin_counter : Label = $CanvasLayer/Control/PanelContainer/MarginContainer/BoxContainer/Label

func _ready():
	Main.signal_update_coin_count.connect(_update_coin_count)
	_update_coin_count(0)

func _update_coin_count(count):
	var fps = Engine.get_frames_per_second()
	coin_counter.text = "Coins: " + str(Main.coins) + " FPS: " + str(fps)
