extends Button

@onready var timer : Timer = $Timer
var wave_number_count : int = 1

# alled when the node enters the scene tree for the first time.
func _ready():
	Main.signal_wave_event.connect(_wave_event_triggered)
	Main.signal_game_completed.connect(_game_completed_event)

func _game_completed_event():
	call_deferred("queue_free")

func _wave_event_triggered(wave_number):
	# Wave start was triggered
	if wave_number > 0:
		wave_number_count = wave_number
		visible = false
	# Wave End was triggered
	if wave_number == -1:
		timer.start()

func _on_pressed():
	Main.emit_signal("signal_trigger_wave_event")

func _on_timer_timeout():
	text = "Start Wave [" + str(wave_number_count + 1) + "]"
	visible = true
