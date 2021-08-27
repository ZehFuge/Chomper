extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_grid_position():
	var current_position = Vector2(int(global_position[0] / 16), int(global_position[1] / 16))
	return current_position


func check_neighbors():
	pass
