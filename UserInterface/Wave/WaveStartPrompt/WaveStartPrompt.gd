extends Button

@onready var timer : Timer = $Timer
var wave_number_count : int = 1

# alled when the node enters the scene tree for the first time.
func _ready():
	Main.signal_wave_event.connect(_wave_event_triggered)

func _wave_event_triggered(wave_number):
	if wave_number > 0:
		wave_number_count = wave_number
		visible = false
	else:
		timer.start()

func _on_pressed():
	Main.emit_signal("signal_trigger_wave_event")

func _on_timer_timeout():
	text = "Start Wave [" + str(wave_number_count + 1) + "]"
	visible = true
