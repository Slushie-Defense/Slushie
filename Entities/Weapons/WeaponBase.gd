extends Node2D

@onready var sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shot_delay_timer : Timer = $ShotDelayTimer

@onready var line_2d : Line2D = $Line2D


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
var attack_target_position : Vector2 = Vector2(0, 512)
var attack_damage : int = 10

# Explosions
@export var explode_at_target : bool = false
var explosion_scene = load("res://Entities/Explosion/ExplosionAOE.tscn")

func _ready():
	shot_delay_timer.wait_time = delay_between_shots
	shot_delay_timer.start()

func _on_shot_delay_timer_timeout():	
	if shot_counter >= shots_before_reload:
		print("Reload")
		reload_weapon()
	else:
		print("Fire! " +str(shot_counter))
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
	shot_counter += 1
	shot_delay_timer.wait_time = delay_between_shots
	shot_delay_timer.start()
	# Play sound
	sound_player.stream = sound_shoot
	sound_player.play()
	# Sweep the area
	find_target_position()
	# Fire the shot
	fire_ray_cast()
	# Draw the line
	draw_line2d(raycast_2d)

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
					attack_target_position = first_collision_result.global_position - global_position

func fire_ray_cast():
	raycast_2d.target_position = attack_target_position
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
	var relative_position_of_hit : Vector2 = global_position_of_hit - global_position if passed_raycast.is_colliding() else attack_target_position 
	line_2d.points = [Vector2.ZERO, relative_position_of_hit]
	get_tree().create_timer(0.1).timeout.connect(clear_line_2d)

func clear_line_2d():
	line_2d.points = [Vector2.ZERO, Vector2.ZERO]
