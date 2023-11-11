extends Node

# Structures
var FENCE :StructureData =StructureData.new() 
var LANDMINE :StructureData = StructureData.new()
var INSTANT :StructureData = StructureData.new()
var SIEGE :StructureData = StructureData.new()
var PROJECTILE :StructureData = StructureData.new()

# Enemies

func _ready():
	"""
	Variables you can alter
	var attack_damage : int = 100
	var cost : int = 100
	var health : int = 300
	var delay_between_shots : float = 0.5 # Pause between each shot being fired
	var reload_time : float = 2.0 # How long it takes to reload - Minimum is 0.75
	var shots_before_reload : int = 5 # Number of shots you can take before reloading
	var delay_before_explode : float = 0.5 # For the LANDMINEs
	"""
	# Setup FENCE
	FENCE.attack_damage = 0.0
	# Setup LANDMINE
	LANDMINE.attack_damage = 100.0
	LANDMINE.delay_before_explode = 0.5
	# Setup SIEGE
	SIEGE.attack_damage = 100.0
	# Setup INSTANT hit
	INSTANT.attack_damage = 15.0
	# Setup PROJECTILE hit
	PROJECTILE.attack_damage = 20.0
