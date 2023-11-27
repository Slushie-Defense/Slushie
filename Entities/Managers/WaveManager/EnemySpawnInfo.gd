class_name EnemySpawnInfo
extends Resource

@export var enemies: Array[PackedScene]

@export var portals: PackedStringArray = ["TopPortal", "MiddleTopPortal", "MiddlePortal", "MiddleBottomPortal", "BottomPortal"]
# the number of enemies to spawn at once, in a group
@export var number_to_spawn_at_once : int
# the time between each enemy spawn
@export var total_time: float
# number of groups to spawn
@export var number_to_spawn: int
