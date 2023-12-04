extends Node2D

#@onready var fmod_music : StudioEventEmitter2D = $StudioEventEmitter2D
@export var event: EventAsset
var instance: EventInstance

var wave_active : bool = true
var wave_intensity : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = FMODRuntime.create_instance(event)
	#instance.set_parameter_by_name("Wave_Onoff", false, false)
	instance.start()
	#instance.release()
	#wave_intensity = 10.0
	#instance.set_parameter_by_name("wave_onoff", wave_active, false)
	#instance.set_parameter_by_name("wave_intensity", wave_intensity, false)


func _on_timer_timeout():
	print("Triggered")
	instance.set_parameter_by_name("wave onoff", 1.0, false)
	instance.set_parameter_by_name("Wave Intensity", 10.0, false)
