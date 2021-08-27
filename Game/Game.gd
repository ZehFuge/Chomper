extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_values()


func _process(delta):
	input_handler()


func reset_values():
	Global.SCORE = 0
	Global.FOOD_COLLECTED = 0


func input_handler():
	if Input.is_action_just_pressed("fullscreen_toggle"):
		OS.window_fullscreen = !OS.window_fullscreen
