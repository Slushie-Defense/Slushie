extends PanelContainer

@onready var label : Label = $MarginContainer/HealthLabel

func _set_text(my_label):
	label.text = my_label
