extends Node2D

var FOOD = preload("res://Game/Food.tscn")
var RNG = RandomNumberGenerator.new()

var FOOD_COLLECTED : int = 0
var SCORE : int = 0
var MULTIPLIER : int = 1

var MAP_ARRAY = []
const MAP_WIDTH = 32
const MAP_HEIGHT = 23
const PLAYGROUND_START = 1
const PLAYGROUND_END_X = 30
const PLAYGROUND_END_Y = 21
const TILE_SIZE = 16
const ITEM_OFFSET = 8
const FREE_TILE = 0
const WALL_TILE = 1
const FOOD_TILE = 2
const LAVA_TILE = 3
const PLAYER_TILE = 4
const START_TILE = 5
var BLANK_TILES = []
var START_TILES = [Vector2(13, 20), Vector2(12, 21), Vector2(13, 21), Vector2(14, 21)]
var FOOD_ITEMS = []
var PLAYER_POS = []

func _ready():
	randomize()
	MAP_ARRAY = set_map_array()
	

# only calld once at beginning. Sets MAP_ARRAY size
func set_map_array():
	var array = []
	for column in MAP_WIDTH:
		array.append([])
		for row in MAP_HEIGHT:
			array[column].append(FREE_TILE)
			
	return array


func set_start_tiles():
	for tile in START_TILES:
		MAP_ARRAY[tile[0]][tile[1]] = START_TILE
	set_food_tiles()


func set_food_tiles():
	for column in MAP_WIDTH:
		for row in MAP_HEIGHT:
			if MAP_ARRAY[column][row] == FREE_TILE:
				MAP_ARRAY[column][row] = FOOD_TILE
	spawn_food()


func spawn_food():
	for column in MAP_WIDTH:
		for row in MAP_HEIGHT:
			if MAP_ARRAY[column][row] == FOOD_TILE:
				var food_item = FOOD.instance()
				food_item.position = Vector2(column * TILE_SIZE - ITEM_OFFSET, row * TILE_SIZE - ITEM_OFFSET)
				
				get_tree().get_root().get_node("Game/Playground/Food_Container").add_child(food_item)

func random_lava_vector():
	var random_x = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_X)
	var random_y = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_Y)
	
	while MAP_ARRAY[random_x][random_y] != FOOD_TILE \
	and MAP_ARRAY[random_x][random_y] != LAVA_TILE:
		random_x = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_X)
		random_y = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_Y)
	return Vector2(random_x, random_y)


func get_grid_pos(pos):
	var current_position = Vector2(int(pos[0] / 16), int(pos[1] / 16))
	return current_position
	
