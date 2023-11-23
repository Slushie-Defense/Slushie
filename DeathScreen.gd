extends Node2D

@onready var background_panel : Panel = $BackgroundPanel
var background_panel_style : StyleBoxFlat = StyleBoxFlat.new()

var camera_width = 1280
var camera_height = 720
var camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)

var portal_sprite = load("res://Sprites/DeathScreen/PortalCircle.png")
var portal_sprite_size = Vector2(512, 512)

@onready var player_node : Sprite2D = $Sprite2D
var player_rotation_speed = 10

func _ready():
	# Position
	camera_width = get_viewport_rect().size.x
	camera_height = get_viewport_rect().size.y
	camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)
	# Add fill
	background_panel_style.bg_color = Color("#ABDCEB")
	background_panel.add_theme_stylebox_override("panel", background_panel_style)
	background_panel.size = Vector2(camera_width, camera_height)
	# Position sprite
	player_node.position = camera_center

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	player_node.rotation_degrees -= player_rotation_speed * delta
	player_node.position.y = camera_center.y + sin(player_node.rotation * 2) * 32

func _create_portal_sprite():
	#var portal
	return
