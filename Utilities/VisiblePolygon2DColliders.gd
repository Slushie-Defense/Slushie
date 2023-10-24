extends Polygon2D

# This is just to make CollisionShape2D colliders visible on WebGL exports
# Temporary, will be removed
func _ready():
	polygon = get_parent().polygon
