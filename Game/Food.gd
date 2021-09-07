extends Area2D

export var HURRY_BORDER = 175

export var VALUE : int = 5
var RNG = RandomNumberGenerator.new()
var grid_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	RNG.randomize()
	set_design()
	grid_position = Global.get_grid_pos(global_position)


# warning-ignore:unused_argument
func _process(delta):
	lava_checker()


func _on_Area2D_area_entered(area):
	if self.visible:
		if area.is_in_group("player"):
			collect_food()


func collect_food():
	Jukebox.collect_sfx()
	self.visible = false
	Global.handle_meat_multiplier($AnimatedSprite.animation)
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
	var dice = RNG.randi_range(5, 20)
	$RevisibleTimer.wait_time = dice
	$RevisibleTimer.start()


func _on_RevisibleTimer_timeout():
	if Global.PLAYER_ALIFE:
		set_design()
		self.visible = true
		revisible_checker()


func set_start():
	$StartVisibility.wait_time = 1
	$StartVisibility.start()


# Destroys food if on lava tile
func lava_checker():
	var tile = Global.MAP_ARRAY[grid_position.x][grid_position.y]
	
	if tile == Global.LAVA_TILE:
		Global.FOOD_AVAILABLE -= 1
		if Global.FOOD_AVAILABLE <= HURRY_BORDER \
		and Jukebox.mode != "hurry":
			Jukebox.mode = "hurry"
			Jukebox.end_game_music()
		queue_free()


# checks if food gets visible at player position to autocollect
func revisible_checker():
	var grid_pos_temp = Global.get_grid_pos(global_position)
	
	if grid_pos_temp == Global.PLAYER_POS:
		collect_food()


func kill():
	queue_free()
