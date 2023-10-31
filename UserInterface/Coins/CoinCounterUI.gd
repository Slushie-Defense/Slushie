extends Control

@onready var coin_counter : Label = $PanelContainer/MarginContainer/BoxContainer/Label
@onready var fps_counter : Label = $PanelContainer/MarginContainer/BoxContainer/FPSLabel

func _ready():
	Main.signal_update_coin_count.connect(_update_coin_count)
	_update_coin_count(0)

func _update_coin_count(count):
	coin_counter.text = "Coins: " + str(Main.coins)

func _update_fps_count():
	var fps = Engine.get_frames_per_second()
	fps_counter.text = "FPS: " + str(fps)
