extends Control

func _input(event):
	if event.is_action_pressed("PauseButton"):
		call_deferred("queue_free")

func _on_close_button_pressed():
	Main._pause_game_toggle()
	# Close the box
	call_deferred("queue_free")
