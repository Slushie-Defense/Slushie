extends Control

var next_scene = preload("res://Levels/Level1.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_packed(next_scene)

func _on_credits_pressed():
	print("Credits will go here")

func _on_close_pressed():
	get_tree().quit()
