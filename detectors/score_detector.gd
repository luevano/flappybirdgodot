class_name ScoreDetector
extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	Event.player_score.emit()
