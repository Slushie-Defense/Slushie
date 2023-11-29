class_name Portal
extends Node2D

@onready var portal_sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var open_state : bool = false

func _ready():
	portal_sprite.scale = Vector2.ZERO

func _set_portal_state_open(set_state):
	# Set the state
	open_state = set_state
	# Play animation
	if open_state:
		animation_player.current_animation = "OpenPortal"
	else:
		animation_player.current_animation = "ClosePortal"
	# Play the animation
	animation_player.play()

func _on_animation_player_animation_finished(anim_name):
	if open_state:
		animation_player.current_animation = "LoopPortal"
		animation_player.play()
