extends Button

@onready var timer : Timer = $Timer
var wave_number_count : int = 1

# alled when the node enters the scene tree for the first time.
func _ready():
	Main.signal_game_completed.connect(_game_completed_event)
	text = "Summon The Horde"

func _game_completed_event():
	call_deferred("queue_free")

func _process(delta):
	visible = Main.summoning_ready and not Main.current_wave_active

func _on_pressed():
	if visible:
		Main.emit_signal("signal_trigger_wave_event")
