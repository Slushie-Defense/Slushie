extends TextureRect

@onready var item_image : TextureRect = $HBoxContainer/ItemUI
@onready var label : Label = $HBoxContainer/Label

var default_texture = load("res://Sprites/ItemsUI/Default.png")
var active_texture = load("res://Sprites/ItemsUI/Active.png")

func set_image_texture(image_texture):
	item_image.set_texture(image_texture)

func set_label_value(label_string):
	label.text = str(label_string)

func set_active_state(active_state):
	if active_state:
		texture = active_texture
	else:
		texture = default_texture
