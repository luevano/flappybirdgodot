class_name Main
extends Node2D

var window: Window


func _ready() -> void:
	window = get_tree().root
	if Global.INIT_WINDOW_SIZE == Vector2(-1, -1):
		Global.INIT_WINDOW_SIZE = window.size
	window.size = Global.INIT_WINDOW_SIZE * 2.0
