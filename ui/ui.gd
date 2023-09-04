class_name UI
extends CanvasLayer

@export var version: Label
@export var score_label: Label
@export var pregame_start: VBoxContainer
@export var high_score: Label
@export var game_over_panel: GameOverPanel
@export var touch: TouchScreenButton

@onready var _initial_high_score: int = Data.get_high_score()


func _ready():
	Event.game_start.connect(_on_game_start)
	Event.game_over.connect(_on_game_over)
	Event.new_score.connect(_on_new_score)

	game_over_panel.visible = false
	version.set_text("v%s" % Global.VERSION)
	high_score.set_text(Global.HS_TEXT % _initial_high_score)


func _on_game_start():
	pregame_start.visible = false


func _on_game_over():
	touch.visible = false
	game_over_panel.visible = true


func _on_new_score(score: int, _high_score: int):
	score_label.set_text(str(score))
