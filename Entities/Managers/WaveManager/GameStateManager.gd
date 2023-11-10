extends Node2D

@export var current_wave_manager : WaveManager = null

#@export var pauseable_node : Node2D = null

enum GameState { PAUSED, PREP, WAVE, GAMEOVER }

var current_state = null
var previous_state = null

func _ready():
	transition_to_state(GameState.PREP)
	#WaveManager is a node that is a child of this node
	current_wave_manager = get_node("WaveManager") as WaveManager

func transition_to_state(state: GameState):
	previous_state = current_state
	current_state = state
	match state:
		GameState.PAUSED:
			pause_game()
		GameState.PREP:
			prep_state()
		GameState.WAVE:
			start_wave()
		GameState.GAMEOVER:
			game_over_state()

func pause_game():
	get_tree().paused = true
	pass

func unpause_game():
	get_tree().paused = false
	transition_to_state(previous_state)
	pass

func prep_state():
	# Code for initializing prep state goes here
	pass

func start_wave():
	# Code for starting a wave goes here
	current_wave_manager.spawn_next_wave() 
	pass

func game_over_state():
	# Code for game over state goes here
	pass


func _process(delta):
	match current_state:
		GameState.PAUSED:
			# un pause
			if Input.is_key_pressed(KEY_P):
				unpause_game()
		GameState.PREP:
			if Input.is_action_just_pressed("ui_text_indent"):
				transition_to_state(GameState.WAVE)
			elif Input.is_key_pressed(KEY_P):
				transition_to_state(GameState.PAUSED)
		GameState.WAVE:
			#Here you would have your logic to check for wave completion or player death to transition to PREP or GAMEOVER respectively
			if current_wave_manager.check_wave_complete(): # Placeholder for your wave completion condition
				transition_to_state(GameState.PREP)
			#elif current_wave_manager.is_player_dead(): # Placeholder for your game over condition
			#    transition_to_state(GameState.GAMEOVER)
			elif Input.is_key_pressed(KEY_P):
				transition_to_state(GameState.PAUSED)
		GameState.GAMEOVER:
			pass
		# vibes
