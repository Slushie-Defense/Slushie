extends Node2D

# Sprites
@onready var sprite_rescaling_parent : Node2D = $SpriteRescaler
var explosion_sprite_initial_size : float = 128.0

# Collision Detection
@onready var collision_detection : ShapeCast2D = $ShapeCast2D

# Damage
var damage_fallout_curve : Curve = load("res://Entities/Explosion/DamageFallout.tres") # Change if you want more than 8 nodes to register
var attack_damage : float = 100.0 # Max damage at Epicenter
var explosion_radius : float = 96.0
var max_number_nodes_that_can_be_detected : int = 8

# Friendly file or not
var collision_mask_list : Array = [[1, false], [2, false], [3, false], [4, true], [6, true]] # Attack enemies default

func _ready():
	# Sprite scale
	var explosion_diameter : float = explosion_radius * 2
	var sprite_scale = explosion_diameter / explosion_sprite_initial_size
	sprite_rescaling_parent.scale = Vector2(sprite_scale, sprite_scale)
	
	# Collision detection
	collision_detection.max_results = max_number_nodes_that_can_be_detected
	collision_detection.shape.radius = explosion_radius
	collision_detection.enabled = false
	
	# Attack ENEMY or FRIENDLY
	call_deferred("_update_collsion_mask_layers")

func _update_collsion_mask_layers():
	for i in range(0, collision_mask_list.size()):
		var layer = collision_mask_list[i][0]
		var value = collision_mask_list[i][1]
		collision_detection.set_collision_mask_value(layer, value)

func _deal_damage():
	#print("AOE went off!")
	collision_detection.enabled = true
	collision_detection.force_shapecast_update()
	if not collision_detection.is_colliding():
		return # Early exit
	
	# Collision check
	var number_of_collisions : int = collision_detection.get_collision_count()
	#print("Number of collisions: " + str(number_of_collisions))
	for i in range(0, number_of_collisions):
		var child = collision_detection.get_collider(i) # Get the object
		# Change the collision mask if this is supposed to do friendly fire
		if child.has_method("attack"): # Check if it has attack
			var distance_from_center : float = global_position.distance_to(child.global_position)
			var _attack = Attack.new()
			_attack.damage = attack_damage * damage_fallout_curve.sample(distance_from_center / explosion_radius)
			child.attack(_attack)
	
	# Turn off collision detection after use
	collision_detection.call_deferred("queue_free") # Remove from scene

func _on_delay_damage_timer_timeout():
	_deal_damage()

func _on_animation_player_animation_finished(_anim_name):
	call_deferred("queue_free") # Delete after the animation completes
