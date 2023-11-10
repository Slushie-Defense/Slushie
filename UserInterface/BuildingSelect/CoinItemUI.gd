extends Panel

@onready var item_image : TextureRect = $VBoxContainer/ReferenceRect/ItemUI
@onready var label : Label = $VBoxContainer/Panel/Label

func set_image_texture(image_texture):
	item_image.set_texture(image_texture)

func set_label_value(label_string):
	label.text = str(label_string)
