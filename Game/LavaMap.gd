extends TileMap

const UPPER_TILE = Vector2(0, -1)
const LOWER_TILE = Vector2(0, 1)
const LEFT_TILE = Vector2(-1, 0)
const RIGHT_TILE = Vector2(1, 0)

var MODE = "down"
var MODULATION = Color(float(0.7), float(0.7), float(0.7))
var FIRST_LAVA = true
var restart_expand = true
export var EXPAND_DELAY : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$ExpandDelay.wait_time = EXPAND_DELAY
	$VulcanDelay.start()
		
func _process(delta):
	time_tracker()
	handle_modulation()


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


func set_lava_tiles():
	var random = Global.random_lava_vector()
	set_cell(random[0], random[1], 0)
	Global.MAP_ARRAY[random.x][random.y] = Global.LAVA_TILE
	update_bitmask_region(Vector2(Global.PLAYGROUND_START, Global.PLAYGROUND_START), Vector2(Global.PLAYGROUND_END_X, Global.PLAYGROUND_END_Y))


func lava_on_vector(grid_pos):
	set_cell(grid_pos.x, grid_pos.y, 0)
	Global.MAP_ARRAY[grid_pos.x][grid_pos.y] = Global.LAVA_TILE
	update_bitmask_region(Vector2(Global.PLAYGROUND_START, Global.PLAYGROUND_START), Vector2(Global.PLAYGROUND_END_X, Global.PLAYGROUND_END_Y))


func _on_VulcanDelay_timeout():
	if Global.FOOD_AVAILABLE > 0 \
	and Global.PLAYER_ALIFE:
		set_lava_tiles()
		update_lava_map()
		$VulcanDelay.start()
		
		if FIRST_LAVA:
			$ExpandDelay.start()
			FIRST_LAVA = false


func _on_ExpandDelay_timeout():
	var around_me = Vector2.ZERO
	
	for tile in Global.LAVA_TILES:
		around_me = Global.check_tiles_around_me_lava(tile)
		for grid_pos in around_me:
			if Global.MAP_ARRAY[grid_pos.x][grid_pos.y] == Global.FOOD_TILE \
			or Global.MAP_ARRAY[grid_pos.x][grid_pos.y] == Global.START_TILE:
				lava_on_vector(grid_pos)
				update_lava_map()
	
	$ExpandDelay.start()


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
