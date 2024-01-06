extends CharacterBody2D

# State
var enemy_state = NodeStates.new()

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
var show_vision_radius : bool = false
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

# Animation Player
@onready var ap
var my_sprite
@onready var damage_flash_timer : Timer = $DamageFlashTimer

# Initialize
func _ready():
	# CollisionShape2D
	var new_collision_shape = collision_shape.shape.duplicate()
	collision_shape.shape = new_collision_shape	
	# Behavior after the Gas Station is destroyed
	Main.signal_gas_station_destroyed.connect(_gas_station_destroyed)
	# Set enemy type
	_set_enemy_type()
	# Set health
	health.set_max_health(enemy_data.health)
	# print(str(enemy_data.unit_name) + " Health: " + str(enemy_data.health))
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	health.always_hidden = true
	# Set attack speed
	_update_attack_speed() # Set to default
	# Update vision radius
	_update_vision_radius()
	# SPAWN
	enemy_state.current = enemy_state.list.SPAWN
	# Add Enemy
	Main.emit_signal("signal_update_enemy_count", 1)
	# Hurt effect
	health.signal_flash_effect.connect(_apply_hurt_effect)

func _apply_hurt_effect(flash_value):
	material.set_shader_parameter("flash_modifier", flash_value)

func _set_enemy_type():
	# Set the enemy type
	match enemy_type:
		UnitData.enemy_list.BASIC:
			enemy_data = UnitData.BASIC
			ap = $BasicAP
			$BasicSS.visible = true
			my_sprite = $BasicSS
			collision_shape.shape.set_size(Vector2(40, 20))
		UnitData.enemy_list.GRUNT:
			enemy_data = UnitData.GRUNT
			ap = $GruntAP
			$GruntSS.visible = true
			my_sprite = $GruntSS
			collision_shape.shape.set_size(Vector2(40, 20))
		UnitData.enemy_list.SPITTER:
			_create_spitter()
			ap = $SpitterAP
			$SpitterSS.visible = true
			my_sprite = $SpitterSS;
			collision_shape.shape.set_size(Vector2(100, 20))
		UnitData.enemy_list.FLOATER:
			enemy_data = UnitData.FLOATER
			ap = $FloaterAP
			$FloaterSS.visible = true
			my_sprite = $FloaterSS;
			collision_shape.shape.set_size(Vector2(40, 20))
		UnitData.enemy_list.TANK:
			enemy_data = UnitData.TANK
			ap = $TankAP
			$TankSS.visible = true
			my_sprite = $TankSS;
			collision_shape.shape.set_size(Vector2(200, 20))
	
	# Set texture
	character_sprite.texture = enemy_data.basic_sprite

var prevState = enemy_state.list.IDLE

func _process(delta):
	if (enemy_state.current != prevState):		
		match enemy_state.current:
			enemy_state.list.DIED:
				set_process(false)
				set_physics_process(false)
				return
			enemy_state.list.MOVING:
				ap.play("Move")
			enemy_state.list.ATTACK:
				ap.play("Attack")
	prevState = enemy_state.current

# Called every frame
func _physics_process(delta):
	if (enemy_state.current == enemy_state.list.DIED):
		return
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
	if motion.length() > 16:
		if (enemy_state.current != enemy_state.list.ATTACK):
			enemy_state.current = enemy_state.list.MOVING
		
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
			# Attack again
			if not enemy_data.attack_type == UnitData.enemy_attack_list.SIEGE:
				if attack_timer.is_stopped():
					attack_timer.start()
	
	var dirFlip = true if (ai_direction.x > 0) else false
	$BasicSS.flip_h = dirFlip
	$GruntSS.flip_h = dirFlip
	$FloaterSS.flip_h = dirFlip
	$TankSS.flip_h = dirFlip
	$SpitterSS.flip_h = dirFlip

func _update_attack_speed():
	attack_timer.wait_time = enemy_data.attack_speed

func _on_attack_delay_timer_timeout():	
	# Exit if dead?
	if (enemy_state.current == enemy_state.list.DIED):
		return
	# Attack
	if ai_chase_node != null:
		# var distance_to_node = global_position.distance_to(ai_chase_node.global_position)
		# Attack within the attack range
		attack_range_raycast.target_position = attack_range_raycast.global_position.direction_to(ai_chase_node.global_position) * enemy_data.attack_range
		attack_range_raycast.force_raycast_update() # Launch the ray
		# See what it hit
		var first_collision_result = attack_range_raycast.get_collider()
		if first_collision_result != null:
			enemy_state.current = enemy_state.list.ATTACK
			# If it hits something it can attack
			if first_collision_result.has_method("attack"):	
				# Create an attack class and pass it through
				_enemy_is_attacking(first_collision_result)
				# This is a MELEE ATTACK
				match enemy_data.attack_type:
					UnitData.enemy_attack_list.MELEE:
						$SFXGrunt2.play()
						var _attack = Attack.new()
						_attack.damage = enemy_data.attack_damage
						first_collision_result.attack(_attack)
					UnitData.enemy_attack_list.EXPLODE:
						_explode_attack()
		else:
			enemy_state.current = enemy_state.list.MOVING

func _enemy_is_attacking(_target_node):
	# This triggered whenever the enemy is attacking -- Incldding if it is a weapon
	enemy_state.current = enemy_state.list.ATTACK

func _create_spitter():
	# Set enemy data
	enemy_data = UnitData.SPITTER
	# Create the weapon base
	weapon_base = weapon_base_scene.instantiate() # Connect to weapon destroyed
	weapon_base.signal_weapon_destroyed.connect(_event_health_is_zero) # If the weapon is destroyed the health is zero
	weapon_base.weapon_data = UnitData.SPITTER_SIEGE # Set weapon type
	weapon_base.position = Vector2(-32, -48)
	add_child(weapon_base) # Add to structure
	# Connect to attack function
	weapon_base.signal_weapon_is_attacking.connect(_enemy_is_attacking)

func _update_vision_radius():
	# Update the enemy vision radius -- Right now it is just a circle
	vision_collider.shape.radius = enemy_data.vision_radius
	vision_sprite.visible = show_vision_radius
	# Show vision
	if show_vision_radius:
		var sprite_width : float = 128.0
		var vision_diameter : float = enemy_data.vision_radius * 2.0
		var sprite_scale : float = vision_diameter / sprite_width
		vision_sprite.scale = Vector2(sprite_scale, sprite_scale)

func _explode_attack():
	var explosion_scene = load("res://Entities/Explosion/ExplosionAOE.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.attack_damage = enemy_data.attack_damage
	explosion.collision_mask_list = enemy_data.attack_collision_mask_list
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position + Vector2(0, -64)
	# Destroy self
	_event_health_is_zero()

func _on_vision_body_entered(body):
	if body.has_method("attack"):
		ai_chase_node_list.push_back(body)

func _on_vision_body_exited(body):
	ai_chase_node_list.erase(body)

func attack(_attack : Attack):
	if (enemy_state.current == enemy_state.list.DIED):
		return
	health.add_or_subtract_health_by_value(-_attack.damage) # Subtract damage when hit by weapon
	my_sprite.modulate = Color.INDIAN_RED
	$SFXGrunt1.play()
	damage_flash_timer.start()
	
func _event_health_is_zero():
	if (enemy_state.current == enemy_state.list.DIED):
		return
	
	# Died
	enemy_state.current = enemy_state.list.DIED
	$SFXDeath.play()
	ap.play("Death")
	
	# Spawn coin where it dies
	_spawn_coin()

func _remove_enemy():
	Main.emit_signal("signal_update_enemy_count", -1)
	queue_free()

func _spawn_coin():
	# Spawn coin
	var coins = coin_spawner.instantiate()
	coins.number_of_coins = ceil(enemy_data.coin_drop_value / 5.0)
	coins.randomize_postion = true
	get_tree().current_scene.add_child(coins)
	coins.global_position = global_position

func _gas_station_destroyed():
	ai_default_direction = Vector2(0, 0)

func _on_basic_ap_animation_finished(anim_name):	
	if (anim_name == "Death"):
		_remove_enemy()

func _on_floater_ap_animation_finished(anim_name):
	var isDeath = (anim_name == "Death")
	var isAttack = (anim_name == "Attack")
	if (isDeath || isAttack):
		_remove_enemy()

func _on_grunt_ap_animation_finished(anim_name):
	if (anim_name == "Death"):
		_remove_enemy()

func _on_tank_ap_animation_finished(anim_name):
	if (anim_name == "Death"):
		_remove_enemy()

func _on_spitter_ap_animation_finished(anim_name):
	if (anim_name == "Death"):
		_remove_enemy()
	elif (anim_name == "Attack"):
		enemy_state.current = enemy_state.list.MOVING

func _on_damage_flash_timer_timeout():
	my_sprite.modulate = Color.WHITE	
