extends Control

# Images
var image_fence = load("res://UserInterface/BuildingSelect/Items/Fence.png")
var image_landmine = load("res://UserInterface/BuildingSelect/Items/Landmine.png")
var image_instant_structure = load("res://UserInterface/BuildingSelect/Items/Instant.png")
var image_aoe_structure = load("res://UserInterface/BuildingSelect/Items/AOE.png")
var image_bullet_structure = load("res://UserInterface/BuildingSelect/Items/Bullet.png")
var image_coins = load("res://UserInterface/BuildingSelect/Items/Coins.png")

# HBox Container
@onready var hboxcontainer : HBoxContainer = $PanelContainer/MarginContainer/HBoxContainer

# Items
var coins : VBoxContainer
var fence : VBoxContainer
var landmine : VBoxContainer
var instant_hit : VBoxContainer
var aoe_hit : VBoxContainer
var bullet_hit : VBoxContainer

var item_scene = load("res://UserInterface/BuildingSelect/SelectableItemUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("create_user_interface")

func create_user_interface():
	coins = add_item(image_coins)
	fence = add_item(image_fence)
	landmine = add_item(image_landmine)
	instant_hit = add_item(image_instant_structure)
	aoe_hit = add_item(image_aoe_structure)
	bullet_hit = add_item(image_bullet_structure)
	# Connect coins
	call_deferred("connect_coins")
	
func add_item(item_texture):
	var item = item_scene.instantiate()
	hboxcontainer.add_child(item)
	item.set_image_texture(item_texture)
	return item

func connect_coins():
	Main.signal_update_coin_count.connect(_update_coin_count)
	_update_coin_count(0)

func _update_coin_count(count):
	coins.set_label_value(Main.coins)
