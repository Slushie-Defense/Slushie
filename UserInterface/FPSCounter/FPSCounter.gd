extends Control

@onready var fps_counter : Label = $PanelContainer/MarginContainer/FPSLabel

func _process(_delta):
	var fps = Engine.get_frames_per_second()
	fps_counter.text = "FPS: " + str(fps)
