class_name WorldTileMap
extends TileMap

@export_range(1.0, 150.0, 1.0) var SPEED: float = 60.0
@export_range(2, 20, 2) var PIPE_SEP: int = 6
@export var detector_scene: PackedScene

var ground_tiles_amount: int = 3
var ground_bottom_tile: Vector2i = Vector2i(4, 5)
var pipe_pattern_amount: int = 6
var tiles_since_last_pipe: int = PIPE_SEP - 1

# old_tile is the actual first tile, whereas the new_tile_position
#	is the the next empty tile; these also correspond to the top tile
const _initial_old_tile_x: int = -8
const _initial_new_tile_x: int = 11
var old_tile_position: Vector2i = Vector2i(_initial_old_tile_x, _ground_level)
var new_tile_position: Vector2i = Vector2i(_initial_new_tile_x, _ground_level)

const _pipe_size: int = 16
const _ground_level: int = 7
const _pipe_level_y: int = - _pipe_size + _ground_level
const _initial_new_pipe_x: int = 11
var new_pipe_position: Vector2i = Vector2i(_initial_new_pipe_x, _pipe_level_y)
var pipe_stack: Array

var detector_offset: Vector2 = Vector2(0.0, (256.0 / 2.0) - (16.0 / 2.0))
var detector_stack: Array

func _ready() -> void:
	set_physics_process(false)
	Event.game_start.connect(set_physics_process.bind(true))
	Event.game_over.connect(set_physics_process.bind(false))
	Event.game_pause.connect(set_physics_process)
	Event.ground_stopped_colliding.connect(_on_ground_stopped_colliding)
	Event.ground_started_colliding.connect(_on_ground_started_colliding)
	Event.pipe_started_colliding.connect(_on_pipe_started_colliding)


func _physics_process(delta: float) -> void:
	move_local_x(- SPEED * delta)


func _place_new_ground() -> void:
	var random_tile_index: int = randi_range(1, ground_tiles_amount)
	var random_tile: Vector2i = Vector2i(random_tile_index, 5)
	set_cell(0, new_tile_position, 0, random_tile)
	set_cell(0, new_tile_position + Vector2i.DOWN, 0, ground_bottom_tile)
	new_tile_position += Vector2i.RIGHT


func _remove_old_ground() -> void:
	set_cell(0, old_tile_position, -1)
	set_cell(0, old_tile_position + Vector2i.DOWN, -1)
	old_tile_position += Vector2i.RIGHT


func _place_new_pipe() -> void:
	var random_pattern_index: int = randi() % (pipe_pattern_amount - 1)
	var random_pattern: TileMapPattern = tile_set.get_pattern(random_pattern_index)
	set_pattern(0, new_pipe_position, random_pattern)

	var detector: Area2D = detector_scene.instantiate()
	detector.position = map_to_local(new_pipe_position) + detector_offset
	detector_stack.append(detector)
	add_child(detector)

	pipe_stack.append(new_pipe_position)
	new_pipe_position += PIPE_SEP * Vector2i.RIGHT


func _remove_old_pipe() -> void:
	var current_pipe_tile: Vector2i = pipe_stack.pop_front()
	var c: int = 0
	while c < _pipe_size:
		erase_cell(0, current_pipe_tile)
		# needs to be DOWN because of inverted coordinates on y
		current_pipe_tile += Vector2i.DOWN
		c += 1

	var detector: Area2D = detector_stack.pop_front()
	remove_child(detector)
	detector.queue_free()


func _on_ground_stopped_colliding() -> void:
	_place_new_ground()

	tiles_since_last_pipe += 1
	if tiles_since_last_pipe == PIPE_SEP:
		_place_new_pipe()
		tiles_since_last_pipe = 0


func _on_ground_started_colliding() -> void:
	_remove_old_ground()


func _on_pipe_started_colliding() -> void:
	_remove_old_pipe()
