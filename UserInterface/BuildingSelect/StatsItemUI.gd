extends PanelContainer

@onready var title : Label = $MarginContainer/VBoxContainer/Title
@onready var stats : Label = $MarginContainer/VBoxContainer/Stats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_title(new_title : String = ""):
	title.text = new_title
	
func _set_stats(new_stats : String = ""):
	stats.text = new_stats
