extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	set_walls_to_array()
	

func set_walls_to_array():
	var tile_holder = get_node("ObstaclesMap").get_used_cells()
	
	for tile in tile_holder:
		Global.MAP_ARRAY[tile[0]][tile[1]] = Global.WALL_TILE
	Global.set_start_tiles()

