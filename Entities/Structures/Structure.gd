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
var structure_class = UnitData.structure_list.FENCE

# Objects in build area
var nodes_in_build_area_list : Array = []

func _ready():
	# Health
	health.set_max_health(UnitData.FENCE.health) # Default is fence
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
		call_deferred("_convert_to_structure_type")

func attack(attack : Attack):
	health.add_or_subtract_health_by_value(-attack.damage) # Subtract damage

func _event_health_is_zero():
	print("Struture died!")
	call_deferred("queue_free")

func _on_area_2d_body_entered(body):
	if body.has_method("_is_player"):
		if is_weapon_assigned:
			weapon_base.weapon_range_indicator_visible(true)
			return
	nodes_in_build_area_list.push_back(body)

func _on_area_2d_body_exited(body):
	if body.has_method("_is_player"):
		if is_weapon_assigned:
			weapon_base.weapon_range_indicator_visible(false)
			return
	nodes_in_build_area_list.erase(body)
	_initialize_building_construction()

func _convert_to_structure_type():
	var structure_type = UnitData.structure_list
	# Set health
	health.set_max_health(structure_class.health)
	
	# Set placeholder sprite
	structure_sprite.texture = structure_class.ui_sprite
	
	# If its a fence, do not create a weapon base
	if structure_class.type == structure_type.FENCE:
		return # Early exit
	
	# Note if a weapon base has been attached
	is_weapon_assigned = not structure_class.type == structure_type.FENCE
		
	# Create the weapon base
	weapon_base = weapon_base_scene.instantiate()
	# Connect to weapon destroyed
	weapon_base.signal_weapon_destroyed.connect(_event_health_is_zero) # If the weapon is destroyed the health is zero
	# Set weapon type
	weapon_base.weapon_data = structure_class

	# Add to structure
	add_child(weapon_base)

func _set_structure_class(item_name):
	structure_class = item_name
