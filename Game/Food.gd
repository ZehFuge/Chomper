extends Area2D

export var VALUE : int = 5
var RNG = RandomNumberGenerator.new()
var grid_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	RNG.randomize()
	set_design()
	grid_position = Global.get_grid_pos(global_position)
	set_start()


func _process(delta):
	lava_checker()


func _on_Area2D_area_entered(area):
	if self.visible:
		if area.is_in_group("player"):
			collect_food()
			self.visible = false

func collect_food():
	Global.SCORE += VALUE * Global.MULTIPLIER
	Global.FOOD_COLLECTED += 1
	start_revisible_timer()

# set variations of the sprite
func set_design():
	RNG.randomize()
	var dice = RNG.randi_range(1, 2)
	
	if dice == 1:
		$AnimatedSprite.play("meat1")
	else:
		$AnimatedSprite.play("meat2")

func start_revisible_timer():
	var dice = RNG.randi_range(60, 90)
	$RevisibleTimer.wait_time = dice
	$RevisibleTimer.start()

func _on_RevisibleTimer_timeout():
	self.visible = true


func _on_StartVisibility_timeout():
	self.visible = true


func set_start():
	var dice = RNG.randi_range(1, 60)
	$StartVisibility.wait_time = dice
	$StartVisibility.start()

# Destroys food if on lava tile
func lava_checker():
	if Global.MAP_ARRAY[grid_position[0]][grid_position[1]] == Global.LAVA_TILE:
		queue_free()
