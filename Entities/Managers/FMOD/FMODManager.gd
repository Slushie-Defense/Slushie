extends Node2D

var wave_active : bool = false

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var wave_clam_before_storm = load("res://Audio/Music/slushie calm between wave.wav")
var wave_high_intensity = load("res://Audio/Music/slushie wave hi intensity.ogg")
var wave_start_wave = load("res://Audio/Music/slushie wave stinger hi intensity.wav")
var wave_end_wave = load("res://Audio/Music/slusie fanfare hi intensity.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	_start_calm_music()
	# Connect to wave triggers
	Main.signal_wave_event.connect(_wave_event)
	# Destroy if you leave the scene
	Main.signal_player_died.connect(_stop_ingame_soundtrack)
	# Stop FMOD
	Main.signal_stop_ingame_soundtrack.connect(_stop_ingame_soundtrack_no_audio_player)

func _start_calm_music():
	audio_player.stop()
	audio_player.stream = wave_clam_before_storm
	audio_player.play()

func _wave_event(wave_number):
	# If wave is active TRUE OR FALSE
	wave_active = not wave_number == -1
	# React to wave update
	if wave_active:
		# Start the wave music immediately
		audio_player.stream = wave_start_wave
		audio_player.play()
	else:
		# Delay the end of the wave music
		var delay_wave_deactivated : float = 4.0
		get_tree().create_timer(delay_wave_deactivated).timeout.connect(_wave_end)

func _wave_end():
	audio_player.stop()
	audio_player.stream = wave_end_wave
	audio_player.play()

func _stop_ingame_soundtrack():
	# Play Death
	audio_player.stop()
	audio_player.stream = wave_end_wave
	audio_player.play()

func _stop_ingame_soundtrack_no_audio_player():
	# Stop the music
	audio_player.stop()

func _on_audio_stream_player_finished():
	if audio_player.stream == wave_end_wave:
		_start_calm_music()
	elif audio_player.stream == wave_start_wave:
		audio_player.stop()
		audio_player.stream = wave_high_intensity
		audio_player.play()
