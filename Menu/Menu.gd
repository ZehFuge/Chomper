extends Node2D

var START_MENU = preload("res://Menu/StartMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_menu()


func _process(delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		OS.window_fullscreen = !OS.window_fullscreen


func start_menu():
	var menu = START_MENU.instance()
	add_child(menu)
