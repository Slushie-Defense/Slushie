extends Camera2D

var follow_position = Vector2.ZERO

func _ready():
	# Main recieves a signal that the player node exists
	# When the signal arrives it connects the player node custom "update position" signal to the camera
	# Now the camera knows where the player is
	Main.signal_add_player.connect(_on_player_add) 

func _on_player_add(pass_player):
	pass_player.signal_share_player_position.connect(_update_position)

func _update_position(set_position):
	# Camera limits
	var offset_max : int = 128
	var level_y_center : int = 512
	var limit_position = set_position
	limit_position.y = clamp(set_position.y, level_y_center - offset_max, level_y_center + offset_max)
	offset = limit_position
