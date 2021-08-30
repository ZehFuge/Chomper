extends Node2D

var FOOD = preload("res://Game/Food.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map_array()	


func create_map_array():
	Global.MAP_ARRAY = set_map_array()
	set_walls_to_array()
	set_start_tiles()
	set_food_tiles()
	spawn_food()


# only calld once at beginning. Sets MAP_ARRAY size
func set_map_array():
	var array = []
	for column in Global.MAP_WIDTH:
		array.append([])
		for row in Global.MAP_HEIGHT:
			array[column].append(Global.FREE_TILE)
	return array


func set_walls_to_array():
	var tile_holder = get_node("ObstaclesMap").get_used_cells()
	
	for tile in tile_holder:
		Global.MAP_ARRAY[tile.x][tile.y] = Global.WALL_TILE


func set_start_tiles():
	for tile in Global.START_TILES:
		Global.MAP_ARRAY[tile[0]][tile[1]] = Global.START_TILE


func set_food_tiles():
	for column in Global.MAP_WIDTH:
		for row in Global.MAP_HEIGHT:
			if Global.MAP_ARRAY[column][row] == Global.FREE_TILE:
				Global.MAP_ARRAY[column][row] = Global.FOOD_TILE


func spawn_food():
	for column in Global.MAP_WIDTH:
		for row in Global.MAP_HEIGHT:
			if Global.MAP_ARRAY[column][row] == Global.FOOD_TILE:
				var food_item = FOOD.instance()
				food_item.position = Vector2(column * Global.TILE_SIZE - Global.ITEM_OFFSET, row * Global.TILE_SIZE - Global.ITEM_OFFSET)
				Global.FOOD_AVAILABLE += 1
				get_tree().get_root().get_node("Game/Playground/Food_Container").add_child(food_item)
