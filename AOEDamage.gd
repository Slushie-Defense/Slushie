extends Node2D

@onready var explosion_sprite : Sprite2D = $Sprite2D
@onready var collision_detection : Area2D = $Area2D
@onready var collsion_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var damage_delay_timer : Timer

var damage_fallout_curve : Curve = load("res://Entities/Explosion/DamageFallout.tres")
var explosion_radius : float = 64.0

var nodes_in_area_list : Array = []
var damage_at_center : float = 50

func _on_area_2d_body_entered(body):
	nodes_in_area_list.push_back(body)

func _on_timer_timeout():
	print(nodes_in_area_list)
	# Chase nodes
	if nodes_in_area_list.size() > 0:
		# Chase the nearest node
		for child in nodes_in_area_list:
			if child.has_method("attack"):
				var distance_from_center : float = global_position.distance_to(child.global_position)
				var attack = Attack.new()
				attack.damage = damage_at_center * damage_fallout_curve.sample(distance_from_center / explosion_radius)
				child.attack(attack)
