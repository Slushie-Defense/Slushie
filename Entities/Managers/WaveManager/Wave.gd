class_name Wave 
extends Resource

@export_group("Active Portals")
@export var top_portal : bool = false
@export var middle_top_portal : bool = false
@export var middle_portal : bool = false
@export var middle_bottom_portal : bool = false
@export var bottom_portal : bool = false

@export_group("Enemy Groups")
@export var enemy_group_list : Array[GroupSpawn] #Array of EnemySpawnInfo Resources
