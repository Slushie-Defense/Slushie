extends Node
class_name StructureData

var unit_name : String = "FENCE"
var type
var cost : int = 100
var health : int = 300

var delay_between_shots : float = 0.5 # Pause between each shot being fired
var reload_time : float = 2.0 # How long it takes to reload - Minimum is 0.75
var shots_before_reload : int = 5 # Number of shots you can take before reloading
var delay_before_explode : float = 0.5 # For the landmines

var attack_damage : int = 100
var attack_range : float = 512.0
var attack_radius : float = 96.0
