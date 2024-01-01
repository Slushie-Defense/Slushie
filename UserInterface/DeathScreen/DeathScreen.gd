extends Node2D

var camera_width = 1280
var camera_height = 720
var camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)

@onready var portal_screen : Node2D = $PortalScreen

func _ready():
	portal_screen.background_color = Color("#000000")
	portal_screen.portal_color = Color("#340943")
	portal_screen._update_color()
	# Position
	camera_width = get_viewport_rect().size.x
	camera_height = get_viewport_rect().size.y
	camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UserInterface/SplashScreen/SplashScreen.tscn")

