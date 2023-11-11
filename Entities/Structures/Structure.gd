extends StaticBody2D

@onready var health : ProgressBar = $Healthbar
@onready var area_2d_collision_shape_2d : CollisionShape2D = $Area2D/CollisionShape2D
@onready var static_body_2d_collision_shape_2d : CollisionShape2D = $CollisionShape2D
@onready var structure_sprite : Sprite2D = $StructureSprite

# Building construction
var is_building_constructed : bool = false
var is_weapon_assigned : bool = false
var weapon_base_scene = load("res://Entities/Weapons/WeaponBase.tscn")
var weapon_base : Node2D = null
var building_type : String = ""

# Objects in build area
var nodes_in_build_area_list : Array = []

func _ready():
	# Health
	health.set_max_health(300)
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	# Create the collision mask and player detection
	var padding = 8
	var collision_shape_size : Vector2 = Vector2(GameGrid.cell_size - padding, GameGrid.cell_size - padding)
	area_2d_collision_shape_2d.shape.size = collision_shape_size
	static_body_2d_collision_shape_2d.shape.size = collision_shape_size
	# If the area is clear create the building
	call_deferred("_initialize_building_construction")

func _initialize_building_construction():
	if not is_building_constructed:
		# If there is no objects colliding. Turn collision rectangle on
		static_body_2d_collision_shape_2d.disabled = nodes_in_build_area_list.size() > 0
		modulate.a = 1.0 if nodes_in_build_area_list.size() == 0 else 0.4
		is_building_constructed = true
		# Add weapon
		call_deferred("_add_weapon_base")

func attack(attack : Attack):
	health.add_or_subtract_health_by_value(-attack.damage) # Subtract damage

func _event_health_is_zero():
	print("Struture died!")
	call_deferred("queue_free")

func _on_area_2d_body_entered(body):
	nodes_in_build_area_list.push_back(body)

func _on_area_2d_body_exited(body):
	nodes_in_build_area_list.erase(body)
	_initialize_building_construction()

func _add_weapon_base():
	# Do not add weapon base if it is a fence or landmine
	if building_type == "fence":
		return
	# Create the weapon base
	weapon_base = weapon_base_scene.instantiate()
	# Setup weapon base
	match building_type:
		"seige":
			weapon_base.structure = weapon_base.structure_type.SIEGE
			structure_sprite.self_modulate = Color("#FFD500")
		"instant":
			weapon_base.structure = weapon_base.structure_type.INSTANT
			structure_sprite.self_modulate = Color("#EE00FF")
		"projectile":
			weapon_base.structure = weapon_base.structure_type.PROJECTILE
			structure_sprite.self_modulate = Color("#00D39B")
		"landmine":
			set_collision_layer_value(3, false) # Turn off the collision layer so that enemies can walk through it and do not attack it
			weapon_base.structure = weapon_base.structure_type.LANDMINE
			structure_sprite.self_modulate = Color("#FF0000")
	# Add to structure
	add_child(weapon_base)
	# Connect to weapon destroyed
	weapon_base.signal_weapon_destroyed.connect(_event_health_is_zero) # If the weapon is destroyed the health is zero

func _set_building_type(item_name):
	building_type = item_name
