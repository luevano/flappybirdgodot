class_name Audio
extends Node2D

@export var audio_bus_name: String = "Master"

@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var dead_sound: AudioStreamPlayer = $DeadSound
@onready var _bus: int = AudioServer.get_bus_index(audio_bus_name)
@onready var _mute: bool = Data.get_mute()
@onready var _volume: float = Data.get_volume()


func _ready():
	_on_set_mute(_mute)
	_on_set_volume(_volume)

	Event.set_mute.connect(_on_set_mute)
	Event.set_volume.connect(_on_set_volume)
	Event.game_start.connect(start_sound.play)
	Event.player_jump.connect(jump_sound.play)
	Event.player_score.connect(score_sound.play)
	Event.player_collide.connect(hit_sound.play)
	# play death sound after hit sound finishes
	hit_sound.finished.connect(dead_sound.play)


func _on_set_mute(mute: bool):
	AudioServer.set_bus_mute(_bus, mute)
	Data.set_mute(mute)
	Data.save()


func _on_set_volume(linear_volume: float):
	var db_volume: float = linear_to_db(linear_volume)
	AudioServer.set_bus_volume_db(_bus, db_volume)
	Data.set_volume(linear_volume)
	Data.save()
