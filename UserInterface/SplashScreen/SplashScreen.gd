extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://UserInterface/Credits/Credits.tscn")

func _on_close_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ActionButton"):
		get_tree().change_scene_to_file("res://Levels/Level1.tscn")
	if event.is_action_pressed("PauseButton"):
		get_tree().quit()
