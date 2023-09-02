class_name Audio
extends Node2D

@export var audio_bus_name: String = "Master"

@onready var _bus: int = AudioServer.get_bus_index(audio_bus_name)
@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var dead_sound: AudioStreamPlayer = $DeadSound

@onready var _mute: bool = Data.get_mute()
@onready var _volume: float = Data.get_volume()


func _ready():
	_on_set_mute(_mute)
	_on_set_volume(_volume)

	Event.set_mute.connect(_on_set_mute)
	Event.set_volume.connect(_on_set_volume)
	Event.game_start.connect(_on_game_start)
	Event.player_jump.connect(_on_player_jump)
	Event.player_score.connect(_on_player_score)
	Event.player_collide.connect(_on_player_collide)
	# play death sound after hit sound finishes
	hit_sound.finished.connect(_on_HitSound_finished)


func _on_set_mute(mute: bool):
	AudioServer.set_bus_mute(_bus, mute)
	Data.set_mute(mute)
	Data.save_data()


func _on_set_volume(linear_volume: float):
	var db_volume: float = linear_to_db(linear_volume)
	AudioServer.set_bus_volume_db(_bus, db_volume)
	Data.set_volume(linear_volume)
	Data.save_data()


func _on_game_start():
	start_sound.play()


func _on_player_jump():
	jump_sound.play()


func _on_player_score():
	score_sound.play()


func _on_player_collide():
	hit_sound.play()


func _on_HitSound_finished():
	dead_sound.play()
