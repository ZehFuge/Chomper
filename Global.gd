extends Node2D

var RNG = RandomNumberGenerator.new()

var FOOD_COLLECTED : int = 0
var FOOD_AVAILABLE : int = 0
var SCORE : int = 0
var MULTIPLIER : int = 1
var FAVORITE_MEAT = "none"

var MAP_ARRAY = []
var MAP_ARRAY_COPY = []

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
var LAVA_TILES = []
var FOOD_ITEMS = []
var PLAYER_POS = []
var PLAYER_AROUND = []
var PLAYER_ALIFE = true

# used to check surounding tiles of the player
const AROUND_ME = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, -1)]
const AROUND_ME_LITE = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)]

func _ready():
	RNG.randomize()


func copy_map_array():
	MAP_ARRAY_COPY = MAP_ARRAY


func reset_map_array():
	MAP_ARRAY = MAP_ARRAY_COPY


func random_lava_vector():
	var random_x = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_X)
	var random_y = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_Y)
	var tile_type = get_tile_type(Vector2(random_x, random_y))
	
	while tile_type != "food":
		random_x = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_X)
		random_y = RNG.randi_range(PLAYGROUND_START, PLAYGROUND_END_Y)
		tile_type = get_tile_type(Vector2(random_x, random_y))
		
	return Vector2(random_x, random_y)


func get_tile_type(grid_pos):
	var type
	if MAP_ARRAY[grid_pos[0]][grid_pos[1]] == FOOD_TILE:
		type = "food"
		return type
	elif MAP_ARRAY[grid_pos[0]][grid_pos[1]] == WALL_TILE:
		type = "wall"
		return type
	elif MAP_ARRAY[grid_pos[0]][grid_pos[1]] == LAVA_TILE:
		type = "lava"
		return type


func get_grid_pos(pos):
	var current_position = Vector2(int(pos[0] / 16), int(pos[1] / 16))
	return current_position
	

# returns the grid vectors around the given position
func check_tiles_around_me(pos):
	var tile_array = []
	
	pos = get_grid_pos(pos)
	
	for tile in AROUND_ME:
		var saver = Vector2(pos[0] + tile[0], pos[1] + tile[1])
		tile_array.append(saver)
	return tile_array

# same as get_tiles_around_me but only returns 4 grid positions
func check_tiles_around_me_lava(grid_pos):
	var tile_array = []
	
	for tile in AROUND_ME_LITE:
		var saver = Vector2(grid_pos[0] + tile[0], grid_pos[1] + tile[1])
		tile_array.append(saver)
	return tile_array


func print_map_array():
	var x_counter = MAP_WIDTH -1

	while x_counter > 12:
		print(MAP_ARRAY[x_counter])
		x_counter -= 1


func handle_meat_multiplier(meat):
	if FAVORITE_MEAT == meat:
		MULTIPLIER += 1


func change_favorite_food():
	if FAVORITE_MEAT == "none":
		var dice = RNG.randi_range(1, 2)
		FAVORITE_MEAT = "meat" + String(dice)
	elif FAVORITE_MEAT == "meat1":
		FAVORITE_MEAT = "meat2"
		MULTIPLIER = 1
	else:
		FAVORITE_MEAT = "meat1"
		MULTIPLIER = 1
