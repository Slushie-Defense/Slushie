extends CharacterBody2D

# State
enum enemy_states { SPAWN, IDLE, CHASE, ATTACK, DEAD }
var enemy_state = enemy_states.SPAWN

# Enemy Data
var enemy_data : EnemyData = EnemyData.new()
@export var enemy_type : UnitData.enemy_list = UnitData.enemy_list.BASIC

# Sprite
@onready var character_sprite : Sprite2D = $CharacterSprite

# Collision Shape
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

# Health
@onready var health : ProgressBar = $Healthbar

# Physics
var motion : Vector2 = Vector2.ZERO # Equaliant to Vector2(0,0)

# AI
var ai_direction : Vector2 = Vector2(-1, 0) # Defaults to left
var ai_chase_node_list : Array = []
var ai_attack_node_list : Array = []
var ai_chase_node = null
var ai_default_direction : Vector2 = Vector2(-1, 0)

# How far the enemy can see
var show_vision_radius : bool = true
@onready var vision_collider : CollisionShape2D = $Vision/CollisionShape2D
@onready var vision_sprite : Sprite2D = $Vision/VisionCircle

# Attack Range
@onready var attack_range_raycast : RayCast2D = $AttackRangeRayCast
@onready var attack_timer : Timer = $AttackDelayTimer

# Coins
var coin_spawner = load("res://Entities/Coin/CoinSpawner.tscn")

# Weapon base
var weapon_base_scene = load("res://Entities/Weapons/WeaponBase.tscn")
var weapon_base : Node2D = null

# Initialize
func _ready():
	# Behavior after the Gas Station is destroyed
	Main.signal_gas_station_destroyed.connect(_gas_station_destroyed)
	# Set enemy type
	_set_enemy_type()
	# Set health
	health.set_max_health(enemy_data.health)
	print(str(enemy_data.unit_name) + " Health: " + str(enemy_data.health))
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	# Set attack speed
	_update_attack_speed() # Set to default
	# Update vision radius
	_update_vision_radius()
	# SPAWN
	enemy_state = enemy_states.SPAWN

func _set_enemy_type():
	# Set the enemy type
	match enemy_type:
		UnitData.enemy_list.BASIC:
			enemy_data = UnitData.BASIC
		UnitData.enemy_list.GRUNT:
			enemy_data = UnitData.GRUNT
		UnitData.enemy_list.SPITTER:
			_create_spitter()
		UnitData.enemy_list.FLOATER:
			enemy_data = UnitData.FLOATER
		UnitData.enemy_list.TANK:
			enemy_data = UnitData.TANK
	
	# Set texture
	character_sprite.texture = enemy_data.basic_sprite
	# Set collision shape
	collision_shape.shape.radius = enemy_data.collision_shape_radius

# Called every frame
func _physics_process(delta):
	# Direction & Attack
	_ai_process()
	# Move
	apply_movement(ai_direction * enemy_data.acceleration * delta)
	# Apply the motion
	velocity = motion
	# Move to the position unless it hits a collision then it will stop at the collision point
	move_and_slide()

func apply_movement(acceleration):
	motion += acceleration
	if motion.length() > enemy_data.max_speed:
		motion = motion.normalized() * enemy_data.max_speed
		
func _ai_process():
	# Direction priority
	ai_direction = ai_default_direction # Default goes left
	enemy_state = enemy_states.IDLE
	
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
			enemy_state = enemy_states.CHASE
			ai_direction = global_position.direction_to(ai_chase_node.global_position)
			# Try to attack if available
			# No need to attack if the enemy has a weapon attached
			if not enemy_data.attack_type == UnitData.enemy_attack_list.SIEGE:
				if attack_timer.is_stopped():
					attack_timer.start()

func _update_attack_speed():
	attack_timer.wait_time = enemy_data.attack_speed

func _on_attack_delay_timer_timeout():
	# Attack
	if ai_chase_node != null:
		var distance_to_node = global_position.distance_to(ai_chase_node.global_position)
		# Attack within the attack range
		attack_range_raycast.target_position = global_position.direction_to(ai_chase_node.global_position) * enemy_data.attack_range
		attack_range_raycast.force_raycast_update() # Launch the ray
		# See what it hit
		var first_collision_result = attack_range_raycast.get_collider()
		if first_collision_result != null:
			# If it hits something it can attack
			if first_collision_result.has_method("attack"):
				# Create an attack class and pass it through
				_enemy_is_attacking(first_collision_result)
				# This is a MELEE ATTACK
				match enemy_data.attack_type:
					UnitData.enemy_attack_list.MELEE:
						var attack = Attack.new()
						attack.damage = enemy_data.attack_damage
						first_collision_result.attack(attack)
					UnitData.enemy_attack_list.EXPLODE:
						_explode_attack()

func _enemy_is_attacking(target_node):
	# This triggered whenever the enemy is attacking -- Incldding if it is a weapon
	enemy_state = enemy_states.ATTACK
	# What type of attack is is doing
	#match enemy_data.attack_type:
	#	UnitData.enemy_attack_list.MELEE:
	#		pass
	#	UnitData.enemy_attack_list.EXPLODE:
	#		pass
	#	UnitData.SPITTER_SIEGE:
	#		pass

func _create_spitter():
	# Set enemy data
	enemy_data = UnitData.SPITTER
	# Create the weapon base
	weapon_base = weapon_base_scene.instantiate() # Connect to weapon destroyed
	weapon_base.signal_weapon_destroyed.connect(_event_health_is_zero) # If the weapon is destroyed the health is zero
	weapon_base.weapon_data = UnitData.SPITTER_SIEGE # Set weapon type
	weapon_base.position = Vector2.ZERO
	add_child(weapon_base) # Add to structure
	# Connect to attack function
	weapon_base.signal_weapon_is_attacking.connect(_enemy_is_attacking)

func _update_vision_radius():
	# Update the enemy vision radius -- Right now it is just a circle
	vision_collider.shape.radius = enemy_data.vision_radius
	# Show vision
	if show_vision_radius:
		var sprite_width : float = 128.0
		var vision_diameter : float = enemy_data.vision_radius * 2.0
		var sprite_scale : float = vision_diameter / sprite_width
		vision_sprite.scale = Vector2(sprite_scale, sprite_scale)
	else:
		vision_sprite.hide()

func _explode_attack():
	var explosion_scene = load("res://Entities/Explosion/ExplosionAOE.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.attack_damage = enemy_data.attack_damage
	explosion.collision_mask_list = enemy_data.attack_collision_mask_list
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position
	# Destroy self
	_event_health_is_zero()

func _on_vision_body_entered(body):
	if body.has_method("attack"):
		ai_chase_node_list.push_back(body)

func _on_vision_body_exited(body):
	ai_chase_node_list.erase(body)

func attack(attack : Attack):
	health.add_or_subtract_health_by_value(-attack.damage) # Subtract damage when hit by weapon
	
func _event_health_is_zero():
	# Died
	enemy_state = enemy_states.DEAD
	# Spawn coin where it dies
	_spawn_coin() 
	# Destroy enemy
	call_deferred("queue_free")
	print("Enemy died!")

func _spawn_coin():
	# Spawn coin
	var coins = coin_spawner.instantiate()
	coins.number_of_coins = ceil(enemy_data.coin_drop_value / 100.0)
	coins.randomize_postion = true
	get_tree().get_root().add_child(coins)
	coins.global_position = global_position

func _gas_station_destroyed():
	ai_default_direction = Vector2(0, 0)
