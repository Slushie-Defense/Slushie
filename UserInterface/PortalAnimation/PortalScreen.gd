extends Node2D

@onready var timer : Timer = $Timer

@onready var background_panel : Panel = $BackgroundPanel
var background_panel_style : StyleBoxFlat = StyleBoxFlat.new()

var camera_width = 1280
var camera_height = 720
var camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)

var portal_sprite = load("res://Sprites/DeathScreen/PortalCircleWhite.png")
var portal_sprite_size = Vector2(512, 512)
var portal_list : Array = []

# Colors
var background_color : Color = Color("#ABDCEB")
var portal_color : Color = Color("#2AA5CA")

func _ready():
	# Position
	camera_width = get_viewport_rect().size.x
	camera_height = get_viewport_rect().size.y
	camera_center = Vector2(camera_width * 0.5, camera_height * 0.5)
	# Add fill
	background_panel_style.bg_color = background_color
	background_panel.add_theme_stylebox_override("panel", background_panel_style)
	background_panel.size = Vector2(camera_width, camera_height)
	#player_node.scale = Vector2(12,12)
	# Create circle
	timer.start()
	# Create portals
	var psuedo_delta : float = 1 / 60
	var psuedo_time : int = 60 * 1.5
	var number_of_portals : int = 5
	for i in number_of_portals:
		_create_portal_sprite()
		# Pass time
		for x in psuedo_time:
			_update_portals(psuedo_delta)

func _update_color():
	# Change background
	background_panel_style.bg_color = background_color
	# Change portals
	for i in portal_list.size():
		portal_list[i].modulate = portal_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Portals
	_update_portals(delta, true)
	
func _update_portals(delta, pop : bool = false):
	# grow and spin
	var pop_index = -1
	if portal_list.size() > 0:
		for i in portal_list.size():
			var portal_spin_speed = 15
			if not portal_list[i] == null:
				portal_list[i].scale = portal_list[i].scale * 1.01
				portal_list[i].rotation_degrees += portal_spin_speed * delta
				var oscillation : float = portal_list[i].rotation * 2
				var portal_scale : float = portal_list[i].scale.x
				portal_list[i].position.x = camera_center.x + (sin(oscillation) * 16)
				portal_list[i].position.y = camera_center.y + (cos(oscillation) * 16)
				
				if portal_list[i].scale.x > 9.0:
					portal_list[i].queue_free()
					pop_index = i
				
	if not pop_index == -1:
		portal_list.pop_at(pop_index)

func _create_portal_sprite():
	var portal_circle : Sprite2D = Sprite2D.new()
	portal_circle.texture = portal_sprite
	portal_circle.position = Vector2(-5000, -5000)
	portal_circle.scale = Vector2(0.03, 0.03)
	portal_circle.modulate = portal_color
	add_child(portal_circle)
	portal_list.push_back(portal_circle)
	
func _on_timer_timeout():
	_create_portal_sprite()
	timer.wait_time = 1.5
	timer.start()
