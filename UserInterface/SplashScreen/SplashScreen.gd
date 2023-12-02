extends Control

@onready var mad_king_screen : Control = $MadKing
@onready var portal_screen : Node2D = $PortalScreen

func _ready():
	portal_screen.background_color = Color("#000000")
	portal_screen.portal_color = Color("#340943")
	portal_screen._update_color()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://UserInterface/Credits/Credits.tscn")

func _on_close_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ActionButton"):
		if mad_king_screen.visible:
			mad_king_screen.visible = false
			Main.company_screen_shown = true
		else:
			_on_start_pressed()
	if event.is_action_pressed("PauseButton"):
		get_tree().quit()
