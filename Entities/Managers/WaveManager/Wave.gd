class_name Wave 
extends Resource

@export var top_portal : bool = false
@export var middle_top_portal : bool = false
@export var middle_portal : bool = false
@export var middle_bottom_portal : bool = false
@export var bottom_portal : bool = false

@export var enemy_group_list : Array[GroupSpawn] #Array of EnemySpawnInfo Resources

func _init(
	p1: bool, p2: bool, p3: bool, p4: bool, p5: bool
):
	top_portal = p1
	middle_top_portal = p2
	middle_portal = p3
	middle_bottom_portal = p4
	bottom_portal = p5

func appendGroup(
	g1: int, g2: int, g3: int, g4: int, g5:int,
	gdelay: float, sdelay: float,
	spawnMethod: GroupSpawn.spawn_type = -1
):
	var newGroup = GroupSpawn.new(g1, g2, g3, g4, g5, gdelay, sdelay)
	enemy_group_list.append(newGroup)
	if (spawnMethod == -1):
		newGroup.spawn_method = GroupSpawn.spawn_type.RANDOM_ANY
	else:
		newGroup.spawn_method = spawnMethod

