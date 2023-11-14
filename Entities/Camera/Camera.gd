extends Camera2D

@onready var user_interface : Node2D = $UserInterfaceParent
@onready var wave_event_user_interface : Control = $UserInterfaceParent/CanvasLayer/WaveEvent

var camera_width = 1280
var camera_height = 720

var follow_position = Vector2.ZERO

func _ready():
	camera_width = get_viewport_rect().size.x
	camera_height = get_viewport_rect().size.y	
	# Wave event
	wave_event_user_interface.center_container.size.y = camera_height * 0.5
	wave_event_user_interface.center_container.size.x = camera_width
	# Main recieves a signal that the player node exists
	# When the signal arrives it connects the player node custom "update position" signal to the camera
	# Now the camera knows where the player is
	Main.signal_add_player.connect(_on_player_add) 

func _on_player_add(pass_player):
	pass_player.signal_share_player_position.connect(_update_position)

func _update_position(set_position):
	# Camera limits
	var offset_y_max : int = 192
	var level_y_center : int = 576
	var offset_x_min : int = 1024
	var limit_position = set_position
	limit_position.y = clamp(set_position.y, level_y_center - offset_y_max, level_y_center + offset_y_max)
	limit_position.x = clamp(set_position.x, 1024, INF)
	offset = limit_position
	
	# Position User Interface
	user_interface.position = Vector2(offset.x - (camera_width * 0.5), offset.y - (camera_height * 0.5))
