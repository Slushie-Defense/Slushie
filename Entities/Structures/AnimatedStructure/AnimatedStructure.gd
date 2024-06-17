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

func _ready():
	position = Vector2(540, 540)
	_change_weapon(weapon_class)

func _change_weapon(weapon):
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
		base.z_index = 1

func _process(delta):
	pass
