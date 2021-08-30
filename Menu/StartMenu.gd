extends Node2D

var HOW_TO = preload("res://Menu/HowToMenu.tscn")

func _on_Exit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	get_tree().change_scene("res://Game/Game.tscn")
	queue_free()


func _on_HowTo_pressed():
	var menu = HOW_TO.instance()
	get_tree().get_root().get_node("Menu").add_child(menu)
	queue_free()
