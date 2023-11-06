extends Node2D

@onready var timer : Timer = $Timer
var timer_ratio : float = 1.0 # Gets overridden

# Properties
var target_position : Vector2 = Vector2.ZERO
var speed : float = 200  # Adjust the speed as needed
var arch_magnitude : float = 50  # Adjust the magnitude of the arch as needed
var initial_position : Vector2 = Vector2.ZERO

func _ready():
	timer_ratio = 1.0 / timer.wait_time
	timer.start()
	set_target_position(Vector2(1280, 720))

func _physics_process(delta):
	# Calculate the direction from the Coin to the player
	var direction = initial_position.direction_to(target_position)
	var distance_to_player = initial_position.distance_to(target_position)
	
	# Use the interpolate() function to adjust the speed based on your curve
	var time_left_normalized : float = 1.0 - (timer.time_left * timer_ratio)
	var line_ratio = 1.0 #acceleration_curve.sample(time_left_normalized)
	
	# Move the Coin towards the player's position
	global_position += initial_position + (direction * speed * delta)

	# Check if the projectile has reached the target
	if global_position.distance_to(target_position) < speed * delta:
		# The projectile has reached the target, so you can handle that here
		_reached_target()

func set_target_position(new_target_position: Vector2):
	target_position = new_target_position

func _reached_target():
	queue_free()  # Destroy the projectile, for example
