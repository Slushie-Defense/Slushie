class_name GroupSpawn
extends Resource

# Spawn types
enum spawn_type { ALL_AT_ONCE, RANDOM_ANY, RANDOM_SAME }
# Spawn at all open portals - simultaneously
# Spawn at any open portal - one at a time
# Spawn at one open portal - one at a time

@export var basic : int = 0
@export var grunt : int = 0
@export var spitter : int = 0
@export var tank : int = 0
@export var floater : int = 0

# Delay before the group spawns
@export var group_delay_time : float = 0.5
# Delay between spawns
@export var spawn_delay_time : float = 0.5
# Spawn one at a time
@export var spawn_method = spawn_type.RANDOM_ANY

func _init(
	basicn: int, gruntn: int, spittern: int, tankn: int, floatern: int,
	gdelay: float, sdelay: float
):
	basic = basicn
	grunt = gruntn
	spitter = spittern
	tank = tankn
	floater = floatern
	group_delay_time = gdelay
	spawn_delay_time = sdelay
