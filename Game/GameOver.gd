extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()


func _on_Replay_pressed():
	get_tree().call_group("food","kill")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game/Game.tscn")
