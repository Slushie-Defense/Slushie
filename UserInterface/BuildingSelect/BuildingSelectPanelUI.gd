extends Control

# Images
var image_fence = load("res://UserInterface/BuildingSelect/Items/Fence.png")
var image_landmine = load("res://UserInterface/BuildingSelect/Items/Landmine.png")
var image_instant_structure = load("res://UserInterface/BuildingSelect/Items/Instant.png")
var image_aoe_structure = load("res://UserInterface/BuildingSelect/Items/AOE.png")
var image_bullet_structure = load("res://UserInterface/BuildingSelect/Items/Bullet.png")
var image_coins = load("res://UserInterface/BuildingSelect/Items/Coins.png")

# HBox Container
@onready var hboxcontainer : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer

# Resources
var coins : Panel

# Descriptions
var stats : PanelContainer

# Items
var fence : TextureRect
var landmine : TextureRect
var instant_structure : TextureRect
var siege_structure : TextureRect
var projectile_structure : TextureRect

# Item list
var item_dictionary : Dictionary = {}
var item_names : Array = []
var active_item : int = 0
var active_item_name : String = ""

# Scenes
var item_scene = load("res://UserInterface/BuildingSelect/SelectableItemUI.tscn")
var coin_item_scene = load("res://UserInterface/BuildingSelect/CoinItemUI.tscn")
var stats_scene = load("res://UserInterface/BuildingSelect/StatsItemUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_create_user_interface")
	call_deferred("_update_seleted_item")

func _create_user_interface():
	# Create coin resource
	coins = _add_coin(coin_item_scene, image_coins)
	call_deferred("_connect_coins") # Connect coins
	
	# Create items
	fence = _add_item(item_scene, image_fence, UnitData.FENCE)
	landmine = _add_item(item_scene, image_landmine, UnitData.LANDMINE)
	projectile_structure = _add_item(item_scene, image_bullet_structure, UnitData.PROJECTILE)
	instant_structure = _add_item(item_scene, image_instant_structure, UnitData.INSTANT)
	siege_structure = _add_item(item_scene, image_aoe_structure, UnitData.SIEGE)
	
	# Add stats
	stats = _add_stats()
	
	# Set first item as active
	_update_active_states()

func _add_coin(set_scene, item_texture):
	var item = set_scene.instantiate()
	hboxcontainer.add_child(item)
	item.set_image_texture(item_texture)
	return item

func _add_item(set_scene, item_texture, unit_data):
	var item = set_scene.instantiate()
	hboxcontainer.add_child(item)
	item.set_image_texture(item_texture)
	# Set the value
	item.set_label_value(unit_data.cost)
	# Add to the list of items
	item_dictionary[unit_data.unit_name] = item
	item_names.push_back(unit_data.unit_name)
	# Store it
	return item

func _add_stats():
	var item = stats_scene.instantiate()
	hboxcontainer.add_child(item)
	return item

func _connect_coins():
	Main.signal_update_coin_count.connect(_update_coin_count)
	_update_coin_count(0)

func _update_coin_count(count):
	coins.set_label_value(Main.coins)

func _input(event):
	var update : bool = false
	if event.is_action_pressed("ui_text_caret_page_up"):
		# Change to next active item
		active_item = (active_item - 1) % (item_names.size())
		update = true
	if event.is_action_pressed("ui_text_caret_page_down"):
		# Change to next active item
		active_item = (active_item + 1) % (item_names.size())
		update = true
	if update:
		# Update everyone on the change
		_update_seleted_item()
		# Update active state
		_update_active_states()
		
func _update_active_states():
	# Deactivate all items
	for child_name in item_dictionary:
		item_dictionary[child_name].set_active_state(false)
	# Activate current
	var current_item_name = item_names[active_item]
	item_dictionary[current_item_name].set_active_state(true)

func _update_seleted_item():
	# Get active item name
	active_item_name = item_names[active_item]
	
	# Convert to ENUM
	var active_item_type = UnitData.FENCE
	# Setup structure
	match active_item_name:
		"FENCE":
			active_item_type = UnitData.FENCE
		"SIEGE":
			active_item_type = UnitData.SIEGE
		"INSTANT":
			active_item_type = UnitData.INSTANT
		"PROJECTILE":
			active_item_type = UnitData.PROJECTILE
		"LANDMINE":
			active_item_type = UnitData.LANDMINE
	
	Main.emit_signal("signal_selected_item_update", active_item_type)
