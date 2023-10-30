extends StaticBody2D

@onready var health : ProgressBar = $Healthbar

@onready var area_2d_collision_shape_2d : CollisionShape2D = $Area2D/CollisionShape2D
@onready var static_body_2d_collision_shape_2d : CollisionShape2D = $CollisionShape2D

# Building construction
var is_building_constructed : bool = false

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
	_initialize_building_construction()

func _initialize_building_construction():
	if not is_building_constructed:
		# If there is no objects colliding. Turn collision rectangle on
		static_body_2d_collision_shape_2d.disabled = nodes_in_build_area_list.size() > 0
		modulate.a = 1.0 if nodes_in_build_area_list.size() == 0 else 0.4
		is_building_constructed = true

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
