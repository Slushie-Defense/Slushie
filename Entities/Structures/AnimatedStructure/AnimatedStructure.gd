extends Node2D

@export_enum("Instant", "Projectile", "Siege") var weapon_class : String = "Siege"

@onready var turret : Sprite2D = $Turret
@onready var base : Sprite2D = $Base
@onready var end_point : Sprite2D = $Turret/EndPoint

var turret_instant = load("res://Sprites/Structures/Instant/Slushie_Final_Turrets_Single_Base.png")
var base_instant = load("res://Sprites/Structures/Instant/Slushie_Final_Turrets_Single_Leg.png")

var turret_siege = load("res://Sprites/Structures/Siege/Slushie_Final_Turrets_Seige_Barrel.png")
var base_siege = load("res://Sprites/Structures/Siege/Slushie_Final_Turrets_Seige_Base.png")

var turret_projectile = load("res://Sprites/Structures/Projectile/Slushie_Final_Turrets_InstantShot_Nozzle.png")
var base_projectile = load("res://Sprites/Structures/Projectile/Slushie_Final_Turrets_InstantShot_Stool.png")

var downward_angle_limit : int = 15
var sprite_angle_shift : int = 90

var x_scale : float = 1.0
var y_scale : float = 1.0

var turret_end_point : Vector2 = Vector2.ZERO

func _ready():
	position = Vector2(540, 540)
	_change_weapon(weapon_class)

func _change_weapon(weapon):
	# Baseline
	downward_angle_limit = 15
	turret.z_index = 0
	base.z_index = 0
	sprite_angle_shift = 90
	turret_end_point = Vector2.ZERO
	# BASELINE
	if weapon == "Instant":
		turret.texture = turret_instant
		base.texture = base_instant
		# Properties
		turret.position =  Vector2(0,0)
		turret.offset = Vector2(0,0)
		sprite_angle_shift = 0
		downward_angle_limit = 45
		end_point.position = Vector2(48,-4)
	elif weapon == "Projectile":
		turret.texture = turret_projectile
		base.texture = base_projectile
		# Properties
		turret.position =  Vector2(-16,-20)
		turret.offset = Vector2(16,20)
		sprite_angle_shift = 0
		downward_angle_limit = 45
		end_point.position = Vector2(64,4)
	elif weapon == "Siege":
		turret.texture = turret_siege
		base.texture = base_siege
		# Properties
		base.z_index = 1
		turret.position = Vector2(0,-16)
		turret.offset = Vector2(16,0)
		downward_angle_limit = 15
		sprite_angle_shift = 0
		end_point.position = Vector2(64,4)

func _process(delta):
	var target_position = get_global_mouse_position()
	var turret_angle = global_position.angle_to_point(target_position)
	
	"""
	var turret_deg = rad_to_deg(turret_angle)
	var turret_clamped = turret_deg
	if turret_deg > downward_angle_limit and turret_deg < 90:
		turret_clamped = downward_angle_limit
	if turret_deg > 90 and turret_deg < 180 - downward_angle_limit:
		turret_clamped = 180 - downward_angle_limit
	"""
	
	turret.rotation = turret_angle + deg_to_rad(sprite_angle_shift)
	
	var shoot = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if shoot:
		_shoot_animation()

	# Reset
	turret.scale.x = lerpf(turret.scale.x, 1.0, 0.1)
	turret.scale.y = lerpf(turret.scale.y, 1.0, 0.1)

func _shoot_animation():
	turret.scale.x = 0.8
	turret.scale.y = 1.2
