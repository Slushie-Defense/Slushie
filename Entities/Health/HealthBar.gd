extends ProgressBar

# Signals
signal signal_custom_health_is_zero
signal signal_custom_health_changed(current_health, max_health)

# Variables
var max_health : float = 100.0
var current_health : float = 100.0

# Color Gradient
var health_color_gradient = load("res://Entities/Health/HealthColorGradient.tres")

func _ready():
	modulate = health_color_gradient.sample(1.0)
	visible = false

func set_max_health(new_value):
	max_health = new_value
	current_health = max_health
	update_progress_bar()

func add_or_subtract_health_by_value(new_value):
	current_health = clamp(current_health + new_value, 0.0, max_health) # Add
	update_progress_bar()

func update_progress_bar():
	# Update the value
	var weight = (current_health / max_health)
	value = int(weight * 100.0) # Update progress bar
	# Only show health bar if damaged
	if value < 100:
		visible = true
	# Send the health
	emit_signal("signal_custom_health_changed", value, max_value)
	# Let the parent know it died
	if value <= 0:
		emit_signal("signal_custom_health_is_zero")
	# Change the color
	modulate = health_color_gradient.sample(weight)
