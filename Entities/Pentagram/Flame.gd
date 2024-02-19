extends AnimatedSprite2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func kill_flame():
	animation_player.current_animation = "Died"
	animation_player.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Died":
		queue_free()
