extends CenterContainer

@onready var texture_rect : TextureRect = $HBoxContainer/TextureRect
@onready var progress_bar : ProgressBar = $HBoxContainer/CenterContainer/ProgressBar
@onready var ui_label : Label = $HBoxContainer/CenterContainer/Label

# Color Gradient
var health_color_gradient = load("res://Entities/Health/HealthColorGradient.tres")

# Fill healthbar
var background_fill_style = StyleBoxFlat.new()
var progress_fill_style = StyleBoxFlat.new()

func _ready():
	_update_progress_bar_color(health_color_gradient.sample(1.0))
	background_fill_style.bg_color = Color("#555555")
	progress_bar.add_theme_stylebox_override("background", background_fill_style)

func _update_progress_bar(current_value, max_health):
	progress_bar.value = current_value
	# Change the color
	var health_color = health_color_gradient.sample(current_value / 100.0)
	_update_progress_bar_color(health_color)

func _update_texture(loaded_texture):
	texture_rect.texture = loaded_texture

func _update_label(label_text):
	ui_label.text = label_text

func _update_health_color_gradient(color_gradient):
	health_color_gradient = color_gradient
	var health_color = health_color_gradient.sample(progress_bar.value / 100.0)
	_update_progress_bar_color(health_color)

func _update_progress_bar_color(fill_color):
	progress_fill_style.bg_color = Color(fill_color)
	progress_bar.add_theme_stylebox_override("fill", progress_fill_style)
