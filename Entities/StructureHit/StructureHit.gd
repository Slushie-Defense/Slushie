extends AudioStreamPlayer

@export var structure : StaticBody2D
@onready var timer : Timer = $Timer

func _been_hit():
	timer.start(0.5)
	if not is_playing():
		play(0.0)

func _on_timer_timeout():
	stop()
