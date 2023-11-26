class_name EnemySpawnInfo
extends Resource

@export var enemies: Array[PackedScene]
@export var type: String
@export var portals: PackedStringArray = ["TopPortal", "MiddleTopPortal", "MiddlePortal", "MiddleBottomPortal", "BottomPortal"]
@export var number_to_spawn_at_once = 1
@export var total_time: float
@export var number_to_spawn: int
