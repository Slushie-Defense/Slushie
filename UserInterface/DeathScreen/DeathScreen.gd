extends Node2D

var camera_width = 1280
var camera_height = 720
var camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)

@onready var player_node : Sprite2D = $Sprite2D
var player_rotation_speed = 10

func _ready():
	# Position
	camera_width = get_viewport_rect().size.x
	camera_height = get_viewport_rect().size.y
	camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)
	# Position sprite
	player_node.position = camera_center

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	player_node.rotation_degrees -= player_rotation_speed * delta
	player_node.position.x = camera_center.x + sin(player_node.rotation) * 16
	player_node.position.y = camera_center.y + sin(player_node.rotation * 2) * 32
	var player_scale = 1 + (sin(player_node.rotation * 2) * 0.25)
	player_node.scale = Vector2(player_scale, player_scale)

func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UserInterface/SplashScreen/SplashScreen.tscn")

