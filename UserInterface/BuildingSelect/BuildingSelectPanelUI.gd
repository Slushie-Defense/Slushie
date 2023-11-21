extends Control

# Images
var image_fence = load("res://Sprites/ItemsUI/Items/Fence.png")
var image_landmine = load("res://Sprites/ItemsUI/Items/Landmine.png")
var image_instant_structure = load("res://Sprites/ItemsUI/Items/Instant.png")
var image_aoe_structure = load("res://Sprites/ItemsUI/Items/AOE.png")
var image_bullet_structure = load("res://Sprites/ItemsUI/Items/Bullet.png")
var image_coins = load("res://Sprites/ItemsUI/Items/Coins.png")

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

# Health bars
var healthbar_scene = load("res://UserInterface/SidebarHealth/SidebarHealth.tscn")
var player_healthbar
var gas_station_healthbar
var gas_station_healtbar_texture = load("res://Sprites/Healthbar/GasstationHealthbar32x32.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_create_user_interface")
	call_deferred("_update_seleted_item")

func _on_signal_connect_player_healthbar(current_value, max_health):
	player_healthbar._update_progress_bar(current_value, max_health)
	
func _on_signal_connect_gas_station_healthbar(current_value, max_health):
	gas_station_healthbar._update_progress_bar(current_value, max_health)

func _create_user_interface():
	# Player
	player_healthbar = _add_healthbar()
	Main.player_node.health.signal_custom_health_changed.connect(_on_signal_connect_player_healthbar)
	
	# Gas Station
	gas_station_healthbar = _add_healthbar()
	gas_station_healthbar._update_texture(gas_station_healtbar_texture)
	gas_station_healthbar._update_progress_bar_color("#000000", "#FFFFFF")
	Main.gas_station_node.health.signal_custom_health_changed.connect(_on_signal_connect_gas_station_healthbar)
	
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

func _add_healthbar():
	var healthbar = healthbar_scene.instantiate()
	hboxcontainer.add_child(healthbar)
	return healthbar

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
	if event.is_action_pressed("SelectItemReverseButton"):
		# Change to next active item
		active_item = (active_item - 1) % (item_names.size())
		update = true
	if event.is_action_pressed("SelectItemButton"):
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
	
	# Set name
	stats._set_title(active_item_type.unit_name)
	# Get damage
	var damage : String = str(active_item_type.attack_damage)
	# Set damage
	var health : String = str(active_item_type.health)
	# Set range
	var range : String = str(active_item_type.attack_range / GameGrid.cell_size)
	# Update 
	stats._set_stats("Damage: " + damage + "\nHealth: " + health + "\nRange: " + range)
	
	Main.emit_signal("signal_selected_item_update", active_item_type)
