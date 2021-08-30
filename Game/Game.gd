extends Node2D

var GO_Screen = preload("res://Game/GameOver.tscn")


func _ready():
	reset_values()


func _process(delta):
	input_handler()
	game_over_checker()


func reset_values():
	Global.SCORE = 0
	Global.FOOD_COLLECTED = 0


func input_handler():
	if Input.is_action_just_pressed("fullscreen_toggle"):
		OS.window_fullscreen = !OS.window_fullscreen


func game_over_checker():
	if not Global.PLAYER_ALIFE:
		var over = GO_Screen.instance()
		get_tree().get_root().get_node("Game").add_child(over)
