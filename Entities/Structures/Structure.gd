extends Node2D

@onready var area_2d : Area2D = $Area2D
@onready var collision_shape_2d : CollisionShape2D = $Area2D/CollisionShape2D

# Building
var construction_started : bool = false

# Padding
var padding = 8

# Objects in build area
var nodes_in_build_area_list : Array = []

func _ready():
	collision_shape_2d.shape.size = Vector2(GameGrid.cell_size - padding, GameGrid.cell_size - padding)
	# Show as semi-transparent when building
	modulate.a = 0.4

func _on_area_2d_body_entered(body):
	nodes_in_build_area_list.push_back(body)

func _on_area_2d_body_exited(body):
	nodes_in_build_area_list.erase(body)
	if nodes_in_build_area_list.size() == 0:
		# Convert to Static body
		var static_body_2d : StaticBody2D = StaticBody2D.new()
		add_child(static_body_2d)
		# Static body 2d Collision Sape
		call_deferred("_add_collision_shape", static_body_2d)
		# Remove Area 2D
		area_2d.queue_free()
		# Construction has to started
		modulate.a = 1.0 # Make fully visible
		construction_started = true

func _add_collision_shape(static_body_2d):
	# Static body 2d Collision Sape
	var static_body_2d_collision_shape_2d : CollisionShape2D = CollisionShape2D.new()
	static_body_2d_collision_shape_2d.shape = RectangleShape2D.new()
	static_body_2d_collision_shape_2d.shape.size = Vector2(GameGrid.cell_size, GameGrid.cell_size)
	static_body_2d.add_child(static_body_2d_collision_shape_2d)
