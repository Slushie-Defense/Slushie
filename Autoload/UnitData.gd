extends Node

# Structure types
enum structure_list { FENCE, INSTANT, PROJECTILE, SIEGE, LANDMINE }

# Structures
var FENCE : StructureData = StructureData.new() 
var LANDMINE : StructureData = StructureData.new()
var INSTANT : StructureData = StructureData.new()
var SIEGE : StructureData = StructureData.new()
var PROJECTILE : StructureData = StructureData.new()

# Enemies

func _ready():
	# Setup FENCE
	FENCE.attack_damage = 0.0
	FENCE.type = structure_list.FENCE
	FENCE.unit_name = "FENCE"
	FENCE.cost = 200
	# Setup LANDMINE
	LANDMINE.attack_damage = 100.0
	LANDMINE.delay_before_explode = 0.5
	LANDMINE.type = structure_list.LANDMINE
	LANDMINE.unit_name = "LANDMINE"
	LANDMINE.cost = 300
	LANDMINE.attack_radius = 80.0
	LANDMINE.attack_range = 160.0
	# Setup SIEGE
	SIEGE.attack_damage = 100.0
	SIEGE.type = structure_list.SIEGE
	SIEGE.unit_name = "SIEGE"
	SIEGE.cost = 1200
	SIEGE.attack_radius = 128.0
	SIEGE.attack_range = 640.0
	# Setup INSTANT hit
	INSTANT.attack_damage = 15.0
	INSTANT.type = structure_list.INSTANT
	INSTANT.unit_name = "INSTANT"
	INSTANT.cost = 800
	INSTANT.attack_radius = 160.0
	INSTANT.attack_range = 384.0
	# Setup PROJECTILE hit
	PROJECTILE.attack_damage = 20.0
	PROJECTILE.type = structure_list.PROJECTILE
	PROJECTILE.unit_name = "PROJECTILE"
	PROJECTILE.cost = 600
	PROJECTILE.attack_radius = 128.0
	PROJECTILE.attack_range = 512.0
