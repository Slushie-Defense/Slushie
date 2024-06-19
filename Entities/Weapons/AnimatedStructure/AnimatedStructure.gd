extends Node2D

@export_enum("Instant", "Projectile", "Siege") var weapon_class : String = "Siege"

@onready var canvas_group : CanvasGroup = $CanvasGroup
@onready var turret : Sprite2D = $CanvasGroup/Turret
@onready var base : Sprite2D = $CanvasGroup/Base
@onready var end_point : Node2D = $CanvasGroup/Turret/EndPoint
@onready var weapon_attack_line2d : Line2D = $WeaponAttackLine

var parent : Node2D = null

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
var target_position : Vector2 = Vector2.ZERO
var default_target_position : Vector2 = Vector2.ZERO

var y_sort_offset : Vector2 = Vector2(0, 48)
var weapon_instant : bool = false
var weapon_siege : bool = false

func _ready():
	default_target_position = Vector2(240, 0)
	_update_default_target_position.call_deferred()
	# This down shifts the graphic for correct y-sorting
	canvas_group.position += y_sort_offset

func _update_default_target_position():
	target_position = global_position + Vector2(240, -240)
	
func _change_weapon(weapon):
	# Baseline
	downward_angle_limit = 15
	sprite_angle_shift = 90
	turret_end_point = Vector2.ZERO
	# BASELINE
	if weapon == "Instant":
		turret.texture = turret_instant
		base.texture = base_instant
		# Properties
		turret.position =  Vector2(0,0)
		turret.offset = Vector2(0,0)
		end_point.position = Vector2(48,-4)
		weapon_instant = true
	elif weapon == "Projectile":
		turret.texture = turret_projectile
		base.texture = base_projectile
		# Properties
		turret.position =  Vector2(-16,-20)
		turret.offset = Vector2(16,20)
		sprite_angle_shift = 0
		end_point.position = Vector2(64,4)
	elif weapon == "Siege":
		# Change the base order
		var clone_base = base.duplicate()
		canvas_group.add_child(clone_base)
		base.queue_free()
		base = clone_base
		
		turret.texture = turret_siege
		base.texture = base_siege
		# Properties
		turret.position = Vector2(0,24)
		turret.offset = Vector2(24,0)
		sprite_angle_shift = 0
		end_point.position = Vector2(48,4)
		end_point.scale = Vector2(0.8, 0.8)
		
		weapon_siege = true
		default_target_position = Vector2(32, -96)
	
	base.position -= y_sort_offset
	turret.position -= y_sort_offset

func _process(delta):
	var turret_angle = global_position.angle_to_point(target_position)
	
	turret.rotation = turret_angle

	# Reset
	turret.scale.x = lerpf(turret.scale.x, 1.0, 0.1)
	turret.scale.y = lerpf(turret.scale.y, 1.0, 0.1)
	
	target_position.x = lerpf(target_position.x, global_position.x + default_target_position.x, 0.01)
	target_position.y = lerpf(target_position.y, global_position.y + default_target_position.y, 0.01)
	
	if parent == null:
		queue_free()
	
	# INSTANT ATTACK
	weapon_attack_line2d.global_position = global_position
	weapon_attack_line2d.points = [end_point.global_position - global_position, target_position - global_position]

func _shoot_animation():
	turret.scale.x = 0.8
	turret.scale.y = 1.2
	if weapon_instant:
		weapon_attack_line2d.visible = true
	elif weapon_siege:
		target_position = global_position + Vector2(0, -72)
	
	end_point.visible = true
	draw_line2d()

func draw_line2d():
	get_tree().create_timer(0.1).timeout.connect(clear_weapon_attack_line2d)

func clear_weapon_attack_line2d():
	end_point.visible = false
	weapon_attack_line2d.visible = false
