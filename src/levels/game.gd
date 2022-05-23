class_name Game
extends Node2D

signal game_started
signal game_over
signal new_score(score, high_score)

onready var player: Player = $Player
onready var background: Sprite= $Background
onready var world_tiles: WorldTiles = $WorldTiles
onready var ceiling_detector: Area2D = $CeilingDetector
onready var world_detector: Node2D = $WorldDetector
onready var camera: Camera2D = $Camera
onready var start_sound: AudioStreamPlayer = $StartSound
onready var score_sound: AudioStreamPlayer = $ScoreSound

onready var high_score: int = SavedData.get_high_score()
var score: int = 0

var _game_scale: float = ProjectSettings.get_setting("application/config/game_scale")
var player_speed: float
var is_game_running: bool = false


func _ready() -> void:
	scale = Vector2(_game_scale, _game_scale)
	# so we move at the actual speed of the player
	player_speed = player.SPEED / _game_scale

	player.connect("died", self, "_on_Player_died")
	ceiling_detector.connect("body_entered", player, "_on_CeilingDetector_body_entered")
	world_detector.connect("ground_stopped_colliding", world_tiles, "_on_WorldDetector_ground_stopped_colliding")
	world_detector.connect("ground_started_colliding", world_tiles, "_on_WorldDetector_ground_started_colliding")
	world_detector.connect("pipe_started_colliding", world_tiles, "_on_WorldDetector_pipe_started_colliding")

	# need to start without processing, so we can move through the menus
	_set_processing_to(false)


func _input(event: InputEvent) -> void:
	if not is_game_running and event.is_action_pressed("jump"):
		_set_processing_to(true)
		is_game_running = true
		emit_signal("game_started")
		start_sound.play()

	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	ceiling_detector.move_local_x(player_speed * delta)
	world_detector.move_local_x(player_speed * delta)
	background.move_local_x(player_speed * delta)
	camera.move_local_x(player_speed * delta)


func _set_processing_to(on_off: bool, include_player: bool = true) -> void:
	set_process(on_off)
	set_physics_process(on_off)
	if include_player:
		player.set_process(on_off)
		player.set_physics_process(on_off)
	world_tiles.set_process(on_off)
	world_tiles.set_physics_process(on_off)
	ceiling_detector.set_process(on_off)
	ceiling_detector.set_physics_process(on_off)


func _on_Player_died() -> void:
	_set_processing_to(false, false)
	emit_signal("game_over")


func _on_ScoreDetector_body_entered(body: Node2D) -> void:
	score += 1
	if score > high_score:
		high_score = score
		SavedData.set_new_high_score(high_score)
		SavedData.save_data()
	emit_signal("new_score", score, high_score)
	score_sound.play()
