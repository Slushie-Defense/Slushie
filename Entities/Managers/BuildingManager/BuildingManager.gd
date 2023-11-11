extends Sprite2D

# Scenes
var structure_scene = load("res://Entities/Structures/Structure.tscn")
var structure_position : Vector2 = Vector2.ZERO

# Cells
var initial_cell_size : float = 128.0
var cell_size : float = initial_cell_size
var cell_scale : float = 1.0
var game_grid_cell_size_halved : float = GameGrid.cell_size * 0.5

# UI Transparency
@onready var highlight_square_sprite : Sprite2D = $HighlightSquare
var grid_transparency : float = 0.0
var highlight_transparency : float = 0.3

# UI Colors
var color_build_open : Color = Color("#00D39B")
var color_build_blocked : Color = Color("#FF0000")

# UI Sound
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
var audio_ui_denied = load("res://Audio/UserInterface/AudioErrorSignal.wav")
var audio_ui_accept = load("res://Audio/UserInterface/AudioDropSignal.wav")

# Build state
enum build_state { OPEN, BLOCKED }
var build_current_state = build_state.OPEN
var selected_item_name : String = ""

# Objects in build area
var nodes_in_build_area_list : Array = []

# Collision checker
@onready var area_2d : Area2D = $HighlightSquare/Area2D
@onready var area_2d_collision_shape : CollisionShape2D = $HighlightSquare/Area2D/CollisionShape2D
var collision_shape_padding : int = 4

func _ready():
	Main.signal_add_player.connect(_on_player_add)
	Main.signal_selected_item_update.connect(_update_active_item)
	
	# Rescale cell size
	cell_scale = initial_cell_size / GameGrid.cell_size
	cell_size = initial_cell_size * cell_scale # Rescale cell_size
	
	# Node scale
	scale = Vector2(cell_scale, cell_scale)
	
	# Grid transparency
	self_modulate.a = grid_transparency
	
	# Highlight square state color
	_update_build_state()
	
	# Collision detector
	var collsion_shape_size = int(cell_size) - collision_shape_padding * 2
	var half_collision_shape_size : float = collsion_shape_size * 0.5
	area_2d_collision_shape.shape.size = Vector2(collsion_shape_size, collsion_shape_size)
	area_2d.position = Vector2(collision_shape_padding + half_collision_shape_size, collision_shape_padding + half_collision_shape_size) # Offset the collision shape

func _on_player_add(player):
	player.signal_share_player_position.connect(_update_position)

func _update_position(set_position):
	# Set GRID position
	var offset_grid_to_center_player = Vector2(set_position.x + game_grid_cell_size_halved, set_position.y + game_grid_cell_size_halved)
	global_position = GameGrid.snap_coordinate_to_grid_top_left_corner(offset_grid_to_center_player)
	# Set HIGHLIGHT SQUARE position
	structure_position = GameGrid.snap_coordinate_to_grid_top_left_corner(set_position)
	highlight_square_sprite.global_position = structure_position

func _update_build_state():
	# Highlight square state color
	highlight_square_sprite.self_modulate = color_build_open if build_current_state == build_state.OPEN else color_build_blocked
	# Set transparency
	highlight_square_sprite.self_modulate.a = highlight_transparency

func add_structure():
	if build_current_state == build_state.OPEN:
		audio_player.stream = audio_ui_accept
		# Build structure
		var structure_node = structure_scene.instantiate()
		var structure_offset = Vector2(game_grid_cell_size_halved, game_grid_cell_size_halved)
		structure_node.global_position = structure_position + structure_offset
		get_tree().get_root().add_child(structure_node) # Add to the main scene
		# Set building type
		structure_node._set_building_type(selected_item_name)
	else:
		audio_player.stream = audio_ui_denied
	# UI Play sound	
	audio_player.play()

func _on_area_2d_body_entered(body):
	nodes_in_build_area_list.push_back(body)
	build_current_state = build_state.BLOCKED
	_update_build_state()

func _on_area_2d_body_exited(body):
	nodes_in_build_area_list.erase(body)
	if nodes_in_build_area_list.size() == 0:
		build_current_state = build_state.OPEN
	_update_build_state()

func _update_active_item(active_item_name):
	selected_item_name = active_item_name
	print(selected_item_name)
