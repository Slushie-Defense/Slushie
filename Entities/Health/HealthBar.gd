extends ProgressBar

# Signals
signal signal_custom_health_is_zero
signal signal_custom_health_changed(current_health, max_health)

# Flash effect
signal signal_flash_effect(current_value)
@onready var flash_animation_player : AnimationPlayer = $AnimationPlayer
@export_range(0.0, 1.0) var flash_value : float = 0.0

# Always hidden
@export var always_hidden : bool = false

# Variables
var max_health : float = 100.0
var current_health : float = 100.0

# Color Gradient
var health_color_gradient = load("res://Entities/Health/HealthColorGradient.tres")

func _ready():
	modulate = health_color_gradient.sample(1.0)
	visible = false
	flash_animation_player.current_animation = "FlashDamage"
	set_physics_process(false) # Only relevant when sending flash effect

func is_dead():
	if (current_health <= 0):
		return true
	else:
		return false

func set_max_health(new_value):
	max_health = new_value
	current_health = max_health
	update_progress_bar()

func add_or_subtract_health_by_value(new_value):
	# Flash damage effect
	if (new_value < 0):
		flash_animation_player.play()
	# Update health
	current_health = clamp(current_health + new_value, 0.0, max_health) # Add
	update_progress_bar()

func update_progress_bar():
	# Update the value
	var weight = (current_health / max_health)
	value = int(weight * 100.0) # Update progress bar
	# Only show health bar if damaged
	if value < 100 and always_hidden == false:
		visible = true
	# Send the health
	emit_signal("signal_custom_health_changed", value, max_value)
	# Let the parent know it died
	if value <= 0:
		emit_signal("signal_custom_health_is_zero")
	# Change the color
	modulate = health_color_gradient.sample(weight)

func _on_animation_player_animation_started(anim_name):
	set_physics_process(true)

func _on_animation_player_animation_finished(anim_name):
	# Turn off flash effect
	set_physics_process(false)

func _physics_process(delta):
	emit_signal("signal_flash_effect", flash_value) # Send out effect
