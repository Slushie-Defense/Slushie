extends StaticBody2D

@onready var health : ProgressBar = $Healthbar
@onready var collision_shape_2d : CollisionPolygon2D = $CollisionPolygon2D
@onready var area_collision_shape_2d : CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	health.set_max_health(500)
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	health.always_hidden = true
	# Stores the gas station
	Main.emit_signal("signal_add_gas_station", self)
	# Hurt effect
	health.signal_flash_effect.connect(_apply_hurt_effect)

func _apply_hurt_effect(flash_value):
	material.set_shader_parameter("flash_modifier", flash_value)

func attack(_attack : Attack):
	health.add_or_subtract_health_by_value(-_attack.damage) # Subtract damage

func _event_health_is_zero():
	print("Gas station died!")
	Main.emit_signal("signal_gas_station_destroyed")
	call_deferred("queue_free")
