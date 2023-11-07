extends Node2D

@onready var sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shot_delay_timer : Timer = $ShotDelayTimer
@onready var line_2d : Line2D = $Line2D

enum structure_type { INSTANT, PROJECTILE, SIEGE, FENCE }
@export var structure = structure_type.INSTANT

var projectile_scene = load("res://Entities/Projectile/Projectile.tscn")
var sound_shoot = load("res://Entities/Weapons/Sounds/Splat.wav")
var sound_reload = load("res://Entities/Weapons/Sounds/Reload.wav")

var delay_between_shots : float = 0.5
var reload_time : float = 2.0

var shots_before_reload : int = 5
var shot_counter : int = 1 # Start at 1

# Raycast
@onready var raycast_2d : RayCast2D = $RayCast2D
var number_of_rays : int = 1
var angle_range : float = 30.0  # Angle range in degrees

# Enemy targeting
@onready var shapecast_2d : ShapeCast2D = $ShapeCast2D
@export var autotarget_enemy : bool = true

# Targeting
var attack_range : float = 0.0
var relative_target_position : Vector2 = Vector2(0, 512)
var attack_damage : int = 15

func _ready():
	# Start firing if it is not a fence
	if not structure == structure_type.FENCE:
		shot_delay_timer.wait_time = delay_between_shots
		shot_delay_timer.start()

func _on_shot_delay_timer_timeout():	
	if shot_counter >= shots_before_reload:
		#print("Reload")
		reload_weapon()
	else:
		#print("Fire! " +str(shot_counter))
		fire_weapon()

func _play_reload_sound():
	sound_player.stream = sound_reload
	sound_player.play()

func reload_weapon():
	# Play the reload sound just before the end of the reload timer
	var reload_sound_time : float = 0.75
	get_tree().create_timer(reload_time - reload_sound_time).timeout.connect(_play_reload_sound)
	# Reload weapon
	shot_counter = 0 # Reset
	shot_delay_timer.wait_time = reload_time
	shot_delay_timer.start()

func fire_weapon():
	# Fire weapon
	shot_delay_timer.wait_time = delay_between_shots
	shot_delay_timer.start()
	# Sweep the area
	var found_target = find_target_position()
	# If nothing is found. Do not fire, just check again next shot
	if not found_target:
		return
	# Fire AOE Projectile
	if structure == structure_type.SIEGE:
		fire_projectile_explosion()
	# Fire the shot
	if structure == structure_type.INSTANT:
		fire_instant_hit()
	# Fire bullet
	if structure == structure_type.PROJECTILE:
		fire_projectile_bullet()
	# Draw the line
	#draw_line2d(raycast_2d)
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
	projectile.global_position = global_position
	projectile.arch_and_explode = arch_and_explode
	projectile.set_target_global_position(global_position + relative_target_position)
	return projectile
	
func fire_projectile_explosion():
	var projectile = create_projectile()
	projectile.attack_damage = 100.0

func fire_projectile_bullet():
	var projectile = create_projectile(false)
	projectile.attack_damage = 20.0

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
			attack.damage = attack_damage
			first_collision_result.attack(attack)

func draw_line2d(passed_raycast):
	# Line 2D
	var global_position_of_hit : Vector2 = passed_raycast.get_collision_point()
	var relative_position_of_hit : Vector2 = global_position_of_hit - global_position if passed_raycast.is_colliding() else relative_target_position 
	line_2d.points = [Vector2.ZERO, relative_position_of_hit]
	get_tree().create_timer(0.1).timeout.connect(clear_line_2d)

func clear_line_2d():
	line_2d.points = [Vector2.ZERO, Vector2.ZERO]
