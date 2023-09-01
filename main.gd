class_name Main
extends Node2D

@onready var player: Player = $Player
@onready var detectors: Detectors = $Detectors
@onready var camera: Camera2D = $Camera3D

@onready var high_score: int = Data.get_high_score()
var score: int = 0

var player_speed: float
var is_game_running: bool = false
var is_game_over: bool = false


func _ready() -> void:
	set_physics_process(false)
	Event.game_start.connect(set_physics_process.bind(true))
	Event.game_over.connect(set_physics_process.bind(false))
	Event.game_pause.connect(set_physics_process)
	Event.player_death.connect(_on_player_death)
	Event.player_score.connect(_on_player_score)

	# so we move at the actual speed of the player
	player_speed = player.SPEED


func _input(event: InputEvent) -> void:
	if not is_game_running and (event.is_action_pressed("jump") or
								event.is_action_pressed("touch")):
		is_game_running = true
		Event.game_start.emit()
	
	if not is_game_over and event.is_action_pressed("pause"):
		is_game_running = !is_game_running
		Event.game_pause.emit(is_game_running)

	if (event.is_action_pressed("restart") or
		(is_game_over and event.is_action_pressed("touch"))):
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	camera.move_local_x(player_speed * delta)
	detectors.move_local_x(player_speed * delta)


func _on_player_death() -> void:
	is_game_over = true
	Event.game_over.emit()


func _on_player_score() -> void:
	score += 1
	if score > high_score:
		high_score = score
		Data.set_new_high_score(high_score)
		Data.save_data()
	Event.new_score.emit(score, high_score)
