class_name UI
extends CanvasLayer

@onready var fps_label: Label = $MarginContainer/DebugContainer/FPS
@onready var version_label: Label = $MarginContainer/VersionContainer/Version
@onready var score_label: Label = $MarginContainer/InfoContainer/ScoreContainer/Score
@onready var high_score_label: Label = $MarginContainer/InfoContainer/ScoreContainer/HighScore
@onready var start_game_label: Label = $MarginContainer/InfoContainer/StartGame

@onready var _initial_high_score: int = SavedData.get_high_score()
var _version: String = ProjectSettings.get_setting("application/config/version")


func _ready() -> void:
	fps_label.visible = false
	version_label.set_text("v%s" % _version)
	high_score_label.set_text("High score: %s" % _initial_high_score)

	Event.game_start.connect(_on_game_start)
	Event.game_over.connect(_on_game_over)
	Event.new_score.connect(_on_new_score)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		fps_label.visible = !fps_label.visible


func _process(delta: float) -> void:
	if fps_label.visible:
		fps_label.set_text("FPS: %d" % Performance.get_monitor(Performance.TIME_FPS))


func _on_game_start() -> void:
	start_game_label.visible = false
	high_score_label.visible = false


func _on_game_over() -> void:
	start_game_label.set_text("Press R to restart")
	start_game_label.visible = true
	high_score_label.visible = true


func _on_new_score(score: int, high_score: int) -> void:
	score_label.set_text(str(score))
	high_score_label.set_text("High score: %s" % high_score)
