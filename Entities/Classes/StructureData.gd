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
var attack_direction : int = 1 # 1 is right. -1 is left
var attack_collision_mask_list : Array = [[2, false], [3, false], [4, true]]

var ui_sprite = load("res://Sprites/Structures/Fence/128x192Fence.png")

# Projectile data
var projectile_sprite = load("res://Sprites/Projectiles/Slushy64x64.png")
var projectile_color = Color("#EE00FF")
