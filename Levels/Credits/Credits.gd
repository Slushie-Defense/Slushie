extends Control

func _on_go_back_pressed():
	get_tree().change_scene_to_file("res://Levels/SplashScreen/SplashScreen.tscn")

func _input(event):
	if event.is_action_pressed("ActionButton") or event.is_action_pressed("PauseButton"):
		get_tree().change_scene_to_file("res://Levels/SplashScreen/SplashScreen.tscn")
