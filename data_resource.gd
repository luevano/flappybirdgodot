class_name DataResource
extends Resource

@export var high_score: int
@export var volume: float
@export var mute: bool
@export var bird: int
@export var background: int


func _init():
	high_score = 0
	volume = 0.5
	mute = false
	bird = 0
	background = 0
