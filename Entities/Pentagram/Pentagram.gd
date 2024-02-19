extends Sprite2D

@onready var timer : Timer = $Timer
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var hide : bool = false

var flame_scene = load("res://Entities/Pentagram/Flame.tscn")
var total_number_of_flames : int = 16
var number_flames_created : int = 0
var pentagram_radius : int = 312

var flame_list : Array = []
var adding_flames : bool = false

var all_flames_activated : bool = false

func _ready():
	if hide:
		queue_free()
	timer.wait_time = 0.25
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
			flame_list[i].scale.y = 1.0
			flame_list.pop_back()
			timer.start()
	
	all_flames_activated = number_flames_created == total_number_of_flames
	if all_flames_activated:
		for flame in flame_list:
			flame.scale.y = 2.0

func _on_area_2d_body_entered(body):
	adding_flames = true
	timer.wait_time = 0.25
	timer.start()
	_play_strobe_effect()

func _on_area_2d_body_exited(body):
	adding_flames = false
	timer.wait_time = 0.1
	timer.start()
	
func _kill_all_flames():
	for child in flame_list:
		child.kill_flame()
	flame_list = []

func _play_strobe_effect():
	animation_player.current_animation = "FlashActivate"
	animation_player.play()

func _on_animation_player_animation_finished(anim_name):
	if adding_flames:
		_play_strobe_effect()
