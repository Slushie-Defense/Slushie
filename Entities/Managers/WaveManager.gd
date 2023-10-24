extends Node

var enemy_scene = load("res://Entities/Enemy/Enemy.tscn")
@export var spawn_timer: float

var timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	# every 5 seconds, spawn an enemy_scene
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if (timer >= spawn_timer):
		spawn_enemy()
		timer = 0.0

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(2000, 500)
	add_child(enemy)
