extends TileMap

const UPPER_TILE = Vector2(0, -1)
const LOWER_TILE = Vector2(0, 1)
const LEFT_TILE = Vector2(-1, 0)
const RIGHT_TILE = Vector2(1, 0)

var MODE = "down"
var MODULATION = Color(float(0.7), float(0.7), float(0.7))
var FIRST_LAVA = true
var restart_expand = true
export var EXPAND_DELAY = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$ExpandDelay.wait_time = EXPAND_DELAY
	$VulcanDelay.start()
		
func _process(delta):
	time_tracker()
	handle_modulation()


# handles two functions to make the lava brighter and darker for more dynamic
func handle_modulation():
	if MODE == "down":
		make_darker()
	elif MODE == "up":
		make_brighter()


func make_darker():
	if MODULATION[0] > 0.5:
		MODULATION = Color(MODULATION[0]-0.0022, MODULATION[1]-0.0022, MODULATION[2]-0.0022)
		self.modulate = Color(MODULATION)
	else:
		MODE = "up"


func make_brighter():
	if MODULATION[0] < 0.7:
		MODULATION = Color(MODULATION[0]+0.0022, MODULATION[1]+0.0022, MODULATION[2]+0.0022)
		self.modulate = MODULATION
	else:
		MODE = "down"


# places a lava tile on the map randomly
func set_lava_tiles():
	var random = Global.random_lava_vector()
	set_cell(random[0], random[1], 0)
	Global.MAP_ARRAY[random.x][random.y] = Global.LAVA_TILE
	Global.LAVA_ORIGIN_MAP[random.x][random.y] = random
	Global.LAVA_AGE_MAP.append([random, 0])
	update_bitmask_region(Vector2(Global.PLAYGROUND_START, Global.PLAYGROUND_START), Vector2(Global.PLAYGROUND_END_X, Global.PLAYGROUND_END_Y))


# places a lava tile on the map with given grid_pos (used for expanding)
func lava_on_vector(grid_pos):
	set_cell(grid_pos.x, grid_pos.y, 0)
	Global.MAP_ARRAY[grid_pos.x][grid_pos.y] = Global.LAVA_TILE
	update_bitmask_region(Vector2(Global.PLAYGROUND_START, Global.PLAYGROUND_START), Vector2(Global.PLAYGROUND_END_X, Global.PLAYGROUND_END_Y))


# creates a new lava origin
func _on_VulcanDelay_timeout():
	if Global.FOOD_AVAILABLE > 49 \
	and Global.PLAYER_ALIFE:
		set_lava_tiles()
		update_lava_map()
		$VulcanDelay.start()
		
		if FIRST_LAVA:
			$ExpandDelay.start()
			FIRST_LAVA = false


# makes lava expand if the timer runs out
func _on_ExpandDelay_timeout():
	for tile in Global.LAVA_TILES:
		var around_me = Global.check_tiles_around_me_lava(tile)
		var origin = Global.LAVA_ORIGIN_MAP[tile.x][tile.y]
		
		# check if origin is still available in LAVA_AGE_MAP
		var origin_found = false
		for entry in Global.LAVA_AGE_MAP:
			if entry[0] == origin:
				origin_found = true
		
		
		if origin_found:
			for grid_pos in around_me:
				if Global.MAP_ARRAY[grid_pos.x][grid_pos.y] == Global.FOOD_TILE \
				or Global.MAP_ARRAY[grid_pos.x][grid_pos.y] == Global.START_TILE:
					lava_on_vector(grid_pos)
					Global.LAVA_ORIGIN_MAP[grid_pos.x][grid_pos.y] = origin
					update_lava_map()
	age_lava()
	$ExpandDelay.start()


# ages the lava origins after expanding the lava
# lava stops expanding at given age and then removed
func age_lava():
	for i in Global.LAVA_AGE_MAP.size():
		Global.LAVA_AGE_MAP[i][1] += 1
	remove_age()


# removes lava origin from age array
func remove_age():
	for entry in Global.LAVA_AGE_MAP:
		if entry[1] >= 10:
			Global.LAVA_AGE_MAP.erase(entry)


# used to check age while expanding
func get_age_by_origin(origin):
	for entry in Global.LAVA_AGE_MAP:
		if entry[0] == origin:
			return entry[1]


# update the autotile set for fitting textures
func update_lava_map():
	var lava_tiles = get_used_cells()
	Global.LAVA_TILES = lava_tiles


# makes lava expand faster if the player died
func time_tracker():
	if not Global.PLAYER_ALIFE:
		if restart_expand:
			restart_expand = false
			$ExpandDelay.wait_time = 0.1
			$ExpandDelay.start()
