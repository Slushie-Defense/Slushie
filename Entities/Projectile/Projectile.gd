extends Node2D

var speed : float = 400.0  # Adjust the speed as needed
var target_position : Vector2 = Vector2.ZERO

# Trajectory
var parabolic_curve : Curve = load("res://Entities/Projectile/ProjectileCurve.tres")
var linear_position : Vector2 = Vector2.ZERO
var curve_position : Vector2 = Vector2.ZERO
var parabolic_curve_max_height : float = 400.0

# Position
var initial_position : Vector2 = Vector2.ZERO
var initial_distance : float = 1.0 # Gets overridden

func _ready():
	set_target_global_position(Vector2(global_position.x - 32, global_position.y + 400))
	call_deferred("add_line_2d")

func add_line_2d():
	var line2d = Line2D.new()
	line2d.set_width(3)
	line2d.default_color = Color(1, 1, 0)  # Yellow color
	get_tree().get_root().add_child(line2d)
	line2d.points = [initial_position, target_position]

func _physics_process(delta):
	#return
	# Calculate the direction from the Coin to the player
	var direction = initial_position.direction_to(target_position)
	var distance_to_target = global_position.distance_to(target_position)
	
	# Arch
	var distance_ratio = linear_position.distance_to(target_position) / initial_distance
	var z_height = parabolic_curve.sample(distance_ratio)
	
	# Move the projectile directly towards the target position
	linear_position += direction * speed * delta
	# Curve the projectile in the air towards target position
	curve_position = Vector2(linear_position.x, linear_position.y - (z_height * parabolic_curve_max_height))
	
	# Check if the projectile has reached the target
	if initial_position.distance_to(linear_position) > initial_distance:
		# The projectile has reached the target, so you can handle that here
		_reached_target()
	
	# Update position
	global_position = curve_position

func set_target_global_position(new_target_position: Vector2):
	target_position = new_target_position
	# Setup
	linear_position = global_position
	initial_position = global_position
	initial_distance = initial_position.distance_to(target_position)

func _reached_target():
	queue_free()  # Destroy the projectile, for example
