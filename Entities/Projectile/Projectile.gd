extends Node2D

# Damage
var attack_damage = 50.0

# Stats
var linear_speed : float = 400.0  # Adjust the speed as needed
var curve_speed : float = 0.0
var calculated_speed : float = linear_speed
var target_position : Vector2 = Vector2.ZERO

# Trajectory
var parabolic_curve : Curve = load("res://Entities/Projectile/ProjectileCurve.tres")
var linear_position : Vector2 = Vector2.ZERO
var curve_position : Vector2 = Vector2.ZERO
var parabolic_curve_max_height : float = 400.0
@export var arch_and_explode : bool = true

# Position
var initial_position : Vector2 = Vector2.ZERO
var initial_distance : float = 1.0 # Gets overridden

# Explosion at target
var explosion_scene = load("res://Entities/Explosion/ExplosionAOE.tscn")

# Hit at target
@onready var shapecast2d : ShapeCast2D = $ShapeCast2D

func _ready():
	pass
	#set_target_global_position(Vector2(global_position.x + 320, global_position.y + 0))
	#call_deferred("_test")

func _physics_process(delta):
	#return
	# Calculate the direction from the Coin to the player
	var direction = initial_position.direction_to(target_position)
	var distance_to_target = global_position.distance_to(target_position)
	
	# Arch
	var distance_ratio = linear_position.distance_to(target_position) / initial_distance
	var z_height = parabolic_curve.sample(distance_ratio)
	
	# Move the projectile directly towards the target position
	linear_position += direction * calculated_speed * delta
	# Curve the projectile in the air towards target position
	curve_position = Vector2(linear_position.x, linear_position.y - (z_height * parabolic_curve_max_height))
	
	# Check if the projectile has reached the target
	if initial_position.distance_to(linear_position) > initial_distance:
		# The projectile has reached the target, so you can handle that here
		_reached_target()
	
	# If it's projectile that doesn't arch
	if not arch_and_explode:
		# Check for collision ahead
		shapecast2d.target_position = direction * calculated_speed * delta
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

func _test():
	var line2d = Line2D.new()
	line2d.set_width(3)
	line2d.default_color = Color(1, 1, 0)  # Yellow color
	get_tree().get_root().add_child(line2d)
	line2d.points = [initial_position, target_position]
	# Create enemy for testing
	var enemy_scene = load("res://Entities/Enemy/Enemy.tscn")
	var enemy = enemy_scene.instantiate()
	get_tree().get_root().add_child(enemy)
	enemy.global_position = global_position + Vector2(128.0, 0)
