extends Node2D

var FIRST_CHECK = true
const DEFAULT_TIME = 10
var CURRENT_DEFAULT = DEFAULT_TIME

func _ready():
	$ChangeFavorite.start()


func _process(delta):
	# keep sprite updated
	if $Sprite.animation != Global.FAVORITE_MEAT:
		$Sprite.animation = Global.FAVORITE_MEAT


func _on_ChangeFavorite_timeout():
	if FIRST_CHECK:
		FIRST_CHECK = false
		$ChangeFavorite.wait_time = DEFAULT_TIME
		
	if Global.PLAYER_ALIFE:
		Global.change_favorite_food()
		$ChangeFavorite.start()
