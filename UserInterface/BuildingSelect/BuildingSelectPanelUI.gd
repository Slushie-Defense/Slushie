extends Control

# Images
var image_fence = load("res://Sprites/UserInterface/Items/Fence.png")
var image_landmine = load("res://Sprites/UserInterface/Items/Landmine.png")
var image_instant_structure = load("res://Sprites/UserInterface/Items/Instant.png")
var image_aoe_structure = load("res://Sprites/UserInterface/Items/AOE.png")
var image_bullet_structure = load("res://Sprites/UserInterface/Items/Bullet.png")
var image_coins = load("res://Sprites/UserInterface/Items/Coins.png")

# HBox Container
@onready var hboxcontainer : HBoxContainer = $PanelContainer/MarginContainer/HBoxContainer

# Items
var item_list : Array = [
	image_coins, 
	image_fence,
	image_landmine,
	image_bullet_structure, 
	image_aoe_structure, 
	image_instant_structure,
]
var item_scene = load("res://UserInterface/BuildingSelect/SelectableItemUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("create_user_interface")

func create_user_interface():
	for item_texture in item_list:
		var item = item_scene.instantiate()
		hboxcontainer.add_child(item)
		item.set_image_texture(item_texture)
