class_name EnemySpawnInfo # Group 
extends Resource

@export var enemies: Array[PackedScene]
@export var type: Array = [[0, "BASIC"], [0, "SPITTER"], [0, "SIEGE"], [0, "GRUNT"], [0, "FLOATER"]]
@export var portals: PackedStringArray = ["TopPortal", "MiddleTopPortal", "MiddlePortal", "MiddleBottomPortal", "BottomPortal"]
@export var number_to_spawn_at_once = 1
@export var total_time: float
