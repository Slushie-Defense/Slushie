extends Node2D

# Value
@export_range(0, 1000, 100) var coin_value : int = 100

# Detection
@onready var area_2d : Area2D = $Area2D

# Timer
@onready var timer : Timer = $Timer
var timer_ratio : float = 1.0 # Gets overridden

# Move the coin
var acceleration_curve : Curve = preload("res://Entities/Coin/CoinAccelerationCurve.tres")
var initial_position : Vector2 = Vector2.ZERO
var player_position : Vector2 = Vector2.ZERO

# Audio
@onready var sound_effect : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	set_physics_process(false) # Stop processing any cycles
	timer_ratio = 1.0 / timer.wait_time
	call_deferred("_update_initial_position")

func _instant_pickup():
	if Main._player_alive(): # Go straight to the player
		_on_area_2d_body_entered(Main.player_node)

func _update_initial_position():
	# Store initial position to interpolate from
	initial_position = global_position

func _on_area_2d_body_entered(body):
	# Coins Area2D can only collide with the player
	var player = body
	player.signal_share_player_position.connect(_update_player_position)
	# Start processing movement
	set_physics_process(true)
	# Set the timer off
	timer.start()
	# Remove collision detection
	area_2d.call_deferred("queue_free")

func _physics_process(_delta):
	# Calculate the direction from the Coin to the player
	var direction = initial_position.direction_to(player_position)
	var distance_to_player = initial_position.distance_to(player_position)
	
	# Use the interpolate() function to adjust the speed based on your curve
	var time_left_normalized : float = 1.0 - (timer.time_left * timer_ratio)
	var line_ratio = acceleration_curve.sample(time_left_normalized)
	
	# Move the Coin towards the player's position
	global_position = initial_position + (direction * line_ratio * distance_to_player)

func _update_player_position(signal_position):
	player_position = signal_position

func _on_timer_timeout():
	Main.emit_signal("signal_update_coin_count", coin_value)
	# End processing
	set_physics_process(true)
	# Hide coin
	visible = false
	# Play sound
	sound_effect.play()

func _on_audio_stream_player_2d_finished():
	call_deferred("queue_free") # Destroy self
