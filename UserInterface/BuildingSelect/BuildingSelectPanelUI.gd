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

# Items
var coins : Panel
var fence : Panel
var landmine : Panel
var instant_hit : Panel
var aoe_hit : Panel
var bullet_hit : Panel
var stats : PanelContainer

var item_scene = load("res://UserInterface/BuildingSelect/SelectableItemUI.tscn")
var coin_item_scene = load("res://UserInterface/BuildingSelect/CoinItemUI.tscn")
var stats_scene = load("res://UserInterface/BuildingSelect/StatsItemUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("create_user_interface")

func create_user_interface():
	coins = add_item(coin_item_scene, image_coins)
	fence = add_item(item_scene, image_fence)
	landmine = add_item(item_scene, image_landmine)
	instant_hit = add_item(item_scene, image_instant_structure)
	aoe_hit = add_item(item_scene, image_aoe_structure)
	bullet_hit = add_item(item_scene, image_bullet_structure)
	stats = add_stats()
	# Connect coins
	call_deferred("connect_coins")
	
func add_item(set_scene, item_texture):
	var item = set_scene.instantiate()
	hboxcontainer.add_child(item)
	item.set_image_texture(item_texture)
	var random = RandomNumberGenerator.new()
	item.set_label_value(random.randi_range(0, 19) * 100)
	return item

func add_stats():
	var item = stats_scene.instantiate()
	hboxcontainer.add_child(item)
	return item

func connect_coins():
	Main.signal_update_coin_count.connect(_update_coin_count)
	_update_coin_count(0)

func _update_coin_count(count):
	coins.set_label_value(Main.coins)
