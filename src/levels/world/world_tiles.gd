class_name WorldTiles
extends Node2D

signal place_ground
signal remove_ground
signal place_pipe
signal remove_pipe

@export var PIPE_SEP: int = 6 # (int, 2, 20, 2)

@onready var ground_tile_map: GroundTileMap = $GroundTileMap
@onready var pipe_tile_map: PipeTileMap = $PipeTileMap

var tiles_since_last_pipe: int = PIPE_SEP - 1


func _ready() -> void:
    connect("place_ground", Callable(ground_tile_map, "_on_WorldTiles_place_ground"))
    connect("remove_ground", Callable(ground_tile_map, "_on_WorldTiles_remove_ground"))
    connect("place_pipe", Callable(pipe_tile_map, "_on_WorldTiles_place_pipe"))
    connect("remove_pipe", Callable(pipe_tile_map, "_on_WorldTiles_remove_pipe"))


func _on_WorldDetector_ground_stopped_colliding() -> void:
    emit_signal("place_ground")

    tiles_since_last_pipe += 1
    if tiles_since_last_pipe == PIPE_SEP:
        emit_signal("place_pipe")
        tiles_since_last_pipe = 0


func _on_WorldDetector_ground_started_colliding() -> void:
    emit_signal("remove_ground")


func _on_WorldDetector_pipe_started_colliding() -> void:
    emit_signal("remove_pipe")
