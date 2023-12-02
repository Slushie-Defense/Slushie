extends Control

@onready var center_container : CenterContainer = $CenterContainer
@onready var label : Label = $CenterContainer/TextureRect/Label
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.signal_wave_event.connect(wave_event)
	#animation_player.current_animation = "NoLabel"
	#animation_player.play()
	
func wave_event(wave_event_number):
	label.rotation_degrees = randi_range(-3.0, 3.0)
	label.text = str(wave_event_number)
	animation_player.current_animation = "ShowWaveUI"
	animation_player.play()
