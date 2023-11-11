extends Node

var LANDMINE : WeaponData = WeaponData.new()
var INSTANT : WeaponData = WeaponData.new()
var SIEGE : WeaponData = WeaponData.new()
var PROJECTILE : WeaponData = WeaponData.new()

func _ready():
	"""
	Variables you can alter
	var attack_damage : int = 100
	var delay_between_shots : float = 0.5 # Pause between each shot being fired
	var reload_time : float = 2.0 # How long it takes to reload - Minimum is 0.75
	var shots_before_reload : int = 5 # Number of shots you can take before reloading
	var delay_before_explode : float = 0.5 # For the LANDMINEs
	"""
	# Setup LANDMINE
	LANDMINE.attack_damage = 100.0
	LANDMINE.delay_before_explode = 0.5
	# Setup SIEGE
	SIEGE.attack_damage = 100.0
	# Setup INSTANT hit
	INSTANT.attack_damage = 15.0
	# Setup PROJECTILE hit
	PROJECTILE.attack_damage = 20.0
