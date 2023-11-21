extends CenterContainer

@onready var texture_rect : TextureRect = $HBoxContainer/TextureRect
@onready var progress_bar : ProgressBar = $HBoxContainer/CenterContainer/ProgressBar

# Color Gradient
var health_color_gradient = load("res://Entities/Health/HealthColorGradient.tres")

func _ready():
	progress_bar.self_modulate = health_color_gradient.sample(1.0)

func _update_progress_bar(current_value, max_health):
	progress_bar.value = current_value
	# Change the color
	progress_bar.self_modulate = health_color_gradient.sample(current_value / 100.0)

func _update_texture(loaded_texture):
	texture_rect.texture = loaded_texture

func _update_progress_bar_color(background_color : String = "#000000", fill_color : String = "#FFFFFF"):
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(background_color)
	progress_bar.add_theme_stylebox_override("background", bg_style)

	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color(fill_color)
	progress_bar.add_theme_stylebox_override("fill", fill_style)
