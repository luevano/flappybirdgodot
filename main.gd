class_name Main
extends Node2D

var score: int = 0
var is_game_running: bool = false
var is_game_over: bool = false

@onready var high_score: int = Data.get_high_score()


func _ready():
	Event.game_restart.connect(_on_game_restart)
	Event.player_death.connect(_on_player_death)
	Event.player_score.connect(_on_player_score)


func _input(event: InputEvent):
	if (
		not is_game_running
		and (event.is_action_pressed("jump") or event.is_action_pressed("touch"))
	):
		is_game_running = true
		Event.game_start.emit()

	if not is_game_over and event.is_action_pressed("pause"):
		is_game_running = !is_game_running
		Event.game_pause.emit(is_game_running)

	if event.is_action_pressed("restart"):
		Event.game_restart.emit()


func _on_game_restart():
	get_tree().reload_current_scene()


func _on_player_death():
	is_game_over = true
	Event.game_over.emit()


func _on_player_score():
	score += 1
	if score > high_score:
		high_score = score
		Data.set_high_score(high_score)
		Data.save()
	Event.new_score.emit(score, high_score)
