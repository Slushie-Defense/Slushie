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
	offset = set_position
