extends CharacterBody2D

# Health
@onready var health : ProgressBar = $Healthbar

# Physics
var MAX_SPEED : float = 100
var ACCELERATION : float = 2000
var motion : Vector2 = Vector2.ZERO # Equaliant to Vector2(0,0)

# AI
var ai_direction : Vector2 = Vector2(-1, 0) # Defaults to left
var ai_chase_node_list : Array = []
var ai_attack_node_list : Array = []
var ai_chase_node = null
var ai_default_direction : Vector2 = Vector2(-1, 0)

# How far the enemy can see
var vision_radius : int = 160
var show_vision_radius : bool = true
@onready var vision_collider : CollisionShape2D = $Vision/CollisionShape2D
@onready var vision_sprite : Sprite2D = $Vision/VisionCircle

# Attack Range
@onready var attack_range_raycast : RayCast2D = $AttackRangeRayCast
@onready var attack_timer : Timer = $AttackDelayTimer
var attack_speed : float = 1.0 # In seconds
var attack_range : int = 64 # In pixels
var attack_damage : int = 100

# Coins
var coin_value : int = 100
var coin_scene = load("res://Entities/Coin/Coin.tscn")

# Initialize
func _ready():
	# Behavior after the Gas Station is destroyed
	Main.signal_gas_station_destroyed.connect(_gas_station_destroyed)
	# Set health
	health.set_max_health(100)
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	# Set attack speed
	set_attack_speed(attack_speed) # Set to default
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
	# Direction & Attack
	_ai_process()
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
		
func _ai_process():
	# Direction priority
	ai_direction = ai_default_direction # Default goes left
	
	# Chase nodes
	if ai_chase_node_list.size() > 0:
		var nearest_distance = INF # Initialize with a very large value
		ai_chase_node = null # Default to null
	
		# Chase the nearest node
		for child in ai_chase_node_list:
			var distance_to_child = global_position.distance_to(child.global_position)
			if distance_to_child < nearest_distance:
				nearest_distance = distance_to_child
				ai_chase_node = child
		
		# Found an object to chase
		if ai_chase_node != null:
			ai_direction = global_position.direction_to(ai_chase_node.global_position)
			# Try to attack if available
			if attack_timer.is_stopped():
				attack_timer.start()

func set_attack_speed(value):
	attack_timer.wait_time = value
	attack_speed = value

func _on_attack_delay_timer_timeout():
	# Attack
	if ai_chase_node != null:
		var distance_to_node = global_position.distance_to(ai_chase_node.global_position)
		# Attack within the attack range
		attack_range_raycast.target_position = global_position.direction_to(ai_chase_node.global_position) * attack_range
		attack_range_raycast.force_raycast_update() # Launch the ray
		# See what it hit
		var first_collision_result = attack_range_raycast.get_collider()
		if first_collision_result != null:
			# If it hits something it can attack
			if first_collision_result.has_method("attack"):
				# Create an attack class and pass it through
				var attack = Attack.new()
				attack.damage = attack_damage
				first_collision_result.attack(attack)

func _on_vision_body_entered(body):
	if body.has_method("attack"):
		ai_chase_node_list.push_back(body)

func _on_vision_body_exited(body):
	ai_chase_node_list.erase(body)

func attack(attack : Attack):
	health.add_or_subtract_health_by_value(-attack.damage) # Subtract damage
	
func _event_health_is_zero():
	# Spawn coin where it dies
	_spawn_coin() 
	# Destroy enemy
	call_deferred("queue_free")
	print("Enemy died!")

func _spawn_coin():
	# Spawn coin
	var coin = coin_scene.instantiate()
	get_tree().get_root().add_child(coin)
	coin.global_position = global_position

func _gas_station_destroyed():
	ai_default_direction = Vector2(0, 0)
