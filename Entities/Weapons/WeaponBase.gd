extends Node2D

signal signal_weapon_destroyed()

@onready var sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shot_delay_timer : Timer = $ShotDelayTimer
@onready var weapon_attack_line2d : Line2D = $WeaponAttackLine

# Show collision shape
@onready var weapon_range_indicator : Line2D = $WeaponRangeIndicator

# Explosion at target
var explosion_scene = load("res://Entities/Explosion/ExplosionAOE.tscn")

# Projectiles
var projectile_scene = load("res://Entities/Projectile/Projectile.tscn")
var sound_shoot = load("res://Entities/Weapons/Sounds/Splat.wav")
var sound_reload = load("res://Entities/Weapons/Sounds/Reload.wav")

# Default weapon data stats
var structure_type = UnitData.structure_list
var weapon_data : StructureData = StructureData.new() # Replace with specific structure

# Track shot count
var shot_counter : int = 1 # Start at 1 to remove glitch shot

# Raycast
@onready var raycast_2d : RayCast2D = $RayCast2D

# Enemy targeting
@onready var shapecast_2d : ShapeCast2D = $ShapeCast2D
var autotarget_enemy : bool = true

# Targeting
var relative_target_position : Vector2 = Vector2(0, 512)

func _ready():
	# Start firing immediately
	shot_delay_timer.wait_time = weapon_data.delay_between_shots
	shot_delay_timer.start()
	# Show weapon range indicator
	_update_weapon_range()
	# Update collision masks
	_update_collsion_mask_layers()

func _update_collsion_mask_layers():
	match weapon_data.type:
		structure_type.LANDMINE:
			shapecast_2d.set_collision_mask_value(4, true)
			shapecast_2d.set_collision_mask_value(6, false) # Can't see floaters

func _update_weapon_range():
	var offset = (weapon_data.attack_range * 0.5) - weapon_data.attack_radius
	var weapon_offset = Vector2(offset, 0)
	# Default settings
	shapecast_2d.shape = CapsuleShape2D.new()
	# Weapon range Shapecast2D
	shapecast_2d.shape.radius = weapon_data.attack_radius
	shapecast_2d.shape.height = weapon_data.attack_range
	shapecast_2d.position = weapon_offset
	# Weapon range indictator
	var one_pixel_offset : int = 1 # Add one pixel to the x-axis so that the Landmine remains visible
	#weapon_range_indicator.default_color = Color("#FFD500")
	weapon_range_indicator.default_color.a = 0.08
	weapon_range_indicator.width = weapon_data.attack_radius * 2
	weapon_range_indicator.points = [Vector2(0, 0), Vector2(weapon_data.attack_range - weapon_data.attack_radius - weapon_data.attack_radius + one_pixel_offset,0)]

func _on_shot_delay_timer_timeout():	
	if shot_counter >= weapon_data.shots_before_reload:
		reload_weapon()
	else:
		fire_weapon()

func _play_reload_sound():
	sound_player.stream = sound_reload
	sound_player.play()

func reload_weapon():
	# Play the reload sound just before the end of the reload timer
	var reload_sound_time : float = 0.75
	var reload_time : float = clamp(weapon_data.reload_time - reload_sound_time, reload_sound_time, INF)
	get_tree().create_timer(reload_time).timeout.connect(_play_reload_sound)
	# Reload weapon
	shot_counter = 0 # Reset
	shot_delay_timer.wait_time = weapon_data.reload_time
	shot_delay_timer.start()

func fire_weapon():
	# Fire weapon
	shot_delay_timer.wait_time = weapon_data.delay_between_shots
	shot_delay_timer.start()
	# Sweep the area
	var found_target = find_target_position()
	# If nothing is found. Do not fire, just check again next shot
	if not found_target:
		return
	# Fire AOE Projectile
	match weapon_data.type:
		structure_type.SIEGE:
			fire_projectile_explosion()
		# Fire the shot
		structure_type.INSTANT:
			fire_instant_hit()
		# Fire bullet
		structure_type.PROJECTILE:
			fire_projectile_bullet()
		# Check landmine
		structure_type.LANDMINE:
			fire_landmine_explosion()
	# Play sound
	sound_player.stream = sound_shoot
	sound_player.play()
	# Count shot
	shot_counter += 1

func find_target_position():
	if autotarget_enemy:
		# Completely random prioritization. Only searches for one enemy and aims at it, whatever it is
		# Doing this as an optimization
		shapecast_2d.force_shapecast_update() # Only enabled during the shot fired
		if shapecast_2d.is_colliding():
			var first_collision_result = shapecast_2d.get_collider(0)
			if first_collision_result != null:
				# If it hits something it can attack
				if first_collision_result.has_method("attack"):
					relative_target_position = first_collision_result.global_position - global_position
					return true
	return false

func create_projectile(arch_and_explode : bool = true):
	var projectile = projectile_scene.instantiate()
	get_tree().get_root().add_child(projectile)
	projectile._set_projectile_sprite(weapon_data.projectile_sprite)
	projectile._set_projectile_color(weapon_data.projectile_color)
	projectile.global_position = global_position
	projectile.arch_and_explode = arch_and_explode
	projectile.set_target_global_position(global_position + relative_target_position)
	return projectile
	
func fire_projectile_explosion():
	var projectile = create_projectile()
	projectile.attack_damage = weapon_data.attack_damage

func fire_projectile_bullet():
	var projectile = create_projectile(false)
	projectile.attack_damage = weapon_data.attack_damage

func fire_landmine_explosion():
	var mine_delay : float = weapon_data.delay_before_explode
	get_tree().create_timer(mine_delay).timeout.connect(_create_landmine_explosion)

func fire_instant_hit():
	raycast_2d.target_position = relative_target_position
	raycast_2d.force_raycast_update()
	# See what it hit
	var first_collision_result = raycast_2d.get_collider()
	if first_collision_result != null:
		# If it hits something it can attack
		if first_collision_result.has_method("attack"):
			# Create an attack class and pass it through
			var attack = Attack.new()
			attack.damage = weapon_data.attack_damage
			first_collision_result.attack(attack)
			# Draw the line
			draw_line2d(raycast_2d)

func draw_line2d(passed_raycast):
	# Line 2D
	var global_position_of_hit : Vector2 = passed_raycast.get_collision_point()
	var relative_position_of_hit : Vector2 = global_position_of_hit - global_position if passed_raycast.is_colliding() else relative_target_position 
	weapon_attack_line2d.points = [Vector2.ZERO, relative_position_of_hit]
	get_tree().create_timer(0.1).timeout.connect(clear_weapon_attack_line2d)

func clear_weapon_attack_line2d():
	weapon_attack_line2d.points = [Vector2.ZERO, Vector2.ZERO]

func _create_landmine_explosion():
	var explosion = explosion_scene.instantiate()
	explosion.attack_damage = weapon_data.attack_damage
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position
	# Destroy structure
	_self_destruct()

func _self_destruct():
	emit_signal("signal_weapon_destroyed")
	call_deferred("queue_free")

func weapon_range_indicator_visible(set_visibility):
	weapon_range_indicator.visible = set_visibility
