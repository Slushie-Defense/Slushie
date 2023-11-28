class_name EnemySpawnInfo
extends Resource

# Spawn types
enum spawn_type { SIMULTANEOUS_ALL, CONSECUTIVE_ALL, CONSECUTIVE_ONE }
# SIMULATANEOUS_ALL - Spawn at all open portals simultaneously
# CONSECUTIVE_ALL - Spawn at any open portal one at a time
# CONSECUTIVE_ONE - Spawn at one open portal one at a time

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
@export var spawn_method = spawn_type.CONSECUTIVE_ALL
