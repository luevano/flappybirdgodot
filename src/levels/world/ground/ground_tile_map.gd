class_name GroundTileMap
extends TileMap

enum Ground {
	TILE_1,
	TILE_2,
	TILE_3,
	TILE_DOWN_1,
}

# old_tile is the actual first tile, whereas the new_tile_position
#	is the the next empty tile; these also correspond to the top tile
const _ground_level: int = 7
const _initial_old_tile_x: int = -8
const _initial_new_tile_x: int = 11
var old_tile_position: Vector2 = Vector2(_initial_old_tile_x, _ground_level)
var new_tile_position: Vector2 = Vector2(_initial_new_tile_x, _ground_level)


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


func _on_world_tiles_place_ground() -> void:
	_place_new_ground()


func _on_world_tiles_remove_ground() -> void:
	_remove_first_ground()
