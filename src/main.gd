class_name Main
extends Node2D

onready var game: Game = $Game
onready var ui: UI = $UI

var _game_over: bool = false


func _ready() -> void:
	game.connect("game_started", ui, "_on_Game_game_started")
	game.connect("game_over", ui, "_on_Game_game_over")
	game.connect("new_score", ui, "_on_Game_new_score")
