extends Node2D

@export var audio_bus_name: String = "Master"

@onready var _bus: int = AudioServer.get_bus_index(audio_bus_name)
@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var dead_sound: AudioStreamPlayer = $DeadSound


func _ready():
	Event.set_volume.connect(_on_set_volume)
	Event.game_start.connect(_on_game_start)
	Event.player_jump.connect(_on_player_jump)
	Event.player_score.connect(_on_player_score)
	Event.player_collide.connect(_on_player_collide)
	hit_sound.finished.connect(_on_HitSound_finished)


func _on_set_volume(linear_volume: float) -> void:
	var db_volume: float = linear_to_db(linear_volume)
	AudioServer.set_bus_volume_db(_bus, db_volume)


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
