extends Control

func _ready():
	visible = false
	if Main.company_screen_shown == true:
		queue_free()
		return
	Main.company_screen_shown = true
	visible = true

func _on_animation_player_animation_finished(anim_name):
	call_deferred("queue_free")
