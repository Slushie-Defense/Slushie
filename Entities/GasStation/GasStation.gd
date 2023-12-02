extends StaticBody2D

@onready var health : ProgressBar = $Healthbar
@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape_2d : CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	health.set_max_health(1000)
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	health.always_hidden = true
	area_collision_shape_2d.shape.size = collision_shape_2d.shape.size
	# Stores the gas station
	Main.emit_signal("signal_add_gas_station", self)

func attack(_attack : Attack):
	health.add_or_subtract_health_by_value(-_attack.damage) # Subtract damage

func _event_health_is_zero():
	print("Gas station died!")
	Main.emit_signal("signal_wave_event", "Gas Station Destroyed!")
	Main.emit_signal("signal_gas_station_destroyed")
	call_deferred("queue_free")
