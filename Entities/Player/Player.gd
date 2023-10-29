extends CharacterBody2D

signal signal_share_player_position(player_position)

# Building Manager
@onready var building_manager : Sprite2D = $BuildingManager

# Grid visible
@export var show_build_grid : bool = true

# Health
@onready var health : ProgressBar = $Healthbar

# Physics
const MAX_SPEED : float = 500
var ACCELERATION : float = 2000
var motion : Vector2 = Vector2.ZERO # Equaliant to Vector2(0,0)

# Initialize
func _ready():
	# Set player health
	health.set_max_health(1000)
	health.signal_custom_health_is_zero.connect(_event_health_is_zero)
	# This signal tells a global script/object called Main that the player node exists
	Main.emit_signal("signal_add_player", self)
	# Show build grid
	building_manager.visible = show_build_grid

# Called every frame
func _physics_process(delta):
	var axis = get_input_axis()
	# If the player is not providing input
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else: # Otherwise move
		apply_movement(axis * ACCELERATION * delta)
	# Apply the motion
	velocity = motion
	# Move to the position unless it hits a collision then it will stop at the collision point
	move_and_slide()
	# This signal tells any object listening where the player is currently located
	emit_signal("signal_share_player_position", global_position)
	# Add building
	building_manager_create_structure()

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
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

func attack(attack : Attack):
	health.add_or_subtract_health_by_value(-attack.damage) # Subtract damage

func building_manager_create_structure():
	if Input.is_action_just_released("ui_accept"):
		building_manager.add_structure()

func _event_health_is_zero():
	print("Player died!")
