extends Sprite2D

# Signals
signal signal_build_state(current_state)

# Cells
var initial_cell_size : float = 128.0
var cell_size : float = initial_cell_size
var cell_scale : float = 1.0
var game_grid_cell_size_halved : float = GameGrid.cell_size * 0.5

# UI Transparency
@onready var highlight_square_sprite : Sprite2D = $HighlightSquare
var grid_transparency : float = 0.8
var highlight_transparency : float = 0.3

# UI Colors
var color_build_open : Color = Color("#00D39B")
var color_build_blocked : Color = Color("#FF0000")

# Build state
enum build_state { OPEN, BLOCKED }
var build_current_state = build_state.OPEN

# Objects in build area
var nodes_in_build_area_list : Array = []

# Collision checker
@onready var area_2d : Area2D = $HighlightSquare/Area2D
@onready var area_2d_collision_shape : CollisionShape2D = $HighlightSquare/Area2D/CollisionShape2D
var collision_shape_padding : int = 4

func _ready():
	Main.signal_add_player.connect(_on_player_add)
	
	# Rescale cell size
	cell_scale = initial_cell_size / GameGrid.cell_size
	cell_size = initial_cell_size * cell_scale # Rescale cell_size
	
	# Node scale
	scale = Vector2(cell_scale, cell_scale)
	
	# Grid transparency
	self_modulate.a = grid_transparency
	
	# Highlight square state color
	update_build_state()
	
	# Collision detector
	var collsion_shape_size = int(cell_size) - collision_shape_padding * 2
	var half_collision_shape_size : float = collsion_shape_size * 0.5
	area_2d_collision_shape.shape.size = Vector2(collsion_shape_size, collsion_shape_size)
	area_2d.position = Vector2(collision_shape_padding + half_collision_shape_size, collision_shape_padding + half_collision_shape_size) # Offset the collision shape

func _on_player_add(pass_player):
	pass_player.signal_share_player_position.connect(_update_position)

func _update_position(set_position):
	# Set GRID position
	var offset_grid_to_center_player = Vector2(set_position.x + game_grid_cell_size_halved, set_position.y + game_grid_cell_size_halved)
	global_position = GameGrid.snap_coordinate_to_grid_top_left_corner(offset_grid_to_center_player)
	# Set HIGHLIGHT SQUARE position
	highlight_square_sprite.global_position = GameGrid.snap_coordinate_to_grid_top_left_corner(set_position)

func update_build_state():
	# Highlight square state color
	highlight_square_sprite.self_modulate = color_build_open if build_current_state == build_state.OPEN else color_build_blocked
	# Set transparency
	highlight_square_sprite.self_modulate.a = highlight_transparency
	# Build state
	emit_signal("signal_build_state")
	

func _on_area_2d_body_entered(body):
	if not body == Main.player_node:
		nodes_in_build_area_list.push_back(body)
		build_current_state = build_state.BLOCKED
		update_build_state()

func _on_area_2d_body_exited(body):
	nodes_in_build_area_list.erase(body)
	if nodes_in_build_area_list.size() == 0:
		build_current_state = build_state.OPEN
	update_build_state()
