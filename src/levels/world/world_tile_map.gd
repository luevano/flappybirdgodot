class_name WorldTileMap
extends TileMap

# don't specify type for game, as it results in cyclic dependency,
# as stated here: https://godotengine.org/qa/39973/cyclic-dependency-error-between-actor-and-actor-controller
@onready var game = get_parent().get_parent()
@export var PIPE_SEP: int = 6 # (int, 2, 20, 2)

enum Ground {
	TILE_1,
	TILE_2,
	TILE_3,
	TILE_DOWN_1,
}

enum PipePattern {
	PIPE_1,
	PIPE_2,
	PIPE_3,
	PIPE_4,
	PIPE_5,
	PIPE_6
}

var pipe: Dictionary = {
	PipePattern.PIPE_1: [0, 1, 2, 2, 2, 2, 2, 2, 3, 4, -1, -1, -1, 0, 1, 2],
	PipePattern.PIPE_2: [0, 1, 2, 2, 2, 2, 2, 3, 4, -1, -1, -1, 0, 1, 2, 2],
	PipePattern.PIPE_3: [0, 1, 2, 2, 2, 2, 3, 4, -1, -1, -1, 0, 1, 2, 2, 2],
	PipePattern.PIPE_4: [0, 1, 2, 2, 2, 3, 4, -1, -1, -1, 0, 1, 2, 2, 2, 2],
	PipePattern.PIPE_5: [0, 1, 2, 2, 3, 4, -1, -1, -1, 0, 1, 2, 2, 2, 2, 2],
	PipePattern.PIPE_6: [0, 1, 2, 3, 4, -1, -1, -1, 0, 1, 2, 2, 2, 2, 2, 2]
}

var tiles_since_last_pipe: int = PIPE_SEP - 1
# old_tile is the actual first tile, whereas the new_tile_position
#	is the the next empty tile; these also correspond to the top tile
const _initial_old_tile_x: int = -8
const _initial_new_tile_x: int = 11
var old_tile_position: Vector2 = Vector2(_initial_old_tile_x, _ground_level)
var new_tile_position: Vector2 = Vector2(_initial_new_tile_x, _ground_level)

const _pipe_size: int = 16
const _ground_level: int = 7
const _pipe_level_y: int = _ground_level - 1
const _initial_new_pipe_x: int = 11
var new_pipe_starting_position: Vector2 = Vector2(_initial_new_pipe_x, _pipe_level_y)
var pipe_stack: Array

var detector_scene: PackedScene = preload("res://levels/detectors/score_detector/ScoreDetector.tscn")
var detector_offset: Vector2 = Vector2(16.0, -(_pipe_size / 2.0) * 16.0)
var detector_stack: Array


func _on_WorldDetector_ground_stopped_colliding() -> void:
	_place_new_ground()

	tiles_since_last_pipe += 1
	if tiles_since_last_pipe == PIPE_SEP:
		_place_new_pipe()
		tiles_since_last_pipe = 0


func _on_WorldDetector_ground_started_colliding() -> void:
	_remove_first_ground()


func _on_WorldDetector_pipe_started_colliding() -> void:
	_remove_old_pipe()


func _place_new_ground() -> void:
	set_cellv(new_tile_position, _get_random_ground())
	set_cellv(new_tile_position + Vector2.DOWN, Ground.TILE_DOWN_1)
	new_tile_position += Vector2.RIGHT


func _remove_first_ground() -> void:
	set_cellv(old_tile_position, -1)
	set_cellv(old_tile_position + Vector2.DOWN, -1)
	old_tile_position += Vector2.RIGHT


func _get_random_ground() -> int:
	return randi() % (Ground.size() - 1)


func _place_new_pipe() -> void:
	var current_pipe: Vector2 = new_pipe_starting_position
	for tile in pipe[_get_random_pipe()]:
		set_cellv(current_pipe, tile)
		current_pipe += Vector2.UP

	var detector: Area2D = detector_scene.instantiate()
	detector.position = map_to_local(new_pipe_starting_position) + detector_offset
	detector.connect("body_entered", Callable(game, "_on_ScoreDetector_body_entered"))
	detector_stack.append(detector)
	add_child(detector)

	pipe_stack.append(new_pipe_starting_position)
	new_pipe_starting_position += PIPE_SEP * Vector2.RIGHT


func _remove_old_pipe() -> void:
	var current_pipe: Vector2 = pipe_stack.pop_front()
	var c: int = 0
	while c < _pipe_size:
		set_cellv(current_pipe, -1)
		current_pipe += Vector2.UP
		c += 1

	var detector: Area2D = detector_stack.pop_front()
	remove_child(detector)
	detector.queue_free()


func _get_random_pipe() -> int:
	return randi() % PipePattern.size()
