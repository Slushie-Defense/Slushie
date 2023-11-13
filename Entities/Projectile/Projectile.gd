extends Node2D

# Sprite
@onready var sprite_2d : Sprite2D = $Sprite2D

# Damage
var attack_damage = 50.0 # his is modified in UnitData

# Stats
var linear_speed : float = 400.0  # Let's not edit this
var curve_speed : float = 0.0  # Let's not edit this
var calculated_speed : float = linear_speed
var target_position : Vector2 = Vector2.ZERO

# Trajectory
var parabolic_curve : Curve = load("res://Entities/Projectile/ProjectileCurve.tres")
var linear_position : Vector2 = Vector2.ZERO
var curve_position : Vector2 = Vector2.ZERO
var parabolic_curve_max_height : float = 400.0 # Let's not edit this
@export var arch_and_explode : bool = true

# Position
var initial_position : Vector2 = Vector2.ZERO
var initial_distance : float = 1.0 # Gets overridden

# Explosion at target
var explosion_scene = load("res://Entities/Explosion/ExplosionAOE.tscn")

# Hit at target
@onready var shapecast2d : ShapeCast2D = $ShapeCast2D

func _physics_process(delta):
	# Calculate the direction from the Coin to the player
	var direction_to_target = initial_position.direction_to(target_position)
	var distance_to_target = global_position.distance_to(target_position)
	
	# Arch
	var distance_ratio = linear_position.distance_to(target_position) / initial_distance
	var z_height = parabolic_curve.sample(distance_ratio)
	
	# Move the projectile directly towards the target position
	linear_position += direction_to_target * calculated_speed * delta
	# Curve the projectile in the air towards target position
	curve_position = Vector2(linear_position.x, linear_position.y - (z_height * parabolic_curve_max_height))
	
	#var normalized_direction = previous_curve_position.direction_to(curve_position) * 32
	#var sprite_rotation = Vector2.ZERO.angle_to(normalized_direction)
	#sprite_2d.rotation = sprite_rotation
	
	# Check if the projectile has reached the target
	if initial_position.distance_to(linear_position) > initial_distance:
		# The projectile has reached the target, so you can handle that here
		_reached_target()
	
	# If it's projectile that doesn't arch
	if not arch_and_explode:
		# Check for collision ahead
		shapecast2d.target_position = direction_to_target * calculated_speed * delta
		if shapecast2d.is_colliding():
			var collision_result = shapecast2d.get_collider(0) # Get first collision. Only looks for one.
			if not collision_result == null:
				if collision_result.has_method("attack"):
					# Create an attack class and pass it through
					var attack = Attack.new()
					attack.damage = attack_damage
					collision_result.attack(attack)
					# Has reached target
					_reached_target()
	
	# Update position
	global_position = curve_position


func set_target_global_position(new_target_position: Vector2):
	target_position = new_target_position
	# Initial position
	linear_position = global_position
	initial_position = global_position
	initial_distance = initial_position.distance_to(target_position)
	# Calculate curve speed if relevant
	curve_speed = initial_distance / 2.0
	calculated_speed = curve_speed if arch_and_explode else linear_speed
	parabolic_curve_max_height = 400.0 if arch_and_explode else 0.0
	# Remove collision detection if not relevant
	if arch_and_explode:
		shapecast2d.call_deferred("queue_free")
	else:
		shapecast2d.enabled = true

func _reached_target():
	if arch_and_explode:
		_create_explosion()
	queue_free()  # Destroy the projectile, for example

func _create_explosion():
	var explosion = explosion_scene.instantiate()
	explosion.attack_damage = attack_damage
	get_tree().get_root().add_child(explosion)
	explosion.global_position = target_position
