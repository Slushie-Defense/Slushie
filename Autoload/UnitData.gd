extends Node

# Structure types
enum structure_list { FENCE, INSTANT, PROJECTILE, SIEGE, LANDMINE }

# Structures
var FENCE : StructureData = StructureData.new() 
var LANDMINE : StructureData = StructureData.new()
var INSTANT : StructureData = StructureData.new()
var SIEGE : StructureData = StructureData.new()
var PROJECTILE : StructureData = StructureData.new()

# Enemy types
enum enemy_list { BASIC, TANK, FLOATER, GRUNT, SPITTER }
enum enemy_attack_list { MELEE, SIEGE, EXPLODE }

# Enemies
var BASIC : EnemyData = EnemyData.new()
var GRUNT : EnemyData = EnemyData.new()
var TANK : EnemyData = EnemyData.new()
var SPITTER : EnemyData = EnemyData.new()
var FLOATER : EnemyData = EnemyData.new()

# Enemy Weapon
var SPITTER_SIEGE : StructureData = StructureData.new()

# Player Weapons
var SLUSHY_GUN : StructureData = StructureData.new()

func _ready():
	# STRUCTURES
	
	# Setup FENCE
	FENCE.type = structure_list.FENCE
	FENCE.unit_name = "FENCE"
	FENCE.description = "Hold lane"
	FENCE.cost = 500
	FENCE.attack_damage = 0.0
	FENCE.ui_sprite = load("res://Sprites/Structures/Fence/128x192Fence.png")
	FENCE.build_speed = 0.2
	FENCE.health = 1000;	
	
	# Setup LANDMINE
	LANDMINE.delay_before_fireweapon = 0.5
	LANDMINE.type = structure_list.LANDMINE
	LANDMINE.unit_name = "LANDMINE"
	LANDMINE.description = "Emergency"
	LANDMINE.cost = 500
	LANDMINE.attack_damage = 150.0
	LANDMINE.attack_radius = 80.0
	LANDMINE.attack_range = 160.0
	LANDMINE.attack_collision_mask_list = [[2, false], [3, false], [4, true]]
	LANDMINE.ui_sprite = load("res://Sprites/Structures/Landmine/128x192Landmine.png")
	LANDMINE.build_speed = 10.0
	
	# Setup SIEGE
	SIEGE.type = structure_list.SIEGE
	SIEGE.unit_name = "SIEGE"
	SIEGE.description = "Hate crowds"
	SIEGE.cost = 750
	SIEGE.attack_damage = 100.0
	SIEGE.attack_radius = 128.0
	SIEGE.attack_range = 640.0
	SIEGE.ui_sprite = load("res://Sprites/Structures/Siege/128x192Siege.png")
	SIEGE.build_speed = 0.5
	SIEGE.delay_before_fireweapon = 1.0
	SIEGE.delay_between_shots = 0
	SIEGE.reload_time = 3
	SIEGE.shots_before_reload = 1
	
	# Setup INSTANT hit
	INSTANT.type = structure_list.INSTANT
	INSTANT.unit_name = "PEWPEW"
	INSTANT.description = "Real fast"
	INSTANT.cost = 100
	INSTANT.attack_damage = 3.0
	INSTANT.attack_radius = 160.0
	INSTANT.attack_range = 768.0
	INSTANT.ui_sprite = load("res://Sprites/Structures/Instant/128x192Instant.png")
	INSTANT.build_speed = 0.5
	INSTANT.health = 30
	INSTANT.delay_before_fireweapon = 0.06 # Always keep a minimum of 0.06
	INSTANT.delay_between_shots = 0.1
	INSTANT.reload_time = 1.0
	INSTANT.shots_before_reload = 10
	
	# Setup PROJECTILE hit
	PROJECTILE.type = structure_list.PROJECTILE
	PROJECTILE.unit_name = "CANNON"
	PROJECTILE.description = "Tank buster"
	PROJECTILE.cost = 200
	PROJECTILE.attack_damage = 150.0
	PROJECTILE.attack_radius = 512.0
	PROJECTILE.attack_range = 4096.0
	PROJECTILE.ui_sprite = load("res://Sprites/Structures/Projectile/128x192Projectile.png")
	PROJECTILE.build_speed = 0.4
	PROJECTILE.health = 50
	PROJECTILE.delay_before_fireweapon = 1.0
	PROJECTILE.delay_between_shots = 0
	PROJECTILE.reload_time = 1.5
	PROJECTILE.shots_before_reload = 1
	
	# ENEMIES
	# Setup BASIC
	BASIC.unit_name = "Basic"
	BASIC.health = 9
	BASIC.coin_drop_value = 5.0
	BASIC.attack_speed = 1.0 # Delay between attacks
	BASIC.attack_range = 64 # In pixels
	BASIC.attack_damage = 2
	BASIC.acceleration = 2000
	BASIC.max_speed = 100
	BASIC.vision_radius = 160
	BASIC.basic_sprite = load("res://Sprites/Characters/Enemies/Basic/Basic256x256.png")
	BASIC.collision_shape_radius = 32
	BASIC.attack_type = UnitData.enemy_attack_list.MELEE
	
	# Setup GRUNT
	GRUNT.unit_name = "Grunt"
	GRUNT.health = 45
	GRUNT.coin_drop_value = 10.0
	GRUNT.attack_speed = 1.0 # Delay between attacks
	GRUNT.attack_range = 64 # In pixels
	GRUNT.attack_damage = 5
	GRUNT.acceleration = 2000
	GRUNT.max_speed = 100
	GRUNT.vision_radius = 320
	GRUNT.basic_sprite = load("res://Sprites/Characters/Enemies/Grunt/Grunt256x256.png")
	GRUNT.collision_shape_radius = 48
	GRUNT.attack_type = UnitData.enemy_attack_list.MELEE
	
	# Setup TANK
	TANK.unit_name = "Tank"
	TANK.health = 300
	TANK.coin_drop_value = 50.0
	TANK.attack_speed = 1.0 # Delay between attacks
	TANK.attack_range = 64 # In pixels
	TANK.attack_damage = 0
	TANK.acceleration = 2000
	TANK.max_speed = 75
	TANK.vision_radius = 160
	TANK.basic_sprite = load("res://Sprites/Characters/Enemies/Tank/Tank256x256.png")
	TANK.collision_shape_radius = 64
	TANK.attack_type = UnitData.enemy_attack_list.MELEE
	
	# Setup SPITTER
	SPITTER.unit_name = "Spitter"
	SPITTER.health = 100
	SPITTER.coin_drop_value = 25.0
	SPITTER.attack_speed = 1.0 # Delay between attacks
	SPITTER.attack_range = 64 # In pixels
	SPITTER.attack_damage = 25
	SPITTER.acceleration = 1000
	SPITTER.max_speed = 25
	SPITTER.vision_radius = 160
	SPITTER.basic_sprite = load("res://Sprites/Characters/Enemies/Spitter/Spitter256x256.png")
	SPITTER.collision_shape_radius = 56
	SPITTER.attack_type = UnitData.enemy_attack_list.SIEGE
	
	# Setup SPITTER WEAPON
	SPITTER_SIEGE.type = structure_list.SIEGE
	SPITTER_SIEGE.unit_name = "Spitter Siege"
	SPITTER_SIEGE.cost = 0
	
	# The variables below have been modified to sync up with the spitting animation
	SPITTER_SIEGE.delay_before_fireweapon = 1.2 # Animation synced - Do not edit this
	SPITTER_SIEGE.delay_between_shots = 1.5 # Animation synced -Do not edit this
	SPITTER_SIEGE.reload_time = 1.5 # Animation synced -Do not edit this
	SPITTER_SIEGE.shots_before_reload = 1 # Animation synced -Do not edit this

	SPITTER_SIEGE.attack_damage = 100.0
	SPITTER_SIEGE.attack_radius = 128.0
	SPITTER_SIEGE.attack_range = 640.0
	SPITTER_SIEGE.attack_direction = -1 # AIM LEFT
	SPITTER_SIEGE.attack_collision_mask_list = [[2, true], [3, true], [4, false]]
	
	SPITTER_SIEGE.projectile_sprite = load("res://Sprites/Projectiles/Eyeball64x64.png")
	SPITTER_SIEGE.projectile_color = Color("#ffffff")
	SPITTER_SIEGE.ui_sprite = load("res://Sprites/Structures/Siege/128x192Siege.png")
	
	# Setup FLOATER
	FLOATER.unit_name = "Floater"
	FLOATER.health = 18
	FLOATER.coin_drop_value = 5.0
	FLOATER.attack_speed = 1.0 # Delay between attacks
	FLOATER.attack_range = 96 # In pixels
	FLOATER.attack_damage = 50
	FLOATER.acceleration = 2000
	FLOATER.max_speed = 150
	FLOATER.vision_radius = 160
	FLOATER.basic_sprite = load("res://Sprites/Characters/Enemies/Floater/Floater256x256.png")
	FLOATER.collision_shape_radius = 32
	FLOATER.attack_type = UnitData.enemy_attack_list.EXPLODE
	
	# PLAYER WEAPONS
	SLUSHY_GUN.type = structure_list.INSTANT
	SLUSHY_GUN.unit_name = "Slushy Gun"
	SLUSHY_GUN.cost = 800
	SLUSHY_GUN.attack_damage = 15.0
	SLUSHY_GUN.attack_radius = 160.0
	SLUSHY_GUN.attack_range = 384.0
	SLUSHY_GUN.ui_sprite = load("res://Sprites/Structures/Instant/128x192Instant.png")
