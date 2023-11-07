extends VBoxContainer

@onready var item_image : TextureRect = $SelectPanel/ReferenceRect/ItemUI

func set_image_texture(image_texture):
	item_image.set_texture(image_texture)
