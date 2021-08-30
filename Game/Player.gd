extends KinematicBody2D


var move_direction := Vector2(0, 0)
export var move_speed : int = 50
var grid_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.PLAYER_ALIFE = true
	grid_position = Global.get_grid_pos(global_position)
	Global.PLAYER_POS = Global.get_grid_pos(global_position)
	Global.PLAYER_AROUND = Global.check_tiles_around_me(Global.PLAYER_POS)


func _physics_process(delta):
	grid_position = Global.get_grid_pos(global_position)
	check_tile(grid_position)
	input_handler()
	move_and_collide(move_direction * delta)
	Global.PLAYER_POS = Global.get_grid_pos(global_position)
	Global.PLAYER_AROUND = Global.check_tiles_around_me(Global.PLAYER_POS)


func input_handler():
	if Input.is_action_pressed("move_up") and Global.PLAYER_ALIFE:
		move_direction.y = -1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	elif Input.is_action_pressed("move_down") and Global.PLAYER_ALIFE:
		move_direction.y = 1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	else:
		move_direction.y = 0
	if Input.is_action_pressed("move_left") and Global.PLAYER_ALIFE:
		move_direction.x = -1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
	elif Input.is_action_pressed("move_right") and Global.PLAYER_ALIFE:
		move_direction.x = 1
		if not $Sprite.flip_h:
			$Sprite.flip_h = true
	else:
		move_direction.x = 0
	
	if Input.is_action_just_pressed("function_tester"):
		#Global.print_map_array()
		pass
	
	if Global.PLAYER_ALIFE:
		handle_animation(move_direction)
	move_direction = move_direction.normalized() * move_speed


func check_tile(pos):
	if Global.MAP_ARRAY[pos[0]][pos[1]] == Global.LAVA_TILE:
		if Global.PLAYER_ALIFE:
			die()


func die():
	Global.PLAYER_ALIFE = false
	$Sprite.animation = "dying"
	$Sprite.play()


func handle_animation(move_vector):
	if move_vector.x != 0 and move_vector.y == 0:
		$Sprite.animation = "walk_x"
		$Sprite.play()
	elif move_vector.y == 1 and move_vector.x == 0:
		$Sprite.animation = "walk_down"
		$Sprite.play()
	elif move_vector.y == -1 and move_vector.x == 0:
		$Sprite.animation = "walk_x"
		$Sprite.play()
	else:
		$Sprite.animation = "idle"
		$Sprite.playing = false


func _on_Sprite_animation_finished():
	if $Sprite.animation == "dying":
		# replace queue_free() with score.tscn
		queue_free()
