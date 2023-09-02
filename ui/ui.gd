class_name UI
extends CanvasLayer

@export var version_label: Label
@export var score_label: Label
@export var high_score_label: Label
@export var start_game_label: Label

@onready var _initial_high_score: int = Data.get_high_score()


func _ready():
	version_label.set_text("v%s" % Global.VERSION)
	high_score_label.set_text("High score: %s" % _initial_high_score)

	Event.game_start.connect(_on_game_start)
	Event.game_over.connect(_on_game_over)
	Event.new_score.connect(_on_new_score)


func _on_game_start():
	start_game_label.visible = false
	high_score_label.visible = false


func _on_game_over():
	start_game_label.set_text("Press R to restart")
	start_game_label.visible = true
	high_score_label.visible = true


func _on_new_score(score: int, high_score: int):
	score_label.set_text(str(score))
	high_score_label.set_text("High score: %s" % high_score)
