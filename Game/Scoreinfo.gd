extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	refresh_labels()
	
func refresh_labels():
	$Background/Score.text = String(Global.SCORE)
	$Background/Collected.text = String(Global.FOOD_COLLECTED)
