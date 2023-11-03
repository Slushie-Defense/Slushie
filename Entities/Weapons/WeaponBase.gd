extends Node2D

@onready var sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shot_delay_timer : Timer = $ShotDelayTimer

var sound_shoot = load("res://Entities/Weapons/Sounds/Splat.wav")
var sound_reload = load("res://Entities/Weapons/Sounds/Reload.wav")

var delay_between_shots : float = 0.2
var reload_time : float = 2.0

var shots_before_reload : int = 5
var shot_counter : int = 1 # Start at 1

# Does nothing at the moment
var damage : int = 0
var attack_range : float = 0.0
var weapon_direction : Vector2 = Vector2.ZERO
var explode_at_target : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_delay_timer.wait_time = delay_between_shots
	shot_delay_timer.start()

func _on_shot_delay_timer_timeout():	
	print(shot_counter)
	if shot_counter >= shots_before_reload:
		print("Reload")
		# Play the reload sound just before the end of the reload timer
		var reload_sound_time : float = 0.75
		get_tree().create_timer(reload_time - reload_sound_time).timeout.connect(_play_reload_sound)
		# Reload weapon
		shot_counter = 0 # Reset
		shot_delay_timer.wait_time = reload_time
		shot_delay_timer.start()
	else:
		print("Fire!")
		# Fire weapon
		shot_counter += 1
		sound_player.stream = sound_shoot
		sound_player.play()
		shot_delay_timer.wait_time = delay_between_shots
		shot_delay_timer.start()

func _play_reload_sound():
	sound_player.stream = sound_reload
	sound_player.play()
