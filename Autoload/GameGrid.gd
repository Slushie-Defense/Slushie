extends Node

const cell_size : float = 128.0

func convert_coordinate_to_grid_position(coordinate : Vector2 = Vector2(0,0)):
	var position_x = floor(coordinate.x / cell_size)
	var position_y = floor(coordinate.y / cell_size)
	return Vector2(position_x, position_y)

func convert_grid_position_to_top_left_corner_coordinate(grid_position):
	return grid_position * cell_size

func snap_coordinate_to_grid_top_left_corner(coordinate):
	var grid_position = GameGrid.convert_coordinate_to_grid_position(coordinate)
	return GameGrid.convert_grid_position_to_top_left_corner_coordinate(grid_position)
