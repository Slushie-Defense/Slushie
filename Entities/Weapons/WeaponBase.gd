extends Node2D

@onready var sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shot_delay_timer : Timer = $ShotDelayTimer
@onready var reload_delay_timer : Timer = $ReloadDelayTimer

var delay_between_shots : float = 0.2
var reload_time : float = 2.0

var shots_before_reload : int = 5
var shot_counter : int = 0

# Does nothing at the moment
var damage : int = 0
var attack_range : float = 0.0
var weapon_direction : Vector2 = Vector2.ZERO
var explode_at_target : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_delay_timer.wait_time = delay_between_shots
	reload_delay_timer.wait_time = reload_time
	shot_delay_timer.start()

func _on_shot_delay_timer_timeout():	
	print(shot_counter)
	if shot_counter >= shots_before_reload:
		print("Start reload")
		reload_delay_timer.start() # Start reload
	else:
		print("Fire!")
		shot_counter += 1
		sound_player.play()
		shot_delay_timer.start()

func _on_reload_delay_timer_timeout():
	print("Reloaded!")
	shot_counter = 0 # Reset
	shot_delay_timer.start()



