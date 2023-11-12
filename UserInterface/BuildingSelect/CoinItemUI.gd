extends Panel

@onready var item_image : TextureRect = $VBoxContainer/ReferenceRect/ItemUI
@onready var label : Label = $VBoxContainer/Panel/Label
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	Main.signal_purchase_failed.connect(_purchase_failed)

func set_image_texture(image_texture):
	item_image.set_texture(image_texture)

func set_label_value(label_string):
	label.text = str(label_string)

func _purchase_failed():
	animation_player.current_animation = "PurchaseFailed"
	animation_player.play()
