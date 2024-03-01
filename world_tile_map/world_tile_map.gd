class_name WorldTileMap
extends TileMap

# old_tile is the actual first tile, whereas the new_tile_position
#	is the the next empty tile; these also correspond to the top tile
const _INITIAL_OLD_TILE_X: int = -8
const _INITIAL_NEW_TILE_X: int = 11
const _PIPE_SIZE: int = 16
const _GROUND_LEVEL: int = 7
const _PIPE_LEVEL_Y: int = -_PIPE_SIZE + _GROUND_LEVEL
const _INITIAL_NEW_PIPE_X: int = 11

@export_range(1.0, 150.0, 1.0) var speed: float = 60.0
@export_range(2, 20, 2) var pipe_sep: int = 6
@export var detector_scene: PackedScene

var ground_tiles_amount: int = 3
var ground_bottom_tile: Vector2i = Vector2i(4, 5)
var pipe_pattern_amount: int = 6
var tiles_since_last_pipe: int = pipe_sep - 1
var old_tile_position: Vector2i = Vector2i(_INITIAL_OLD_TILE_X, _GROUND_LEVEL)
var new_tile_position: Vector2i = Vector2i(_INITIAL_NEW_TILE_X, _GROUND_LEVEL)
var new_pipe_position: Vector2i = Vector2i(_INITIAL_NEW_PIPE_X, _PIPE_LEVEL_Y)
var pipe_stack: Array
var detector_offset: Vector2 = Vector2(0.0, (256.0 / 2.0) - (16.0 / 2.0))
var detector_stack: Array


func _ready():
	set_physics_process(false)
	Event.game_start.connect(set_physics_process.bind(true))
	Event.game_over.connect(set_physics_process.bind(false))
	Event.game_pause.connect(set_physics_process)
	Event.ground_stopped_colliding.connect(_place_new_ground)
	Event.ground_started_colliding.connect(_remove_old_ground)
	Event.pipe_started_colliding.connect(_remove_old_pipe)


func _physics_process(delta: float):
	move_local_x(-speed * delta)


func _place_new_ground():
	var random_tile_index: int = randi_range(1, ground_tiles_amount)
	var random_tile: Vector2i = Vector2i(random_tile_index, 5)
	set_cell(0, new_tile_position, 0, random_tile)
	set_cell(0, new_tile_position + Vector2i.DOWN, 0, ground_bottom_tile)
	new_tile_position += Vector2i.RIGHT

	tiles_since_last_pipe += 1
	if tiles_since_last_pipe == pipe_sep:
		_place_new_pipe()
		tiles_since_last_pipe = 0


func _remove_old_ground():
	set_cell(0, old_tile_position, -1)
	set_cell(0, old_tile_position + Vector2i.DOWN, -1)
	old_tile_position += Vector2i.RIGHT


func _place_new_pipe():
	var random_pattern_index: int = randi() % (pipe_pattern_amount - 1)
	var random_pattern: TileMapPattern = tile_set.get_pattern(random_pattern_index)
	set_pattern(0, new_pipe_position, random_pattern)

	var detector: Area2D = detector_scene.instantiate()
	detector.position = map_to_local(new_pipe_position) + detector_offset
	detector_stack.append(detector)
	add_child(detector)

	pipe_stack.append(new_pipe_position)
	new_pipe_position += pipe_sep * Vector2i.RIGHT


func _remove_old_pipe():
	var current_pipe_tile: Vector2i = pipe_stack.pop_front()
	var c: int = 0
	while c < _PIPE_SIZE:
		erase_cell(0, current_pipe_tile)
		# needs to be DOWN because of inverted coordinates on y
		current_pipe_tile += Vector2i.DOWN
		c += 1

	var detector: Area2D = detector_stack.pop_front()
	remove_child(detector)
	detector.queue_free()
