extends Control


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Levels/Credits/Credits.tscn")

func _on_close_pressed():
	get_tree().quit()
