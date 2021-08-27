extends KinematicBody2D


var move_direction := Vector2(0, 0)
export var move_speed : int = 50
var grid_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	grid_position = Global.get_grid_pos(global_position)
	


func _physics_process(delta):
	grid_position = Global.get_grid_pos(global_position)
	check_tile(grid_position)
	input_handler()
	move_and_collide(move_direction * delta)
	Global.PLAYER_POS = Global.get_grid_pos(global_position)


func input_handler():
	if Input.is_action_pressed("move_up"):
		move_direction.y = -1
	elif Input.is_action_pressed("move_down"):
		move_direction.y = 1
	else:
		move_direction.y = 0
	if Input.is_action_pressed("move_left"):
		move_direction.x = -1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	elif Input.is_action_pressed("move_right"):
		move_direction.x = 1
		if not $Sprite.flip_h:
			$Sprite.flip_h = true
	else:
		move_direction.x = 0
		
	move_direction = move_direction.normalized() * move_speed


func check_tile(pos):
	if Global.MAP_ARRAY[pos[0]][pos[1]] == Global.LAVA_TILE:
		queue_free()
