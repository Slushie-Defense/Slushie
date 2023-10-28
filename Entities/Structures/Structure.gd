extends Node2D

@onready var area_2d : Area2D = $Area2D
@onready var area_2d_collision_shape_2d : CollisionShape2D = $Area2D/CollisionShape2D

@onready var static_body_2d : StaticBody2D = $StaticBody2D
@onready var static_body_2d_collision_shape_2d : CollisionShape2D = $StaticBody2D/CollisionShape2D

# Building construction
var is_building_constructed : bool = false

# Objects in build area
var nodes_in_build_area_list : Array = []

func _ready():
	# Create the collision mask and player detection
	var padding = 8
	var collision_shape_size : Vector2 = Vector2(GameGrid.cell_size - padding, GameGrid.cell_size - padding)
	area_2d_collision_shape_2d.shape.size = collision_shape_size
	static_body_2d_collision_shape_2d.shape.size = collision_shape_size
	# If the area is clear create the building
	_initialize_building_construction()

func _on_area_2d_body_entered(body):
	nodes_in_build_area_list.push_back(body)

func _on_area_2d_body_exited(body):
	nodes_in_build_area_list.erase(body)
	_initialize_building_construction()

func _initialize_building_construction():
	if not is_building_constructed:
		# If there is no objects colliding. Turn collision rectangle on
		static_body_2d_collision_shape_2d.disabled = nodes_in_build_area_list.size() > 0
		modulate.a = 1.0 if nodes_in_build_area_list.size() == 0 else 0.4
		is_building_constructed = true
