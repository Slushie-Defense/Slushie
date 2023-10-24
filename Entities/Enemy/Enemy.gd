extends CharacterBody2D

# Health
@onready var health_ui_progress_bar : ProgressBar = $Healthbar

# Physics
@export var MAX_SPEED : float = 100
var ACCELERATION : float = 2000
var motion : Vector2 = Vector2.ZERO # Equaliant to Vector2(0,0)

# AI
var ai_direction : Vector2 = Vector2(-1, 0) # Defaults to left
var ai_attack_node_list : Array = []

# How far the enemy can see
@export var vision_radius : int = 256
@export var show_vision_radius : bool = true
@onready var vision_collider : CollisionShape2D = $Area2D/CollisionShape2D
@onready var vision_sprite : Sprite2D = $Area2D/VisionCircle

# Initialize
func _ready():
	# Update the enemy vision radius -- Right now it is just a circle
	vision_collider.shape.radius = vision_radius
	# Show vision
	if show_vision_radius:
		var sprite_width : float = 128.0
		var vision_diameter : float = vision_radius * 2.0
		var sprite_scale : float = vision_diameter / sprite_width
		vision_sprite.scale = Vector2(sprite_scale, sprite_scale)
	else:
		vision_sprite.hide()
		

# Called every frame
func _physics_process(delta):
	# Choose direction
	_set_ai_direction()
	# Move
	apply_movement(ai_direction * ACCELERATION * delta)
	# Apply the motion
	velocity = motion
	# Move to the position unless it hits a collision then it will stop at the collision point
	move_and_slide()

func apply_movement(acceleration):
	motion += acceleration
	if motion.length() > MAX_SPEED:
		motion = motion.normalized() * MAX_SPEED
		
func _set_ai_direction():
	# Direction priority
	ai_direction = Vector2(-1, 0) # Default goes left
	if ai_attack_node_list.size() > 0:
		var nearest_distance = INF # Initialize with a very large value
		var nearest_node = null
	
		for child in ai_attack_node_list:
			var distance_to_child = global_position.distance_to(child.global_position)
			if distance_to_child < nearest_distance:
				nearest_distance = distance_to_child
				nearest_node = child
		
		if nearest_node != null:
			ai_direction = global_position.direction_to(nearest_node.global_position)

func _on_area_2d_body_entered(body):
	if body.has_method("is_attackable"):
		ai_attack_node_list.push_back(body)

func _on_area_2d_body_exited(body):
	# Remove from stack if it exists
	ai_attack_node_list.erase(body)
