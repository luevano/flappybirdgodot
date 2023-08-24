extends Node2D

@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var dead_sound: AudioStreamPlayer = $DeadSound

# Called when the node enters the scene tree for the first time.
func _ready():
	Event.game_start.connect(_on_game_start)
	Event.player_jump.connect(_on_player_jump)
	Event.player_score.connect(_on_player_score)
	Event.player_collide.connect(_on_player_collide)
	hit_sound.finished.connect(_on_HitSound_finished)


func _on_game_start() -> void:
	start_sound.play()


func _on_player_jump() -> void:
	jump_sound.play()


func _on_player_score() -> void:
	score_sound.play()


func _on_player_collide() -> void:
	hit_sound.play()


func _on_HitSound_finished() -> void:
	dead_sound.play()
