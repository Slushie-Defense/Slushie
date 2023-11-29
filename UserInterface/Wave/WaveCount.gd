extends Control

@onready var center_container : CenterContainer = $CenterContainer
@onready var label : Label = $CenterContainer/PanelContainer/MarginContainer/CenterContainer2/Label
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.signal_wave_event.connect(wave_event)
	animation_player.current_animation = "NoLabel"
	animation_player.play()
	
func wave_event(wave_event_string):
	label.text = wave_event_string
	animation_player.current_animation = "ShowWaveUI"
	animation_player.play()
