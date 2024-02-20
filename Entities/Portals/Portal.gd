class_name Portal
extends Node2D

@onready var portal_sprite : Node2D = $Portal2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

#var open_state : bool = false
var open_state : String = "ClosePortal"

func _ready():
	portal_sprite.scale = Vector2.ZERO

func _set_portal_state_open(set_state):
	print(set_state)
	if open_state == set_state:
		return # Ignore if its the current state
	# Set the state
	open_state = set_state
	# Play animation
	animation_player.current_animation = set_state
	print(set_state)
	# Play the animation
	animation_player.play()

func _on_animation_player_animation_finished(_anim_name):
	match _anim_name:
		"OpenPortal":
			animation_player.current_animation = "LoopPortal"
			animation_player.play()
		"OpenMiniPortal":
			animation_player.current_animation = "MiniPortal"
			animation_player.play()
