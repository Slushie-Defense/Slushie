extends CharacterBody2D

signal signal_share_player_position(player_position)

# Player states
var player_state : NodeStates = NodeStates.new()

# Building Manager
@onready var building_manager : Node2D = $BuildingManager

# Grid visible
@export var show_build_grid : bool = true

# Health
@onready var health : ProgressBar = $Healthbar

# Physics
const MAX_SPEED : float = 500
var ACCELERATION : float = 2000
var motion : Vector2 = Vector2.ZERO # Equaliant to Vector2(0,0)
var isBuilding = false

# Animation Player
@onready var ap = $AnimationPlayer

# Initialize
func _ready():
	# Set shader
	#var shader_material = material
	#var flash_color = shader_material.get_shader_parameter("flash_color")
	#var flash_modifier = shader_material.get_shader_parameter("flash_modifier")
	#shader_material.set_shader_parameter("flash_modifier", 1.0)

	# Set player health
	health.set_max_health(1000)
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	health.always_hidden = true
	# This signal tells a global script/object called Main that the player node exists
	Main.emit_signal("signal_add_player", self)
	# Show build grid
	building_manager.visible = show_build_grid
	# Player dies if gas station dies
	Main.signal_gas_station_destroyed.connect(_event_health_is_zero)
	# Player spawn
	player_state.current = player_state.list.SPAWN

# Called every frame
func _physics_process(delta):
	if (player_state.current == player_state.list.DIED):
		return
	
	if (player_state.current != player_state.list.BUILD):
		var axis = get_input_axis()
		# If the player is not providing input
		if axis == Vector2.ZERO:
			apply_friction(ACCELERATION * delta)
			player_state.current = player_state.list.IDLE
		else: # Otherwise move
			$CharacterSprite.flip_h = true if (axis.x < 0) else false
			apply_movement(axis * ACCELERATION * delta)
			player_state.current = player_state.list.MOVING
		# Apply the motion
		velocity = motion
		# Move to the position unless it hits a collision then it will stop at the collision point
		move_and_slide()
	# This signal tells any object listening where the player is currently located
	emit_signal("signal_share_player_position", global_position)
	# Add building
	building_manager_create_structure()

func _process(delta):
	match player_state.current:
		player_state.list.IDLE:
			ap.play("Idle")
		player_state.list.MOVING:
			ap.play("Run")
		player_state.list.DIED:
			ap.play("Death")
		player_state.list.BUILD:
			ap.play("Build")

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("RightButton")) - int(Input.is_action_pressed("LeftButton"))
	axis.y = int(Input.is_action_pressed("DownButton")) - int(Input.is_action_pressed("UpButton"))
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
		
func apply_movement(acceleration):
	motion += acceleration
	if motion.length() > MAX_SPEED:
		motion = motion.normalized() * MAX_SPEED

func attack(_attack : Attack):
	health.add_or_subtract_health_by_value(-_attack.damage) # Subtract damage

func building_manager_create_structure():
	if Input.is_action_just_pressed("ActionButton"):
		building_manager.add_structure()
	
	# Building receives input from the structure, instead of player sending a build 
	# command to the structure, so using this hack to fake the build state on the player layer
	if Input.is_action_pressed("ActionButton"):
		player_state.current = player_state.list.BUILD
		motion = Vector2.ZERO
		isBuilding = true
	elif (isBuilding == true):
		isBuilding = false
		player_state.current = player_state.list.MOVING

func _event_health_is_zero():
	if (player_state.current == player_state.list.DIED):
		return
		
	player_state.current = player_state.list.DIED
	Main.emit_signal("signal_player_died")
	print("Player died!")

func _is_player():
	pass

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Death"):
		call_deferred("queue_free")
