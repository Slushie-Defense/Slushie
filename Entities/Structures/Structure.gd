extends Node2D

@onready var collision_shape_2d : CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready():
	collision_shape_2d.shape.size = GameGrid.cell_size
