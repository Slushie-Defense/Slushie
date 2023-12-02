extends Control

@onready var portal_screen : Node2D = $PortalScreen

func _ready():
	portal_screen.background_color = Color("#000000")
	portal_screen.portal_color = Color("#340943")
	portal_screen._update_color()

func _on_go_back_pressed():
	get_tree().change_scene_to_file("res://UserInterface/SplashScreen/SplashScreen.tscn")

func _input(event):
	if event.is_action_pressed("ActionButton") or event.is_action_pressed("PauseButton"):
		get_tree().change_scene_to_file("res://UserInterface/SplashScreen/SplashScreen.tscn")
