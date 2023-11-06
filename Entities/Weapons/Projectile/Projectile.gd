extends Node2D

var target_position : Vector2 = Vector2(1280, 720)
var speed : float = 200  # Adjust the speed as needed

func _process(delta: float):
	# Calculate the direction vector from the current position to the target position
	var direction = (target_position - position).normalized()

	# Move the projectile in the calculated direction with a constant speed
	position += direction * speed * delta

	# Check if the projectile has reached the target
	if position.distance_to(target_position) < speed * delta:
		# The projectile has reached the target, so you can handle that here
		queue_free()  # Destroy the projectile, for example
