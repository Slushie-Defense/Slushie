extends Node
class_name EnemyData

var unit_name : String = "Grunt"
var health : int = 100
var collision_shape_radius : int = 32

var coin_drop_value : float = 100.0

var attack_speed : float = 1.0 # Delay between attacks
var attack_range : int = 64 # In pixels
var attack_damage : int = 100

var acceleration : float = 2000
var max_speed : float = 100
var vision_radius : int = 160

var basic_sprite = load("res://Sprites/Characters/Enemies/Basic/Basic256x256.png")
