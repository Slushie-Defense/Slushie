extends Sprite2D

@onready var timer : Timer = $Timer

var flame_scene = load("res://Entities/Pentagram/Flame.tscn")
var total_number_of_flames : int = 16
var number_flames_created : int = 0
var pentagram_radius : int = 312

var flame_list : Array = []
var adding_flames : bool = false

func _ready():
	timer.start()

func _on_timer_timeout():
	number_flames_created = flame_list.size()
	if number_flames_created < total_number_of_flames:
		if adding_flames:
			var flame = flame_scene.instantiate()
			flame_list.push_back(flame)
			var angle_increment = 360.0 / total_number_of_flames
			flame.position = Vector2(pentagram_radius, 0).rotated(deg_to_rad(angle_increment * number_flames_created - 90.0))
			add_child(flame)
			timer.start()
	
	if number_flames_created > 0:
		if not adding_flames:
				var i : int = number_flames_created - 1
				flame_list[i].kill_flame()
				flame_list.pop_back()
				timer.start()

func _on_area_2d_body_entered(body):
	adding_flames = true
	timer.start()

func _on_area_2d_body_exited(body):
	adding_flames = false
	timer.start()
	
func _kill_all_flames():
	for child in flame_list:
		child.kill_flame()
	flame_list = []
