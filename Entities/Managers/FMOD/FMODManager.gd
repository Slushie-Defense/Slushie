extends Node2D

@export var event: EventAsset
var instance: EventInstance

var wave_active : bool = false
var wave_intensity : int = 0

@onready var death_music : AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_FMOD()
	# Connect to wave triggers
	Main.signal_wave_event.connect(_wave_event)
	# Destroy if you leave the scene
	Main.signal_player_died.connect(_stop_FMOD)
	# Stop FMOD
	Main.signal_stop_fmod.connect(_stop_FMOD_no_death_music)

func _create_FMOD():
	instance = FMODRuntime.create_instance(event)
	# Start the song
	instance.start()
	# Release FMOD from memory to prevent memory leaks
	instance.release()

func _wave_event(wave_number):
	wave_active = not wave_number == -1
	var increase_every_x_waves : float = floor(wave_number / 2.0)
	wave_intensity = int(clamp(increase_every_x_waves, 0, 8))
	# React to wave update
	if wave_active:
		# Start the wave music immediately
		_update_intensity()
	else:
		# Delay the end of the wave music
		var delay_wave_deactivated : float = 4.0
		get_tree().create_timer(delay_wave_deactivated).timeout.connect(_update_intensity)

func _update_intensity():
	# Update parameters
	instance.set_parameter_by_name("wave onoff", int(wave_active), false)
	instance.set_parameter_by_name("Wave Intensity", wave_intensity, false)

func _stop_FMOD():
	# Stop the music
	instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	# Play Death
	death_music.play()

func _stop_FMOD_no_death_music():
	# Stop the music
	instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
