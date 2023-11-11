extends Node
class_name StructureData

var type
var cost : int = 100
var health : int = 300

var attack_damage : int = 100

var delay_between_shots : float = 0.5 # Pause between each shot being fired
var reload_time : float = 2.0 # How long it takes to reload - Minimum is 0.75
var shots_before_reload : int = 5 # Number of shots you can take before reloading
var delay_before_explode : float = 0.5 # For the landmines
