extends Node2D

@export_enum("Instant", "Projectile", "Siege") var weapon_class : String = "Siege"

@onready var turret : Sprite2D = $Turret
@onready var base : Sprite2D = $Base

var turret_instant = load("res://Sprites/Structures/Instant/Slushie_Final_Turrets_Single_Base.png")
var base_instant = load("res://Sprites/Structures/Instant/Slushie_Final_Turrets_Single_Leg.png")

var turret_siege = load("res://Sprites/Structures/Siege/Slushie_Final_Turrets_Seige_Barrel.png")
var base_siege = load("res://Sprites/Structures/Siege/Slushie_Final_Turrets_Seige_Base.png")

var turret_projectile = load("res://Sprites/Structures/Projectile/Slushie_Final_Turrets_InstantShot_Nozzle.png")
var base_projectile = load("res://Sprites/Structures/Projectile/Slushie_Final_Turrets_InstantShot_Stool.png")

var downward_angle_limit : int = 20

var x_scale : float = 1.0
var y_scale : float = 1.0

func _ready():
	position = Vector2(540, 540)
	_change_weapon(weapon_class)

func _change_weapon(weapon):
	# Baseline
	turret.offset = Vector2.ZERO
	turret.position = Vector2.ZERO
	turret.z_index = 0
	base.z_index = 0
	# BASELINE
	if weapon == "Instant":
		turret.texture = turret_instant
		base.texture = base_instant
	elif weapon == "Projectile":
		turret.texture = turret_projectile
		base.texture = base_projectile
	elif weapon == "Siege":
		turret.texture = turret_siege
		base.texture = base_siege
		# Unique
		base.z_index = 1
		var shift_y : int = 24
		turret.position.y = shift_y
		turret.offset.y = -shift_y

func _process(delta):
	var target_position = get_global_mouse_position()
	var turret_angle = global_position.angle_to_point(target_position)
	var turret_deg = rad_to_deg(turret_angle)
	var turret_clamped = turret_deg
	
	if turret_deg > downward_angle_limit and turret_deg < 90:
		turret_clamped = downward_angle_limit
	if turret_deg > 90 and turret_deg < 180 - downward_angle_limit:
		turret_clamped = 180 - downward_angle_limit

	turret.rotation = deg_to_rad(turret_clamped) + deg_to_rad(90)
	
	var shoot = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if shoot:
		turret.scale.x = 0.8
		turret.scale.y = 1.2

	turret.scale.x = lerpf(turret.scale.x, 1.0, 0.1)
	turret.scale.y = lerpf(turret.scale.y, 1.0, 0.1)
