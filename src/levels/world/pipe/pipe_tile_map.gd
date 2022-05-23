class_name PipeTileMap
extends TileMap

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

const _initial_new_pipe_x: int = 11

onready var _pipe_sep: int = get_parent().PIPE_SEP
const _pipe_size: int = 16
const _ground_level: int = 7
const _pipe_level_y: int = _ground_level - 1
var new_pipe_starting_position: Vector2 = Vector2(_initial_new_pipe_x, _pipe_level_y)
var pipe_stack: Array

# don't specify type for game, as it results in cyclic dependency,
# as stated here: https://godotengine.org/qa/39973/cyclic-dependency-error-between-actor-and-actor-controller
onready var game = get_parent().get_parent()
var detector_scene: PackedScene = preload("res://levels/detectors/score_detector/ScoreDetector.tscn")
var detector_stack: Array
var detector_offset: Vector2 = Vector2(16.0, -(_pipe_size / 2.0) * 16.0)


func _place_new_pipe() -> void:
    var current_pipe: Vector2 = new_pipe_starting_position
    for tile in pipe[_get_random_pipe()]:
        set_cellv(current_pipe, tile)
        current_pipe += Vector2.UP

    var detector: Area2D = detector_scene.instance()
    detector.position = map_to_world(new_pipe_starting_position) + detector_offset
    detector.connect("body_entered", game, "_on_ScoreDetector_body_entered")
    detector_stack.append(detector)
    add_child(detector)

    pipe_stack.append(new_pipe_starting_position)
    new_pipe_starting_position += _pipe_sep * Vector2.RIGHT


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


func _on_WorldTiles_place_pipe() -> void:
    _place_new_pipe()


func _on_WorldTiles_remove_pipe() -> void:
    _remove_old_pipe()
