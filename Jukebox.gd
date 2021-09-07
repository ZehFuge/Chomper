extends Node2D

# preload music
const EARLY_GAME = preload("res://Music/Early_Game.ogg")
const END_GAME = preload("res://Music/End_Game.ogg")
const MENU = preload("res://Music/Menu.ogg")
const DEATH = preload("res://Music/Death.ogg")

# maximum loudness set by try & error
const EARLY_GAME_LOUDNESS = -15
const END_GAME_LOUDNESS = -15
const MENU_LOUDNESS = -15
const DEATH_LOUDNESS = -15

# preload SFX
const COLLECT_SFX = preload("res://SFX/Food_Collect.ogg")

# maximum loudness set by try & error
const COLLECT_SFX_LOUDNESS = -25

var mode = "game"

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_music()


func menu_music(track = MENU):
	var already_playing = already_playing(track)
	if not already_playing:
		$MusicPlayer.stream = track
		$MusicPlayer.volume_db = MENU_LOUDNESS
		$MusicPlayer.play()


func end_game_music(track = END_GAME):
	var already_playing = already_playing(track)
	if not already_playing:
		$MusicPlayer.stream = track
		$MusicPlayer.volume_db = END_GAME_LOUDNESS
		$MusicPlayer.play()


func death_music(track = DEATH):
	var already_playing = already_playing(track)
	if not already_playing:
		$MusicPlayer.stream = track
		$MusicPlayer.volume_db = DEATH_LOUDNESS
		$MusicPlayer.play()


func collect_sfx(track = COLLECT_SFX):
	if $SFXPlayer.stream != track:
		$SFXPlayer.stream = track
		$SFXPlayer.volume_db = COLLECT_SFX_LOUDNESS
	$SFXPlayer.play()


func already_playing(track):
	if $MusicPlayer.stream == track:
		return true
	else:
		return false
