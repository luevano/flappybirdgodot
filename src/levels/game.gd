class_name Game
extends Node2D

signal game_started
signal game_over

onready var player: Player = $Player
onready var background: Sprite= $Background
onready var world_tiles: WorldTiles = $WorldTiles
onready var ceiling_detector: Area2D = $CeilingDetector
onready var world_detector: Node2D = $WorldDetector
onready var camera: Camera2D = $Camera

var score: int = 0

var _game_scale: float = ProjectSettings.get_setting("application/config/game_scale")
var player_speed: float
var is_game_running: bool = false


func _ready() -> void:
	scale = Vector2(_game_scale, _game_scale)
	# so we move at the actual speed of the player
	player_speed = player.SPEED / _game_scale

	player.connect("died", self, "_on_player_died")
	ceiling_detector.connect("body_entered", player, "_on_ceiling_detector_body_entered")
	world_detector.connect("ground_stopped_colliding", world_tiles, "_on_world_detector_ground_stopped_colliding")
	world_detector.connect("ground_started_colliding", world_tiles, "_on_world_detector_ground_started_colliding")
	world_detector.connect("pipe_started_colliding", world_tiles, "_on_world_detector_pipe_started_colliding")

	# need to start without processing, so we can move through the menus
	_set_processing_to(false)


func _input(event: InputEvent) -> void:
	if not is_game_running and event.is_action_pressed("jump"):
		emit_signal("game_started")
		_set_processing_to(true)
		is_game_running = true


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


func _on_player_died() -> void:
	player.set_collision_mask_bit(2, false)
	_set_processing_to(false, false)
	print("game_over")
	emit_signal("game_over")


func _on_score_detector_body_entered(body: Node2D) -> void:
	score += 1
	# counter_label.set_text("%s" % score)
	print(score)