extends TileMap

const UPPER_TILE = Vector2(0, -1)
const LOWER_TILE = Vector2(0, 1)
const LEFT_TILE = Vector2(-1, 0)
const RIGHT_TILE = Vector2(1, 0)

var MODE = "down"
var MODULATION = Color(float(0.7), float(0.7), float(0.7))
var RNG = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$VulcanDelay.start()
		
func _process(delta):
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
	#update_adjecent_tiles(random)


func update_adjecent_tiles(pos):
	pass


func _on_VulcanDelay_timeout():
	set_lava_tiles()
	$VulcanDelay.start()
